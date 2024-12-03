import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:io';

class ProductRegistrationScreen extends StatefulWidget {
  const ProductRegistrationScreen({super.key});

  @override
  _ProductRegistrationScreenState createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  String saleType = 'auction';
  DateTime auctionEndTime = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  File? _image;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: auctionEndTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (picked != null) {
      final newDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      if (newDateTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('경매 종료 시간은 현재 시간 이후여야 합니다.')),
        );
        return;
      }

      setState(() {
        auctionEndTime = newDateTime;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      final newDateTime = DateTime(
        auctionEndTime.year,
        auctionEndTime.month,
        auctionEndTime.day,
        picked.hour,
        picked.minute,
      );

      if (newDateTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('경매 종료 시간은 현재 시간 이후여야 합니다.')),
        );
        return;
      }

      setState(() {
        selectedTime = picked;
        auctionEndTime = newDateTime;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> registerProduct() async {
    const String apiUrl = 'http://13.125.107.235/api/product';

    if (saleType == 'auction' && auctionEndTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('경매 종료 시간을 확인해주세요. 현재 시간 이후로 설정해야 합니다.')),
      );
      return;
    }

    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목, 가격, 거래 희망 장소를 입력해주세요.')),
      );
      return;
    }

    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('위치 정보를 가져오는 중입니다. 잠시만 기다려주세요.')),
      );
      return;
    }

    final Map<String, dynamic> requestData = {
      'name': titleController.text,
      'price': int.parse(priceController.text),
      'dealTime': auctionEndTime.toIso8601String(),
      'locationDTO': {
        'longitude': _currentPosition!.longitude,
        'latitude': _currentPosition!.latitude,
        'zipcode': null,
        'address': locationController.text,
        'addressDetail': null,
      },
      'productDetail': descriptionController.text,
      'onAuction': saleType == 'auction',
    };

    if (saleType == 'auction') {
      requestData['auctionDTO'] = {
        'startPrice': int.parse(priceController.text),
        'startTime': DateTime.now().toIso8601String(),
        'endTime': auctionEndTime.toIso8601String(),
      };
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      final userId = prefs.getString('userId');

      if (token == null) {
        throw Exception('인증 토큰을 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("유저 ID가 없습니다.")),
        );
        return;
      }

      requestData['userId'] = userId;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final productId = json.decode(response.body)['id'];
          await uploadImage(productId); // 이미지 업로드 완료를 기다림
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('상품이 성공적으로 등록되었습니다.')),
          );
          Navigator.pop(context, true);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미지 업로드 실패: $e')),
          );
          // 이미지 업로드 실패 시에도 상품은 등록된 상태이므로 화면을 닫음
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품 등록 실패: $e')),
      );
    }
  }

  Future<void> uploadImage(int productId) async {
    if (_image == null) {
      return;
    }

    final String apiUrl = 'http://13.125.107.235/api/product/$productId/image';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath(
          'images',
          _image!.path,
        ));

      // 응답 처리 수정
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        print('Response body: ${response.body}');
      } else {
        print('Failed to upload image: ${response.statusCode}');
        print('Error response: ${response.body}');
        throw Exception(
            'Image upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e; // 에러를 다시 던져서 상위에서 처리할 수 있도록 함
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("상품 등록"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('판매 방식', style: theme.textTheme.titleMedium),
            Row(
              children: [
                _buildRadioButton('경매', 'auction', theme),
                _buildRadioButton('즉시판매', 'direct', theme),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: titleController,
              label: '제목*',
              hint: '상품 제목을 입력하세요',
              theme: theme,
            ),
            _buildTextField(
              controller: priceController,
              label: '가격*',
              hint: saleType == 'auction' ? '경매 시작 가격을 입력하세요' : '가격을 입력하세요',
              theme: theme,
              keyboardType: TextInputType.number,
            ),
            if (saleType == 'auction')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text('경매 종료 시간', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            '${auctionEndTime.year}-${auctionEndTime.month.toString().padLeft(2, '0')}-${auctionEndTime.day.toString().padLeft(2, '0')}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColorLight,
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _selectTime(context),
                          icon: const Icon(Icons.access_time),
                          label: Text(
                            '${auctionEndTime.hour.toString().padLeft(2, '0')}:${auctionEndTime.minute.toString().padLeft(2, '0')}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColorLight,
                            foregroundColor: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '선택된 종료 시간: ${auctionEndTime.toString()}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            _buildTextField(
              controller: descriptionController,
              label: '상품 설명',
              hint: '상품 설명을 입력하세요',
              theme: theme,
              maxLines: 4,
            ),
            _buildTextField(
              controller: locationController,
              label: '거래 희망 장소*',
              hint: '거래 희망 장소를 입력하세요',
              theme: theme,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('사진 선택'),
            ),
            if (_image != null)
              Image.file(
                _image!,
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: registerProduct,
                child: const Text('등록하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required ThemeData theme,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: theme.primaryColorLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildRadioButton(String label, String value, ThemeData theme) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => saleType = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: saleType == value ? theme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: saleType == value ? theme.primaryColor : Colors.black38,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                saleType == value
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: saleType == value ? Colors.white : Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: saleType == value ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
