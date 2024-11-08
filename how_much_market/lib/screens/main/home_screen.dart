import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:how_much_market/screens/main/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> screens;

  _HomeScreenState()
      : screens = [
          const SearchScreen(),
          const SearchScreen(),
          const SearchScreen(),
          const SearchScreen(),
          const SearchScreen(),
        ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('스크린 이름'),
      ),
      body: const Center(child: Text('홈 화면')),
      bottomNavigationBar: NavigationBar(
        height: screenHeight * 0.1,
        backgroundColor: Theme.of(context).primaryColorLight,
        animationDuration: const Duration(seconds: 1),
        onDestinationSelected: (index) {
          if (index != 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => screens[index],
              ),
            );
          }
        },
        destinations: _navBarItems,
        indicatorColor: Theme.of(context).primaryColorLight,
      ),
    );
  }

  final List<Widget> _navBarItems = [
    const NavigationDestination(
      icon: Icon(Icons.home, color: Colors.black),
      label: '홈',
    ),
    const NavigationDestination(
      icon: Icon(Icons.search),
      label: '검색',
    ),
    const NavigationDestination(
      icon: Icon(
        Icons.add_box_rounded,
        color: Color(0xff3297DF), // 항상 primary color로 강조
        size: 45, // 아이콘 크기 강조
      ),
      label: '글쓰기',
    ),
    const NavigationDestination(
      icon: Icon(Icons.favorite_border),
      label: '찜',
    ),
    const NavigationDestination(
      icon: Icon(Icons.person_outline_rounded),
      label: '마이페이지',
    ),
  ];
}
