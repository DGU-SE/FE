import 'package:flutter/material.dart';
import 'package:how_much_market/models/comment.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/models/product_picture.dart';
import 'package:how_much_market/screens/product_detail/product_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// 댓글을 불러오는 함수
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
    String decodedBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩 처리
    List jsonResponse = json.decode(decodedBody);
    return jsonResponse.map((data) => Comment.fromJson(data)).toList();
  } else {
    throw Exception('댓글을 불러오는 데 실패했습니다.');
  }
}

// 토큰을 가져오는 함수
Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('authToken');
}

// 입찰 목록을 불러오는 함수
Future<List<Map<String, dynamic>>> fetchBids() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');

  if (userId == null) {
    throw Exception('로그인이 필요합니다.');
  }

  final response = await http.get(
    Uri.parse('http://13.125.107.235/api/auction/bid/$userId'),
  );

  if (response.statusCode == 200) {
    String decodedBody = utf8.decode(response.bodyBytes); // UTF-8 디코딩 처리
    List jsonResponse = json.decode(decodedBody);
    return jsonResponse.map((data) => data as Map<String, dynamic>).toList();
  } else {
    throw Exception('입찰 목록을 불러오는 데 실패했습니다.');
  }
}

class ApiBidListScreen extends StatefulWidget {
  const ApiBidListScreen({super.key});

  @override
  _ApiBidListScreenState createState() => _ApiBidListScreenState();
}

class _ApiBidListScreenState extends State<ApiBidListScreen> {
  late Future<List<Map<String, dynamic>>> futureBids;

  @override
  void initState() {
    super.initState();
    futureBids = fetchBids(); // 입찰 목록을 가져옴
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 입찰 목록'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureBids,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('입찰한 상품이 없습니다.'));
          } else {
            List<Map<String, dynamic>> bids = snapshot.data!;

            return ListView.builder(
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final bid = bids[index];
                final productData = bid['product'];
                final product = Product.fromJson(productData);
                String imageUrl = product.productPictures.isNotEmpty
                    ? product.productPictures[0]['blobUrl']
                    : '';
                String fullImageUrl =
                    'http://13.125.107.235/api/product/image/$imageUrl';
                final amount = bid['amount'];
                final auctionWinner = bid['auctionWinner'];
                final auctionWinnerAmount = bid['auctionWinnerAmount'];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 8,
                    child: InkWell(
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
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    fullImageUrl,
                                    fit: BoxFit.cover,
                                    width: 90,
                                    height: 90,
                                    errorBuilder: (context, error,
                                            stackTrace) =>
                                        const Icon(Icons.image_not_supported,
                                            size: 90),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '경매 시작가: ${product.price}원',
                                        style: const TextStyle(),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '나의 입찰 금액: $amount원',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '현재 최고 입찰자: ${auctionWinner ?? '없음'}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      ),
                                      if (auctionWinnerAmount != null)
                                        const SizedBox(height: 4),
                                      Text(
                                        '현재 최고 입찰가: $auctionWinnerAmount원',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
