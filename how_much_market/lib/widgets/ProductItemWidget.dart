import 'package:flutter/material.dart';
import 'package:how_much_market/models/comment.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/screens/product_detail/product_detail_screen.dart';
import 'package:how_much_market/services/CommnetService.dart'; // 경로 확인 필요
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // 추가

class ProductItemWidget extends StatefulWidget {
  final int productId;

  const ProductItemWidget({super.key, required this.productId});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  Product? product;
  List<Comment>? comments = [];
  bool isLoading = true;
  String? token; // 토큰을 저장할 변수
  String baseUrl = 'http://13.125.107.235/api/product/image/';

  @override
  void initState() {
    super.initState();
    _fetchToken().then((_) {
      if (token != null) {
        _fetchProduct(); // 토큰이 있을 때만 상품 정보를 가져옴
        _fetchComments(); // 토큰이 있을 때만 댓글 정보를 가져옴
      } else {
        print('토큰이 없습니다!!!!.');
      }
    });
  }

  // 토큰을 가져오는 메소드
  Future<void> _fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('authToken');
    if (storedToken != null) {
      setState(() {
        token = storedToken; // 가져온 토큰을 저장
        print('저장된 토큰: $token');
      });
    }
  }

  Future<void> _fetchProduct() async {
    try {
      final response = await http.get(
        Uri.parse('http://13.125.107.235/api/product/${widget.productId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          product = Product.fromJson(json.decode(response.body));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print('Error fetching product: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchComments() async {
    if (token == null) {
      print('토큰이 없습니다!!!!.');
      return;
    }

    try {
      final fetchedComments = await CommentService.fetchComments(
          widget.productId, token!); // token을 전달
      setState(() {
        comments = fetchedComments ?? []; // null 대신 빈 리스트로 처리
      });
    } catch (e) {
      print('Error fetching comments: $e');
      setState(() {
        comments = []; // 에러 발생 시에도 빈 리스트로 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (product == null) {
      return const Center(
        child: Text('Failed to load product.'),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductDetailScreen(product: product!, comments: comments!),
          ),
        );
      },
      child: SizedBox(
        height: 120,
        child: Row(
          children: [
            const SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product!.productPictures.isNotEmpty
                    ? baseUrl + product!.productPictures[0]['blobUrl']
                    : 'assets/images/no_image.jpg', // 기본 이미지
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // 이미지 로딩 실패 시 기본 이미지 표시
                  return Image.asset('assets/images/no_image.jpg',
                      fit: BoxFit.cover);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    product!.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product!.productDetail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₩${product!.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
