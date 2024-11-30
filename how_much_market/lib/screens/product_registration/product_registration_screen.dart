import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class ProductRegistrationScreen extends StatefulWidget {
  const ProductRegistrationScreen({super.key});

  @override
  _ProductRegistrationScreenState createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  String saleType = 'auction'; // 기본값: 경매
  int auctionDuration = 1;
  DateTime auctionEndTime = DateTime.now().add(const Duration(days: 1));
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  File? _image; // 사진 파일을 저장할 변수

  // 상품 등록 API 호출
  Future<void> registerProduct() async {
    const String apiUrl = 'http://13.125.107.235/api/product';

    // 입력값 검증
    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목, 가격, 거래 희망 장소를 입력해주세요.')),
      );
      return;
    }

    // 요청 데이터 생성
    final Map<String, dynamic> requestData = {
      'name': titleController.text,
      'price': int.parse(priceController.text),
      'dealTime': auctionEndTime.toIso8601String(),
      'locationDTO': {
        'longitude': 22.22, // 예시 값, 실제로 사용자 입력 또는 위치 정보를 반영하세요
        'latitude': 33.33, // 예시 값
        'zipcode': null,
        'address': locationController.text,
        'addressDetail': null,
      },
      'productDetail': descriptionController.text,
      'onAuction': saleType == 'auction',
    };

    // 경매 데이터 추가
    if (saleType == 'auction') {
      requestData['auctionDTO'] = {
        'startPrice': int.parse(priceController.text), // 경매 시작 가격
        'startTime': DateTime.now().toIso8601String(), // 현재 시간을 시작 시간으로 설정
        'endTime': auctionEndTime.toIso8601String(), // 계산된 경매 종료 시간
      };
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken'); // 저장된 인증 토큰 가져오기
      final userId = prefs.getString('userId'); // 사용자 ID 가져오기

      if (token == null) {
        throw Exception('인증 토큰을 찾을 수 없습니다. 다시 로그인해주세요.');
      }

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("유저 ID가 없습니다.")),
        );
        return;
      } else {
        print("유저아이디 : $userId");
      }

      // 요청 데이터에 userId 추가
      requestData['userId'] = userId;

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // 인증 헤더 추가
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 상품이 등록되면, 이미지 업로드
        await uploadImage(json.decode(response.body)['id']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상품이 성공적으로 등록되었습니다.')),
        );
        Navigator.pop(context);
      } else {
        // 서버에서 실패 응답 처리
        final errorResponse = json.decode(response.body);
        throw Exception('상품 등록 실패: ${errorResponse['message'] ?? '알 수 없는 오류'}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품 등록 실패: $e')),
      );
    }
  }

  // 이미지 업로드
  Future<void> uploadImage(int productId) async {
    if (_image == null) {
      return;
    }

    final String apiUrl = 'http://13.125.107.235/api/product/$productId/image';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');

      final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers['Authorization'] = 'Bearer $token' // 인증 헤더 추가
        ..files.add(await http.MultipartFile.fromPath(
          'images',
          _image!.path,
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
      } else {
        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // 이미지 선택
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

            // 제목 입력
            _buildTextField(
              controller: titleController,
              label: '제목*',
              hint: '상품 제목을 입력하세요',
              theme: theme,
            ),

            // 가격 입력
            _buildTextField(
              controller: priceController,
              label: '가격*',
              hint: saleType == 'auction' ? '경매 시작 가격을 입력하세요' : '가격을 입력하세요',
              theme: theme,
              keyboardType: TextInputType.number,
            ),

            // 경매 기간 설정
            if (saleType == 'auction')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text('경매 기간', style: theme.textTheme.titleMedium),
                  DropdownButtonFormField<int>(
                    value: auctionDuration,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: [1, 3, 7]
                        .map((day) => DropdownMenuItem(
                              value: day,
                              child: Text('$day일'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          auctionDuration = value;
                          auctionEndTime = DateTime.now().add(
                            Duration(days: auctionDuration),
                          );
                        });
                      }
                    },
                  ),
                ],
              ),

            // 설명 입력
            _buildTextField(
              controller: descriptionController,
              label: '상품 설명',
              hint: '상품 설명을 입력하세요',
              theme: theme,
              maxLines: 4,
            ),

            // 거래 희망 장소
            _buildTextField(
              controller: locationController,
              label: '거래 희망 장소*',
              hint: '거래 희망 장소를 입력하세요',
              theme: theme,
            ),

            // 사진 선택 버튼
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('사진 선택'),
            ),

            // 선택된 사진 미리보기
            if (_image != null)
              Image.file(
                _image!,
                width: screenWidth * 0.8,
                height: screenHeight * 0.3,
                fit: BoxFit.cover,
              ),

            // 등록 버튼
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
