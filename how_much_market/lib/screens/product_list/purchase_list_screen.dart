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
      body: true
          ? ListView.builder(
              padding: EdgeInsets.symmetric(
                vertical: screenHeight * 0.02,
                horizontal: screenWidth * 0.05,
              ),
              itemCount: 1,
              itemBuilder: (context, index) {
                return const ProductItemWidget(productId: 1);
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
