import 'dart:convert';
import 'package:how_much_market/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'http://13.125.107.235/';

  Future<void> registerProduct(Product product) async {
    final url = Uri.parse('${baseUrl}api/product');
    final response = await http.post(url, body: jsonEncode(product.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to register product.');
    }
  }

  Future<void> updateProduct(int productId, Product product) async {
    final url = Uri.parse('${baseUrl}api/product/$productId');
    final response = await http.put(url, body: jsonEncode(product.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to update product.');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final url = Uri.parse('${baseUrl}api/product/$productId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product.');
    }
  }

  Future<List<Product>> getMyProducts() async {
    final url = Uri.parse('${baseUrl}api/product/my');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> products = jsonDecode(response.body);
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch my products.');
    }
  }

  Future<Product> getProductDetail(int productId) async {
    final url = Uri.parse('${baseUrl}api/product/$productId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch product details.');
    }
  }

  Future<List<Product>> searchProducts(String keyword) async {
    final url = Uri.parse('${baseUrl}api/product/search?keyword=$keyword');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> products = jsonDecode(response.body);
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search products.');
    }
  }

  Future<void> uploadImage(int productId, String imagePath) async {
    final url = Uri.parse('${baseUrl}api/product/$productId/image');
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload image.');
    }
  }

  Future<dynamic> getImage(String blobUrl) async {
    final url = Uri.parse('${baseUrl}api/product/image/$blobUrl');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch image.');
    }
  }
}
