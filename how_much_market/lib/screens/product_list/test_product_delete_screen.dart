import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProductDeleteScreen extends StatefulWidget {
  const ProductDeleteScreen({super.key});

  @override
  _ProductDeleteScreenState createState() => _ProductDeleteScreenState();
}

class _ProductDeleteScreenState extends State<ProductDeleteScreen> {
  final TextEditingController _productIdController = TextEditingController();
  String _responseMessage = '';

  // 삭제 요청을 보내는 함수
  Future<void> deleteProduct(String productId, String authToken) async {
    final url =
        Uri.parse('http://13.125.107.235/api/product/delete/$productId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': authToken,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _responseMessage = '제품 삭제 성공: ${json.decode(response.body)}';
        });
      } else {
        setState(() {
          _responseMessage = '삭제 요청 실패: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = '오류 발생: $e';
      });
    }
  }

  // SharedPreferences에서 토큰을 가져오는 함수
  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? ''; // 기본값은 빈 문자열
  }

  // 삭제 버튼 클릭 시 실행되는 함수
  void _handleDelete() async {
    final productId = _productIdController.text;
    if (productId.isEmpty) {
      setState(() {
        _responseMessage = '제품 ID를 입력하세요.';
      });
      return;
    }

    // SharedPreferences에서 토큰 가져오기
    String authToken = await getAuthToken();

    if (authToken.isEmpty) {
      setState(() {
        _responseMessage = '인증 토큰이 없습니다.';
      });
      return;
    }

    // 제품 삭제 요청 보내기
    deleteProduct(productId, authToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제품 삭제'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _productIdController,
              decoration: const InputDecoration(
                labelText: '삭제할 제품 ID',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleDelete,
              child: const Text('삭제'),
            ),
            const SizedBox(height: 20),
            Text(
              _responseMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
