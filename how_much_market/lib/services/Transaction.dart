import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  final String baseUrl = 'http://13.125.107.235/';

  // 상품 구매
  Future<void> purchaseProduct(int productId, String token) async {
    final url = Uri.parse('${baseUrl}api/transaction/purchase');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'productId': productId}),
    );

    if (response.statusCode != 200) {
      print('응답 본문: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to process purchase: ${response.body}');
    }
  }

  // 응찰하기
  Future<void> placeBid(String userId, int productId, double amount) async {
    final Map<String, dynamic> requestBody = {
      'userId': userId,
      'productId': productId,
      'amount': amount.toInt(), // amount는 정수 형태로 전달
    };

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}api/auction/bid'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('서버 응답: ${response.body}'); // 서버 응답 내용 출력

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('응찰 성공: ${response.body}');
        // 성공 응답 처리
      } else {
        // 서버에서 오류가 발생한 경우
        print('응찰 실패: ${response.body}'); // 실패 메시지 확인
        throw Exception('응찰 실패: ${response.body}');
      }
    } catch (e) {
      // 네트워크 오류 또는 기타 예외 처리
      throw Exception('응찰 요청 중 오류 발생: $e');
    }
  }
}
