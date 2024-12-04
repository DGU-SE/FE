import 'package:flutter/material.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/screens/main/favorite_screen.dart';
import 'package:how_much_market/screens/main/mypage_screen.dart';
import 'package:how_much_market/screens/main/search_screen.dart';
import 'package:how_much_market/screens/product_registration/product_registration_screen.dart';
import 'package:how_much_market/services/ProductService.dart';
import 'package:how_much_market/widgets/ProductItemWidget.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService productService = ProductService();
  late Future<List<Product>> _products;
  Timer? _timer; // Timer 객체 선언
  Position? _currentPosition;

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
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getCurrentLocation(); // 먼저 위치 정보를 가져옴
    _fetchProducts(); // 위치 정보를 가져온 후 상품 조회
  }

  @override
  void dispose() {
    _timer?.cancel(); // Timer 해제
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProducts(); // Refetch products when dependencies change
  }

  Future<void> _getCurrentLocation() async {
    try {
      // 위치 권한 확인
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      // 위치 설정
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // 자동 새로고침을 위한 타이머 설정
  void _startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchProducts(); // 10초마다 데이터 새로고침
    });
  }

  // 새로고침을 위한 메서드
  Future<void> _fetchProducts() async {
    setState(() {
      _products = productService.searchProducts(
        '', // 기본 검색어
        _currentPosition?.latitude, // 현재 위치의 위도
        _currentPosition?.longitude, // 현재 위치의 경도
        0, // 최소 가격
        10000000, // 최대 가격
        '', // 상품 상태
      );
    });

    // Check the result of Future
    _products.then((products) {
      print(
          'Products fetched: ${products.length}'); // Debug: Verify products count
    }).catchError((error) {
      print(
          'Error fetching products: $error'); // Debug: Check if an error occurs
    });
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
                          _fetchProducts();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Color.fromARGB(255, 242, 242, 242)),
          const Divider(color: Color.fromARGB(255, 240, 240, 240)),

          // 새로고침 기능을 추가한 부분
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchProducts, // 새로고침 시 호출될 함수
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
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: screenHeight * 0.1,
        backgroundColor: Theme.of(context).primaryColorLight,
        animationDuration: const Duration(seconds: 1),
        onDestinationSelected: (index) async {
          if (index == 2) {
            // Assuming "ProductRegistrationScreen" is at index 2
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductRegistrationScreen(),
              ),
            );

            // Check if product was successfully registered and refresh the home screen
            if (result == true) {
              _fetchProducts(); // Refresh the product list
            }
          } else if (index != 0) {
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
