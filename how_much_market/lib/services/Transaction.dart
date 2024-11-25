import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  final String baseUrl = 'http://13.125.107.235/';

  Future<void> purchaseProduct(int productId) async {
    final url = Uri.parse('${baseUrl}api/transaction/purchase');
    final response =
        await http.post(url, body: jsonEncode({'productId': productId}));

    if (response.statusCode != 200) {
      throw Exception('Failed to process purchase.');
    }
  }

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
