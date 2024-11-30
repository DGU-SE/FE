// SearchResultScreen.dart
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:how_much_market/services/ProductService.dart';
import 'package:how_much_market/widgets/ProductItemWidget.dart'; // 상품 서비스 (API 요청) 클래스
import 'package:how_much_market/models/product.dart'; // 상품 모델 클래스

class SearchResultScreen extends StatefulWidget {
  final String searchQuery;
  final String filterStatus;
  final String filterMinPrice;
  final String filterMaxPrice;

  const SearchResultScreen({
    super.key,
    required this.searchQuery,
    required this.filterStatus,
    required this.filterMinPrice,
    required this.filterMaxPrice,
  });

  @override
  _SearchResultScreenState createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    final productService = ProductService();

    // API 요청 시 가격과 상태 필터가 제대로 적용되도록 수정
    _products = productService.searchProducts(
      widget.searchQuery,
      33.3, // 위도 (예시 값)
      22.2, // 경도 (예시 값)
      int.tryParse(widget.filterMinPrice) ?? 0, // 최소 가격
      int.tryParse(widget.filterMaxPrice) ?? 10000000, // 최대 가격
      widget.filterStatus, // 상품 상태 (unsold, sold 등)
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchQuery),
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // 데이터 로딩 중
          } else if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('상품이 없습니다.'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02,
              horizontal: screenWidth * 0.05,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Column(
                children: [
                  ProductItemWidget(productId: product.id), // 상품 아이템 렌더링
                  const Divider(color: Color.fromARGB(255, 235, 235, 235)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
