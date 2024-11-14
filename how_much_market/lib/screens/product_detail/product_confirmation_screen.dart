import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                  height: screenWidth * 0.6, // 큰 이미지 크기
                  fit: BoxFit.cover, // 이미지 비율 유지
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
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
              '${product['price']}',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: screenHeight * 0.15),

            // 구매 정보 안내
            Text(
              '해당 상품을 구매하시겠습니까?',
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Text(
              '판매자에게 메시지를 보냅니다.',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.black87,
              ),
            ),
            // 구매하기 버튼
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.03,
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('구매 요청을 보냈습니다.')),
            ); // 응찰 성공 시 화면 종료
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
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
    );
  }
}

class ProductBidConfirmationScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductBidConfirmationScreen({super.key, required this.product});

  @override
  _ProductBidConfirmationScreenState createState() =>
      _ProductBidConfirmationScreenState();
}

class _ProductBidConfirmationScreenState
    extends State<ProductBidConfirmationScreen> {
  late TextEditingController bidController;

  @override
  void initState() {
    super.initState();
    bidController = TextEditingController();
  }

  @override
  void dispose() {
    bidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('응찰 확인'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  widget.product['imageUrl'],
                  width: screenWidth * 0.85,
                  height: screenWidth * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              widget.product['title'],
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              '응찰 금액을 입력하세요:',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
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
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
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
                  widget.product['auctionStartPrice'],
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
                  widget.product['highestBid'],
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.1),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.02,
        ),
        child: ElevatedButton(
          onPressed: () {
            double bidAmount = double.tryParse(bidController.text) ?? 0.0;
            double highestBid =
                double.tryParse(widget.product['highestBid']) ?? 0.0;

            if (bidController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('응찰 금액을 입력해주세요.')),
              );
            } else if (bidAmount <= highestBid) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('응찰 금액이 현재 최고가보다 높아야 합니다.')),
              );
            } else {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('응찰하였습니다.')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
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
    );
  }
}
