import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:how_much_market/widgets/ProductItemWidget.dart';

class SearchResultScreen extends StatelessWidget {
  final String searchQuery;
  final String filterStatus;
  final String filterMinPrice;
  final String filterMaxPrice;

  SearchResultScreen({
    super.key,
    required this.searchQuery,
    required this.filterStatus,
    required this.filterMinPrice,
    required this.filterMaxPrice,
  });

  final List<Map<String, dynamic>> productData = [
    {
      'imageUrl': 'assets/images/no_image.jpg',
      'title': '아이폰 6 Pro 판매합니다.',
      'distance': '500m',
      'timeAgo': '10분 전',
      'auctionStartPrice': "0원",
      'highestBid': "0원",
      'price': '200,000 원',
      'saleType': '즉시판매',
      'userName': '홍길동',
      'userLocation': '서울시 강남구',
    },
    {
      'imageUrl': 'assets/images/no_image.jpg',
      'title': '아이폰 7 Pro 경매합니다.',
      'distance': '600m',
      'timeAgo': '20분 전',
      'auctionStartPrice': "100,000원",
      'highestBid': "150,000원",
      'price': '300,000 원',
      'saleType': 'auction',
      'userName': '이순신',
      'userLocation': '서울시 종로구',
    },
    {
      'imageUrl': 'assets/images/no_image.jpg',
      'title': '아이폰 8 Pro 경매합니다아아아아아아아아아아아아아아아.',
      'distance': '700m',
      'timeAgo': '30분 전',
      'auctionStartPrice': "2,000원",
      'highestBid': "500,000원",
      'price': '400,000 원',
      'saleType': 'auction',
      'userName': '장보고',
      'userLocation': '부산시 해운대구',
    },
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(searchQuery),
      ),
      body: ListView.builder(
        itemCount: productData.length,
        itemBuilder: (context, index) {
          var product = productData[index];

          return Column(
            children: [
              ProductItemWidget(
                imageUrl: product['imageUrl'],
                title: product['title'],
                distance: product['distance'],
                timeAgo: product['timeAgo'],
                auctionStartPrice: product['auctionStartPrice'],
                highestBid: product['highestBid'],
                price: product['price'],
                saleType: product['saleType'],
                userName: product['userName'],
                userLocation: product['userLocation'],
                description: "제품설명입니다.\n가나다가나다가나다\nABC\n1234567890",
                auctionEndTime: "2024-11-12",
              ),
              const Divider(color: Color.fromARGB(255, 235, 235, 235)),
            ],
          );
        },
      ),
    );
  }
}
