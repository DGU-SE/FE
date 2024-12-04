import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class ProductEditScreen extends StatefulWidget {
  final int productId;

  const ProductEditScreen({super.key, required this.productId});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  String dealTime = '';
  double longitude = 38.0;
  double latitude = 125.0;
  String zipcode = '';
  bool onAuction = false;
  String userId = '';
  String addressDetail = '';
  String location = '';
  int price = 0;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userId') ?? '';
      final response = await http.get(
        Uri.parse('http://13.125.107.235/api/product/${widget.productId}'),
        headers: {
          HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          titleController.text = data['name'];
          descriptionController.text = data['productDetail'];
          priceController.text = data['price'].toString();
          dealTime = data['dealTime'];
          longitude = 12.0;
          latitude = 37.0;
          zipcode = data['locationDTO']['zipcode'];
          onAuction = data['onAuction'];
          userId = data['userId'];
          addressDetail = data['locationDTO']['addressDetail'];
          location = data['locationDTO']['address'];
          price = data['price'];
        });
      }
    } catch (e) {
      // 오류가 발생해도 아무것도 표시하지 않음
    }
  }

  Future<void> updateProduct() async {
    final String apiUrl =
        'http://13.125.107.235/api/product/alter/${widget.productId}';

    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목과 상품 설명을 입력해주세요.')),
      );
      return;
    }

    final Map<String, dynamic> requestData = {
      'name': titleController.text,
      'price': int.parse(priceController.text),
      'dealTime': dealTime,
      'locationDTO': {
        'longitude': longitude,
        'latitude': latitude,
        'zipcode': zipcode,
        'address': location,
        'addressDetail': addressDetail,
      },
      'productDetail': descriptionController.text,
      'onAuction': onAuction,
      'userId': userId,
    };

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('authToken');

      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('인증 토큰을 찾을 수 없습니다. 다시 로그인해주세요.')),
        );
        return;
      }

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
        body: utf8.encode(json.encode(requestData)),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상품이 성공적으로 수정되었습니다.')),
        );
        Navigator.pop(context);
      } else {
        final errorResponse = json.decode(utf8.decode(response.bodyBytes));
        final String errorMessage = errorResponse['message'] ?? '알 수 없는 오류';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('상품 수정 실패: $errorMessage')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품 수정 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('상품 수정'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: titleController,
              label: '제목*',
              hint: '상품 제목을 입력하세요',
              theme: theme,
            ),
            _buildTextField(
              controller: priceController,
              label: '가격*',
              hint: '상품 가격을 입력하세요',
              theme: theme,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              controller: descriptionController,
              label: '상품 설명*',
              hint: '상품 설명을 입력하세요',
              theme: theme,
              maxLines: 4,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // 흰색 글자
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold, // 볼드 글씨체
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // 끝이 둥근 직사각형
                  ),
                  minimumSize: const Size(double.infinity, 50), // 가로로 길게
                ),
                onPressed: updateProduct,
                child: const Text(
                  '수정하기',
                  style: TextStyle(fontSize: 18),
                ),
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
}
