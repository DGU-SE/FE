import 'package:flutter/material.dart';
import 'package:how_much_market/widgets/ProductItemWidget.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

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
        body: ListView.builder(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02,
            horizontal: screenWidth * 0.05,
          ),
          itemCount: 1,
          itemBuilder: (context, index) {
            return const ProductItemWidget(productId: 1);
          },
        ));
  }
}
