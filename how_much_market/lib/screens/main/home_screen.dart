import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:how_much_market/screens/main/favorite_screen.dart';
import 'package:how_much_market/screens/main/mypage_screen.dart';
import 'package:how_much_market/screens/main/search_screen.dart';
import 'package:how_much_market/screens/product_registration/product_registration_screen.dart';
import 'package:how_much_market/widgets/ProductItemWidget.dart';

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
          const ProductRegistrationScreen(),
          const FavoriteScreen(),
          const MypageScreen(),
        ];

  final List<Map<String, dynamic>> productData = [
    {
      'imageUrl': 'assets/images/no_image.jpg',
      'title': '아이폰 6 Pro 판매합니다.',
      'distance': '500m',
      'timeAgo': '10분 전',
      'price': '200,000 원',
      'saleType': '즉시판매', // 판매 방식 추가
      'userName': '홍길동', // 사용자 이름 추가
      'userLocation': '서울시 강남구', // 사용자 위치 추가
    },
    {
      'imageUrl': 'assets/images/no_image.jpg',
      'title': '아이폰 7 Pro 판매합니다.',
      'distance': '600m',
      'timeAgo': '20분 전',
      'price': '300,000 원',
      'saleType': 'auction',
      'userName': '이순신',
      'userLocation': '서울시 종로구',
    },
    {
      'imageUrl': 'assets/images/no_image.jpg',
      'title': '아이폰 8 Pro 판매합니다.',
      'distance': '700m',
      'timeAgo': '30분 전',
      'price': '400,000 원',
      'saleType': 'auction',
      'userName': '장보고',
      'userLocation': '부산시 해운대구',
    },
  ];

  int selectedIndex = 0;

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
                  SizedBox(
                    width: screenWidth * 0.07,
                  ),
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
                                builder: (context) => const SearchScreen()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SearchScreen()),
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
                  padding: const EdgeInsets.only(left: 20.0), // Row 시작 시 간격 추가
                  child: _buildRadioButton(0),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0), // 첫 번째 버튼과 두 번째 버튼 사이 간격 추가
                  child: _buildRadioButton(1),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0), // 두 번째 버튼과 세 번째 버튼 사이 간격 추가
                  child: _buildRadioButton(2),
                ),
              ],
            ),
          ),

          const Divider(color: Color.fromARGB(255, 240, 240, 240)),
          Expanded(
            child: ListView.builder(
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
                      price: product['price'],
                      saleType: product['saleType'],
                      userName: product['userName'],
                      userLocation: product['userLocation'],
                      description: "제품설명\n가나다\nABC\n1234567890",
                      auctionEndTime: "2024-11-12",
                    ),
                    const Divider(color: Color.fromARGB(255, 235, 235, 235)),
                  ],
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
        indicatorColor: Theme.of(context).primaryColorLight,
      ),
    );
  }

  // 라디오 버튼 빌드 메서드
  Widget _buildRadioButton(int index) {
    bool isSelected = index == selectedIndex;
    List<String> buttonLabels = ['전체보기', '경매', '즉시구매'];
    List<IconData> buttonIcons = [
      Icons.view_list, // 전체보기
      Icons.access_time, // 경매
      Icons.shopping_cart, // 즉시구매
    ];

    // 텍스트 크기 설정
    TextStyle textStyle;
    if (index == 1) {
      // 두 번째 버튼 (경매) 텍스트 크기 키움
      textStyle = TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 15, // 크기 증가
      );
    } else {
      // 첫 번째와 세 번째 버튼 텍스트 크기 줄임
      textStyle = TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontSize: 10, // 크기 감소
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: 80,
        height: 35, // 버튼 크기
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
          children: [
            Icon(
              buttonIcons[index],
              size: 18, // 아이콘 크기 줄임
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 4.0),
            Text(
              buttonLabels[index],
              style: textStyle, // 텍스트 스타일 적용
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
