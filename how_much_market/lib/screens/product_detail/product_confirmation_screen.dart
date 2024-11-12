import 'package:flutter/material.dart';

class ProductPurchaseConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductPurchaseConfirmationScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('구매 확인'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // 모서리 둥글게 설정
                child: Image.asset(
                  product['imageUrl'], // 상품 이미지 URL
                  width: screenWidth * 0.85, // 큰 이미지 크기
                  height: screenWidth * 0.4, // 큰 이미지 크기
                  fit: BoxFit.cover, // 이미지 비율 유지
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // 상품 정보
            Text(
              product['title'],
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              '가격: ${product['price']}',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),

            // 구매 정보 안내
            Text(
              '해당 상품을 구매하시겠습니까?',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.04),

            // 구매하기 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 구매 기능 처리
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.3,
                    vertical: screenHeight * 0.015,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '구매하기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductBidConfirmationScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductBidConfirmationScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // 화면 크기 가져오기
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    TextEditingController bidController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('응찰 확인'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // 모서리 둥글게 설정
                child: Image.asset(
                  product['imageUrl'], // 상품 이미지 URL
                  width: screenWidth * 0.85, // 큰 이미지 크기
                  height: screenWidth * 0.4, // 큰 이미지 크기
                  fit: BoxFit.cover, // 이미지 비율 유지
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // 상품 정보
            Text(
              product['title'],
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '경매 시작가',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  product['auctionStartPrice'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '현재 최고가',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  product['highestBid'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.1),

            // 응찰 입력 필드
            Text(
              '응찰 금액을 입력하세요:',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: bidController,
              decoration: InputDecoration(
                hintText: '응찰 금액',
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: screenHeight * 0.05),

            // 응찰하기 버튼
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 응찰 기능 처리
                  if (bidController.text.isNotEmpty) {
                    Navigator.pop(context);
                  } else {
                    // 금액을 입력하지 않았을 경우 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('응찰 금액을 입력해주세요.')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.3,
                    vertical: screenHeight * 0.015,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '응찰하기',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
