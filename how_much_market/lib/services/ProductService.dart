import 'dart:convert';
import 'package:how_much_market/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final String baseUrl = 'http://13.125.107.235/';

  // 제품 등록 함수
  Future<Map<String, dynamic>> registerProduct({
    required String name,
    required int price,
    required DateTime dealTime,
    required double latitude,
    required double longitude,
    required String productDetail,
    required bool onAuction,
    required String userId,
  }) async {
    // 요청 데이터 준비
    final Map<String, dynamic> requestData = {
      'name': name,
      'price': price,
      'dealTime': dealTime.toIso8601String(),
      'locationDTO': {
        'longitude': 22.2,
        'latitude': 33.3,
        'zipcode': null,
        'address': '주소 문자열', // 실제 주소 값으로 바꿔야 함
        'addressDetail': null
      },
      'productDetail': productDetail,
      'onAuction': onAuction,
      'userId': userId,
    };

    // API 요청
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}api/product'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '••••••', // 실제 Authorization token을 여기에 입력
        },
        body: json.encode(requestData),
      );

      // 응답 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        // 성공적으로 등록된 경우 응답 데이터 반환
        return json.decode(response.body);
      } else {
        // 실패한 경우 예외 발생
        throw Exception('Failed to register product');
      }
    } catch (e) {
      // 예외 처리
      throw Exception('Error registering product: $e');
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

  Future<List<Product>> searchProducts(
      String keyword, double l, double d, int i, int j, String s) async {
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

Future<List<Product>> searchProducts(String keyword, double latitude,
    double longitude, int lowBound, int upBound, String productStatus) async {
  final response = await http.get(Uri.parse(
      'http://13.125.107.235/api/product/search?keyword=$keyword&latitude=$latitude&longitude=$longitude&lowBound=$lowBound&upBound=$upBound&productStatus=$productStatus'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((productData) => Product.fromJson(productData)).toList();
  } else {
    throw Exception('Failed to load products');
  }
}
