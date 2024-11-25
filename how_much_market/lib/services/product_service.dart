import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<List<Map<String, dynamic>>> fetchProducts({
    required String keyword,
    required double latitude,
    required double longitude,
    required int lowBound,
    required int upBound,
    required String productStatus,
  }) async {
    try {
      final Uri uri = Uri.parse(
        'http://13.125.107.235/api/product/search',
      ).replace(queryParameters: {
        'keyword': keyword,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'lowBound': lowBound.toString(),
        'upBound': upBound.toString(),
        'productStatus': productStatus,
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final responseBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩
        List<dynamic> data = jsonDecode(responseBody);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch products: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
