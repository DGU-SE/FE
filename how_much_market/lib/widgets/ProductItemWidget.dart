import 'package:flutter/material.dart';
import 'package:how_much_market/models/comment.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/screens/product_detail/product_detail_screen.dart';
import 'package:how_much_market/services/CommnetService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductItemWidget extends StatefulWidget {
  final int productId;

  const ProductItemWidget({super.key, required this.productId});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  Product? product;
  List<Comment>? comments;
  bool isLoading = true;
  String token =
      'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1bmlxdWUtdXNlci1pZC0yIiwiaWF0IjoxNzMxOTQ2NjkyLCJleHAiOjE3MzE5NDc0NzZ9.RYVUUKbUX15UG_tEprSkEd5tf4mHe6gXSNFl9H5rlmY';
  String baseUrl = 'http://13.125.107.235/api/product/image/';

  @override
  void initState() {
    super.initState();
    _fetchProduct();
    _fetchComments();
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
    try {
      final fetchedComments =
          await CommentService.fetchComments(widget.productId, token);
      setState(() {
        comments = fetchedComments;
      });
    } catch (e) {
      print('Error fetching comments: $e');
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
                    ? baseUrl +
                        product!.productPictures[0]
                            ['blobUrl'] // 이미지 URL을 네트워크에서 가져옴
                    : 'assets/no_image.jpg', // 기본 이미지
                width: 100,
                height: 100,
                fit: BoxFit.cover,
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
