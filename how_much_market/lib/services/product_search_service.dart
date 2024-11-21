import 'dart:convert';
import 'package:how_much_market/models/product_search_model.dart';
import 'package:http/http.dart' as http;

class ProductSearchService {
  final String baseUrl;

  ProductSearchService({required this.baseUrl});

  Future<List<ProductSearch>> fetchProducts({
    required String keyword,
    required double latitude,
    required double longitude,
    required int lowBound,
    required int upBound,
    required String productStatus,
  }) async {
    final queryParams = {
      'keyword': keyword,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'lowBound': lowBound.toString(),
      'upBound': upBound.toString(),
      'productStatus': productStatus,
    };

    final uri = Uri.parse('$baseUrl/api/product/search')
        .replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => ProductSearch.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch products: ${response.statusCode}');
    }
  }
}
