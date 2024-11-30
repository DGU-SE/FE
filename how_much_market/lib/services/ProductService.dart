import 'dart:convert';
import 'package:how_much_market/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

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
    double? startPrice, // 경매 시작 가격 (옵션)
    DateTime? auctionStartTime, // 경매 시작 시간 (옵션)
    DateTime? auctionEndTime, // 경매 종료 시간 (옵션)
  }) async {
    // 요청 데이터 준비
    final Map<String, dynamic> requestData = {
      'name': name,
      'price': price,
      'dealTime': dealTime.toIso8601String(),
      'locationDTO': {
        'longitude': longitude,
        'latitude': latitude,
        'zipcode': null,
        'address': '주소 문자열', // 실제 주소 값으로 바꿔야 함
        'addressDetail': null,
      },
      'productDetail': productDetail,
      'onAuction': onAuction,
      'userId': userId,
      // 경매 데이터 추가
      if (onAuction)
        'auctionDTO': {
          'startPrice': startPrice,
          'startTime': auctionStartTime?.toIso8601String(),
          'endTime': auctionEndTime?.toIso8601String(),
        }
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
        throw Exception(
            'Failed to register product. Status code: ${response.statusCode}');
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

  static Future<void> uploadImage(
      int productId, File imageFile, String token) async {
    try {
      // 서버 URL
      String url = 'http://13.125.107.235/api/product/$productId/image';

      // MultipartRequest를 사용하여 이미지를 전송합니다.
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token' // Authorization 헤더 추가
        ..files.add(await http.MultipartFile.fromPath(
          'images', // 필드 이름
          imageFile.path, // 업로드할 파일의 경로
          contentType: MediaType('image', 'jpeg'), // 이미지 파일 타입 (예시: JPEG)
        ));

      // 서버에 요청을 보내고 응답을 받습니다.
      var response = await request.send();

      // 응답 처리
      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        final responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        print('Response: $jsonResponse');
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
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

  Future<List<Product>> searchProducts(String keyword, double latitude,
      double longitude, int lowBound, int upBound, String productStatus) async {
    final response = await http.get(Uri.parse(
        'http://13.125.107.235/api/product/search?keyword=$keyword&latitude=$latitude&longitude=$longitude&lowBound=$lowBound&upBound=$upBound&productStatus=$productStatus'));

    if (response.statusCode == 200) {
      // 바이트 데이터를 UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);
      // 디코딩된 데이터를 JSON으로 파싱
      final List<dynamic> data = json.decode(decodedBody);
      return data.map((productData) => Product.fromJson(productData)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
