import 'package:flutter/material.dart';
import 'package:how_much_market/models/comment.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/models/product_picture.dart';
import 'package:how_much_market/screens/product_detail/product_detail_screen.dart';
import 'package:how_much_market/screens/product_registration/product_edit_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// 토큰을 가져오는 함수
Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

// 상품 목록을 불러오는 함수
Future<List<Product>> fetchProducts() async {
  final token = await getAuthToken();

  if (token == null) {
    throw Exception('로그인이 필요합니다.');
  }

  final response = await http.get(
    Uri.parse('http://13.125.107.235/api/product/my'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    String decodedBody = utf8.decode(response.bodyBytes);
    List jsonResponse = json.decode(decodedBody);
    return jsonResponse.map((data) => Product.fromJson(data)).toList();
  } else {
    throw Exception('상품을 불러오는 데 실패했습니다.');
  }
}

// 상품에 대한 댓글을 불러오는 함수
Future<List<Comment>> fetchComments(int productId) async {
  final token = await getAuthToken();

  if (token == null) {
    throw Exception('로그인이 필요합니다.');
  }

  final response = await http.get(
    Uri.parse('http://13.125.107.235/api/comment/$productId'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    String decodedBody = utf8.decode(response.bodyBytes);
    List jsonResponse = json.decode(decodedBody);
    return jsonResponse.map((data) => Comment.fromJson(data)).toList();
  } else {
    throw Exception('댓글을 불러오는 데 실패했습니다.');
  }
}

// 삭제 요청을 보내는 함수
Future<void> deleteProduct(String productId, String authToken) async {
  final url = Uri.parse('http://13.125.107.235/api/product/delete/$productId');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('삭제 요청 실패: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('오류 발생: $e');
  }
}

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 올린 상품 목록'),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('올린 상품이 없습니다.'));
          } else {
            List<Product> products = snapshot.data!;

            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                String imageUrl = product.productPictures.isNotEmpty
                    ? product.productPictures[0]['blobUrl']
                    : '';
                String fullImageUrl =
                    'http://13.125.107.235/api/product/image/$imageUrl';

                return GestureDetector(
                  onTap: () async {
                    try {
                      final comments = await fetchComments(product.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            product: product,
                            comments: comments,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('상품 상세 정보를 불러오는 데 실패했습니다.'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        imageUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  fullImageUrl,
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.image_not_supported,
                                          size: 80),
                                ),
                              )
                            : const Icon(Icons.image_not_supported, size: 80),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${product.price}원',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.regTime.substring(0, 10),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductEditScreen(
                                            productId: product.id,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text(
                                      '수정',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final token = await getAuthToken();
                                      if (token == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('로그인이 필요합니다.'),
                                          ),
                                        );
                                        return;
                                      }
                                      try {
                                        await deleteProduct(
                                            product.id.toString(), token);
                                        setState(() {
                                          futureProducts = fetchProducts();
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('상품이 삭제되었습니다.'),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('상품 삭제에 실패했습니다. 오류: $e'),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text(
                                      '삭제',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
