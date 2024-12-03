import 'package:flutter/material.dart';
import 'package:how_much_market/models/comment.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/screens/product_detail/product_detail_screen.dart';
import 'package:how_much_market/services/CommnetService.dart'; // 경로 확인 필요
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // 추가
import 'package:geolocator/geolocator.dart';

class ProductItemWidget extends StatefulWidget {
  final int productId;

  const ProductItemWidget({super.key, required this.productId});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  Position? _currentPosition;
  Product? product;
  List<Comment>? comments = [];
  bool isLoading = true;
  String? token; // 토큰을 저장할 변수
  String baseUrl = 'http://13.125.107.235/api/product/image/';
  bool _isDisposed = false; // To track if the widget is disposed

  Future<void> _getCurrentLocation() async {
    try {
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      if (!_isDisposed) {
        setState(() {
          _currentPosition = position;
        });
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchToken().then((_) async {
      if (token != null) {
        await _getCurrentLocation(); // 먼저 위치 정보를 가져옴
        _fetchProduct(); // 위치 정보를 포함하여 상품 정보를 가져옴
        _fetchComments();
      } else {
        print('토큰이 없습니다!!!!.');
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed
    super.dispose();
  }

  // 토큰을 가져오는 메소드
  Future<void> _fetchToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('authToken');
    if (storedToken != null && !_isDisposed) {
      setState(() {
        token = storedToken; // 가져온 토큰을 저장
        print('저장된 토큰: $token');
      });
    }
  }

  Future<void> _fetchProduct() async {
    try {
      // 쿼리 파라미터 추가
      final queryParams = {
        if (_currentPosition != null)
          'latitude': _currentPosition!.latitude.toString(),
        if (_currentPosition != null)
          'longitude': _currentPosition!.longitude.toString(),
      };

      final uri =
          Uri.parse('http://13.125.107.235/api/product/${widget.productId}')
              .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        if (!_isDisposed) {
          setState(() {
            product = Product.fromJson(json.decode(decodedBody));
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print('Error fetching product: $e');
      if (!_isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
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
      if (!_isDisposed) {
        setState(() {
          comments = fetchedComments ?? []; // null 대신 빈 리스트로 처리
        });
      }
    } catch (e) {
      print('Error fetching comments: $e');
      if (!_isDisposed) {
        setState(() {
          comments = []; // 에러 발생 시에도 빈 리스트로 설정
        });
      }
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
              child: Container(
                width: 100,
                height: 100, // 정사각형 크기 고정
                color: Colors.grey[200], // 이미지 로딩 전 배경색
                child: Image.network(
                  product!.productPictures.isNotEmpty
                      ? baseUrl + product!.productPictures[0]['blobUrl']
                      : '', // 기본 이미지를 빈 문자열로 처리
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // 이미지 로딩 실패 시 기본 이미지 표시
                    return Image.asset(
                      'assets/images/no_image.jpg',
                      fit: BoxFit.cover, // 이미지 크기 고정
                      width: 100,
                      height: 100, // 정사각형 크기 고정
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        () {
                          if (product!.onAuction) {
                            switch (product!.productStatus) {
                              case 'unsold':
                                return '경매중 ';
                              case 'no_bids':
                                return '경매 유찰 ';
                              case 'auction_ended':
                                return '경매 종료 (인도 대기) ';
                              case 'sold':
                                return '경매 완료 ';
                              default:
                                return '';
                            }
                          } else {
                            switch (product!.productStatus) {
                              case 'unsold':
                                return '판매중 ';
                              case 'sold':
                                return '판매 완료 ';
                              default:
                                return '';
                            }
                          }
                        }(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              Colors.blue, // 또는 Theme.of(context).primaryColor
                        ),
                      ),
                      Expanded(
                        child: Text(
                          product!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
                  Row(
                    children: [
                      Text(
                        '₩${product!.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          decoration: product!.onAuction &&
                                  product!.price != product!.currentPrice
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      if (product!.onAuction &&
                          product!.price != product!.currentPrice)
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xFF1565C0),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '₩${product!.currentPrice.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 4), // 가격과 위치 정보 사이 간격 추가
                  Text(
                    product!.distanceKiloMeter == -1.0
                        ? '${product!.locationName} · 거리 확인 불가'
                        : '${product!.locationName} · ${product!.distanceKiloMeter.toStringAsFixed(1)}km',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
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
