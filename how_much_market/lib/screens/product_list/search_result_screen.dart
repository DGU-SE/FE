import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  final String searchQuery;

  const SearchResultScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(searchQuery),
      ),
      body: Center(
        child: Text(
          '검색 결과 화면 - $searchQuery',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
