import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/services/Transaction.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 경로 확인 필요

class ProductPurchaseConfirmationScreen extends StatelessWidget {
  final Product product;

  const ProductPurchaseConfirmationScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  product.productPictures.isNotEmpty
                      ? product.productPictures[0]['blobUrl']
                      : 'assets/no_image.jpg',
                  width: screenWidth * 0.85,
                  height: screenWidth * 0.6,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Text(
              product.name,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              '${product.price}원',
              style: TextStyle(
                fontSize: screenWidth * 0.08,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Spacer(),
            Text(
              '해당 상품을 구매하시겠습니까?',
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.02,
        ),
        child: ElevatedButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('authToken'); // 로그인된 사용자 토큰
            if (token == null) {
              _showSnackbar(context, '로그인이 필요합니다.');
              return;
            }

            try {
              final transactionService = TransactionService();
              await transactionService.purchaseProduct(product.id, token);
              Navigator.pop(context);
              _showSnackbar(context, '구매 요청을 보냈습니다.');
            } catch (e) {
              _showSnackbar(context, '구매 요청 실패: $e');
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
            '구매하기',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class ProductBidConfirmationScreen extends StatefulWidget {
  final Product product;

  const ProductBidConfirmationScreen({super.key, required this.product});

  @override
  _ProductBidConfirmationScreenState createState() =>
      _ProductBidConfirmationScreenState();
}

class _ProductBidConfirmationScreenState
    extends State<ProductBidConfirmationScreen> {
  final TextEditingController bidController = TextEditingController();

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
                child: Image.network(
                  widget.product.productPictures.isNotEmpty
                      ? widget.product.productPictures[0]['blobUrl']
                      : 'assets/no_image.jpg',
                  width: screenWidth * 0.85,
                  height: screenWidth * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              widget.product.name,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              '응찰 금액을 입력하세요:',
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            TextField(
              controller: bidController,
              decoration: const InputDecoration(
                hintText: '응찰 금액',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildPriceRow('경매 시작가', widget.product.price),
            SizedBox(height: screenHeight * 0.01),
            _buildPriceRow('현재 최고가', widget.product.price, isHighlighted: true),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.1,
          vertical: screenHeight * 0.02,
        ),
        child: ElevatedButton(
          onPressed: _handleBid,
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

  Widget _buildPriceRow(String label, int price, {bool isHighlighted = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isHighlighted ? Colors.black : Colors.grey,
          ),
        ),
        Text(
          '$price원',
          style: TextStyle(
            fontSize: isHighlighted ? 18 : 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            color: isHighlighted ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }

  void _handleBid() async {
    double bidAmount = double.tryParse(bidController.text) ?? 0.0;
    if (bidController.text.isEmpty) {
      _showSnackbar(context, '응찰 금액을 입력해주세요.');
    } else if (bidAmount <= widget.product.price) {
      _showSnackbar(context, '응찰 금액이 현재 최고가보다 높아야 합니다.');
    } else {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken'); // 로그인된 사용자 토큰
      if (token == null) {
        _showSnackbar(context, '로그인이 필요합니다.');
        return;
      }

      try {
        final transactionService = TransactionService();
        await transactionService.placeBid(widget.product.id, bidAmount, token);
        Navigator.pop(context);
        _showSnackbar(context, '응찰하였습니다.');
      } catch (e) {
        _showSnackbar(context, '응찰 실패: $e');
      }
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
