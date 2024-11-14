import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class BidListScreen extends StatefulWidget {
  const BidListScreen({super.key});

  @override
  State<BidListScreen> createState() => _BidListScreenState();
}

class _BidListScreenState extends State<BidListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('BidListScreen'),
      ),
      body: const Column(children: [
        Text('템플릿'),
      ]),
    );
  }
}
