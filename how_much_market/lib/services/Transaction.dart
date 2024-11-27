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
      throw Exception('Failed to process purchase.');
    }
  }

  // 응찰하기
  Future<void> placeBid(int auctionId, double amount, String token) async {
    final url = Uri.parse('${baseUrl}api/auction/bid');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': 'unique-user-id', // 실제 사용자 ID로 변경해야 함
        'auctionId': auctionId,
        'amount': amount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to place bid.');
    }
  }

  // 구매한 상품 리스트 조회
  Future<List<dynamic>> getPurchasedProducts() async {
    final url = Uri.parse('${baseUrl}api/transaction/purchased');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch purchased products.');
    }
  }
}
