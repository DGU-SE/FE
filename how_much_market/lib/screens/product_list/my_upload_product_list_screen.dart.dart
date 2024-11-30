import 'package:flutter/material.dart';
import 'package:how_much_market/models/comment.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/models/product_picture.dart';
import 'package:how_much_market/screens/product_detail/product_detail_screen.dart';
import 'package:how_much_market/screens/product_registration/product_edit_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

// 토큰을 가져오는 함수
Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

// 상품 목록을 불러오는 함수
Future<List<Product>> fetchProducts() async {
  final token = await getAuthToken(); // 토큰을 가져옴

  if (token == null) {
    throw Exception('로그인이 필요합니다.');
  }

  final response = await http.get(
    Uri.parse('http://13.125.107.235/api/product/my'),
    headers: {
      'Authorization': 'Bearer $token', // Authorization 헤더에 토큰 추가
    },
  );

  if (response.statusCode == 200) {
    String decodedBody =
        utf8.decode(response.bodyBytes); // UTF-8 디코딩 처리 // UTF-8 디코딩 처리
    List jsonResponse = json.decode(decodedBody);
    return jsonResponse.map((data) => Product.fromJson(data)).toList();
  } else {
    throw Exception('상품을 불러오는 데 실패했습니다.');
  }
}

// 상품에 대한 댓글을 불러오는 함수
Future<List<Comment>> fetchComments(int productId) async {
  final token = await getAuthToken(); // 토큰을 가져옴

  if (token == null) {
    throw Exception('로그인이 필요합니다.');
  }

  final response = await http.get(
    Uri.parse('http://13.125.107.235/api/comment/$productId'),
    headers: {
      'Authorization': 'Bearer $token', // Authorization 헤더에 토큰 추가
    },
  );

  if (response.statusCode == 200) {
    // UTF-8 디코딩을 명시적으로 처리
    String decodedBody = utf8.decode(response.bodyBytes); // bodyBytes 사용
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
    print('Sending DELETE request to: $url');
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
    futureProducts = fetchProducts(); // 상품 목록을 가져옴
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

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              fullImageUrl,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${product.price}원',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          '${product.regTime.substring(0, 10)} ',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            // 수정 버튼 클릭 시 수정 화면으로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductEditScreen(
                                  productId: product.id,
                                ),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          child: const Text(
                            '수정',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            print('Deleting product with ID: ${product.id}');
                            final token = await getAuthToken();
                            if (token == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('로그인이 필요합니다.'),
                                ),
                              );
                              return;
                            }
                            try {
                              await deleteProduct(product.id.toString(), token);
                              setState(() {
                                futureProducts = fetchProducts(); // 삭제 후 목록 갱신
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('상품이 삭제되었습니다.'),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('상품 삭제에 실패했습니다. 오류: $e'),
                                ),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.grey,
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
                    onTap: () async {
                      try {
                        // 상품 클릭 시 상세 정보 불러오기
                        final comments = await fetchComments(product.id);

                        // 상세 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                              product: product,
                              comments: comments, // 댓글을 바로 전달
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
