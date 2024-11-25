import 'dart:convert';
import 'package:http/http.dart' as http;

class BidService {
  final String baseUrl = 'http://13.125.107.235/';

  Future<void> createAuction(int productId) async {
    final url = Uri.parse('${baseUrl}api/auction/create');
    final response =
        await http.post(url, body: jsonEncode({'productId': productId}));

    if (response.statusCode != 200) {
      throw Exception('Failed to create auction.');
    }
  }

  Future<void> placeBid(int productId, double bidAmount) async {
    final url = Uri.parse('${baseUrl}api/auction/bid');
    final response = await http.post(url,
        body: jsonEncode({'productId': productId, 'bidAmount': bidAmount}));

    if (response.statusCode != 200) {
      throw Exception('Failed to place bid.');
    }
  }

  Future<List<dynamic>> getMyBids() async {
    final url = Uri.parse('${baseUrl}api/auction/bid');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch my bids.');
    }
  }

  Future<Map<String, dynamic>> getProductBids(int productId) async {
    final url = Uri.parse('${baseUrl}api/auction/product/$productId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch product bids.');
    }
  }
}
