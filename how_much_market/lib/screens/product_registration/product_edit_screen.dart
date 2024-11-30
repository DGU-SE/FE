import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductEditScreen extends StatefulWidget {
  final int productId;

  const ProductEditScreen({super.key, required this.productId});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    // Here you can implement the API call to load product details by widget.productId
    // and initialize the controllers with the fetched data.
    // For example:
    // final response = await http.get(Uri.parse('http://13.125.107.235/api/product/${widget.productId}'));
    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   setState(() {
    //     titleController.text = data['name'];
    //     priceController.text = data['price'].toString();
    //     descriptionController.text = data['productDetail'];
    //     locationController.text = data['locationDTO']['address'];
    //   });
    // }
  }

  Future<void> updateProduct() async {
    final String apiUrl =
        'http://13.125.107.235/api/product/${widget.productId}';

    if (titleController.text.isEmpty ||
        priceController.text.isEmpty ||
        locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제목, 가격, 거래 희망 장소를 입력해주세요.')),
      );
      return;
    }

    final Map<String, dynamic> requestData = {
      'name': titleController.text,
      'price': int.parse(priceController.text),
      'dealTime': '2024-12-15T10:00:00',
      'locationDTO': {
        'longitude': 40.00,
        'latitude': 50.00,
        'zipcode': '12345',
        'address': locationController.text,
        'addressDetail': 'Updated Address Detail',
      },
      'productDetail': descriptionController.text,
      'onAuction': false,
      'userId': 'unique-user-id',
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
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상품이 성공적으로 수정되었습니다.')),
        );
        Navigator.pop(context);
      } else {
        final errorResponse = json.decode(response.body);
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
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: updateProduct,
                child: const Text('수정하기'),
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
