import 'package:flutter/material.dart';
import 'package:how_much_market/widgets/ProductItemWidget.dart';

class FavoriteScreen extends StatelessWidget {
  final List<ProductItemWidget> favoriteProducts = [
    const ProductItemWidget(
      imageUrl: 'assets/images/no_image.jpg',
      title: '상품 1',
      distance: '2km',
      timeAgo: '3시간 전',
      auctionStartPrice: '10,000원',
      highestBid: '15,000원',
      price: '25,000원',
      saleType: 'auction',
      userName: '사용자 1',
      userLocation: '서울',
      description: '상품 설명 1',
      auctionEndTime: '2024-11-15',
    ),
    const ProductItemWidget(
      imageUrl: 'assets/images/no_image.jpg',
      title: '상품 2',
      distance: '5km',
      timeAgo: '1일 전',
      auctionStartPrice: '20,000원',
      highestBid: '30,000원',
      price: '40,000원',
      saleType: 'direct',
      userName: '사용자 2',
      userLocation: '부산',
      description: '상품 설명 2',
      auctionEndTime: '2024-11-20',
    ),
    // 추가 상품 데이터를 여기에 작성
  ];

  FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('찜한 상품'),
      ),
      body: favoriteProducts.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.05,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                return favoriteProducts[index];
              },
            )
          : Center(
              child: Text(
                '찜한 상품이 없습니다.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ),
    );
  }
}
