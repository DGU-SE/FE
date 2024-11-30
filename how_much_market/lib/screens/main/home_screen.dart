import 'package:flutter/material.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/screens/main/favorite_screen.dart';
import 'package:how_much_market/screens/main/mypage_screen.dart';
import 'package:how_much_market/screens/main/search_screen.dart';
import 'package:how_much_market/screens/product_registration/product_registration_screen.dart';
import 'package:how_much_market/services/ProductService.dart';
import 'package:how_much_market/widgets/ProductItemWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService productService = ProductService();
  int selectedIndex = 0;
  late Future<List<Product>> _products;

  final List<Widget> screens = [
    const SearchScreen(),
    const SearchScreen(),
    const ProductRegistrationScreen(),
    const FavoriteScreen(),
    const MyPageScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _products = productService.searchProducts(
      '', // 기본 검색어, 필요에 따라 변경
      33.3, // 위도
      22.2, // 경도
      0, // 최소 가격
      10000000, // 최대 가격
      'unsold', // 상품 상태
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.03),
          SizedBox(
            height: screenHeight * 0.07,
            child: Center(
              child: Row(
                children: [
                  SizedBox(width: screenWidth * 0.07),
                  SizedBox(
                    width: screenWidth * 0.63,
                    child: Text(
                      '서울시 중구 필동',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.026,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Color.fromARGB(255, 242, 242, 242)),

          // 3가지 라디오 버튼 추가
          SizedBox(
            height: screenHeight * 0.05,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: _buildRadioButton(0),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildRadioButton(1),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildRadioButton(2),
                ),
              ],
            ),
          ),

          const Divider(color: Color.fromARGB(255, 240, 240, 240)),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('상품이 없습니다.'));
                }

                final products = snapshot.data!;
                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Column(
                      children: [
                        ProductItemWidget(productId: product.id),
                        const Divider(
                            color: Color.fromARGB(255, 235, 235, 235)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
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
        surfaceTintColor: Theme.of(context).primaryColorLight,
      ),
    );
  }

  Widget _buildRadioButton(int index) {
    bool isSelected = index == selectedIndex;
    List<String> buttonLabels = ['전체보기', '경매', '즉시구매'];
    List<IconData> buttonIcons = [
      Icons.view_list,
      Icons.access_time,
      Icons.shopping_cart,
    ];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
          _products = productService.searchProducts(
            '', // 기본 검색어, 필요에 따라 변경
            33.3, // 위도
            22.2, // 경도
            0, // 최소 가격
            10000000, // 최대 가격
            'unsold',
          );
        });
      },
      child: Container(
        width: 80,
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              buttonIcons[index],
              size: 18,
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 4.0),
            Text(
              buttonLabels[index],
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 10,
              ),
            ),
          ],
        ),
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
        color: Color(0xff3297DF),
        size: 43,
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
