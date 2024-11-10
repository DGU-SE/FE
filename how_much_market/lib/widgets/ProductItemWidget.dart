import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_much_market/screens/product_detail/product_screen.dart';

class ProductItemWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String distance;
  final String timeAgo;
  final String price;

  const ProductItemWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.distance,
    required this.timeAgo,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return GestureDetector(
      onTap: () {
        // ProductScreen 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductScreen(),
          ),
        );
      },
      child: SizedBox(
        height: screenHeight * 0.14,
        child: Row(
          children: [
            SizedBox(width: screenWidth * 0.05),
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // 둥글게 만들기
              child: Image.asset(
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
                  Text(title,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenHeight * 0.022,
                          fontWeight: FontWeight.w400)),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    ' $timeAgo · $distance',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: screenHeight * 0.017,
                    ),
                  ),
                  Text(price,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: screenHeight * 0.026,
                          fontWeight: FontWeight.w700)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
