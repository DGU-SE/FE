import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_much_market/screens/product_detail/product_detail_screen.dart';

class ProductItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String distance;
  final String timeAgo;
  final String price;
  final String saleType; // 판매 방식 (경매 또는 즉시 판매 등)
  final String userName;
  final String userLocation;
  final String description; // 상품 설명 추가
  final String auctionEndTime; // 경매 종료 시간 추가

  const ProductItemWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.distance,
    required this.timeAgo,
    required this.price,
    required this.saleType,
    required this.userName,
    required this.userLocation,
    required this.description,
    required this.auctionEndTime,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return GestureDetector(
      onTap: () {
        // ProductDetailScreen으로 이동하면서 정보 전달
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: {
                'imageUrl': imageUrl,
                'title': title,
                'price': price,
                'saleType': saleType,
                'userName': userName,
                'userLocation': userLocation,
                'description': description,
                'auctionEndTime': auctionEndTime,
              },
            ),
          ),
        );
      },
      child: SizedBox(
        height: screenHeight * 0.14,
        child: Row(
          children: [
            SizedBox(width: screenWidth * 0.05),
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // 이미지 둥글게 처리
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.125,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      imageUrl,
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.125,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.012),
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: screenHeight * 0.022,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    '$timeAgo · $distance',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: screenHeight * 0.017,
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: screenHeight * 0.026,
                      fontWeight: FontWeight.w700,
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
