import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:how_much_market/widgets/ProductItemWidget.dart'; // ProductItemWidget이 정의된 파일 import

class PurchaseListScreen extends StatefulWidget {
  const PurchaseListScreen({super.key});

  @override
  State<PurchaseListScreen> createState() => _PurchaseListScreenState();
}

class _PurchaseListScreenState extends State<PurchaseListScreen> {
  // 샘플 구매 상품 리스트
  final List<ProductItemWidget> purchasedProducts = [
    const ProductItemWidget(
      imageUrl: 'assets/images/no_image.jpg',
      title: '구매한 상품 1',
      distance: '1km',
      timeAgo: '2일 전',
      auctionStartPrice: '50,000원',
      highestBid: '70,000원',
      price: '80,000원',
      saleType: 'auction',
      userName: '판매자 1',
      userLocation: '대전',
      description: '구매 상품 설명 1',
      auctionEndTime: '2024-11-10',
    ),
    const ProductItemWidget(
      imageUrl: 'assets/images/no_image.jpg',
      title: '구매한 상품 2',
      distance: '3km',
      timeAgo: '5시간 전',
      auctionStartPrice: '30,000원',
      highestBid: '45,000원',
      price: '50,000원',
      saleType: 'direct',
      userName: '판매자 2',
      userLocation: '서울',
      description: '구매 상품 설명 2',
      auctionEndTime: '2024-11-12',
    ),
    // 추가 상품 데이터를 여기에 작성
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('구매한 상품 목록'),
      ),
      body: purchasedProducts.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.05,
              ),
              itemCount: purchasedProducts.length,
              itemBuilder: (context, index) {
                return purchasedProducts[index];
              },
            )
          : Center(
              child: Text(
                '구매한 상품이 없습니다.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
    );
  }
}
