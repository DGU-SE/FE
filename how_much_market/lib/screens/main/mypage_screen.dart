import 'package:flutter/material.dart';
import 'package:how_much_market/screens/account/login_screen.dart';
import 'package:how_much_market/screens/account/mycurloc_screen.dart';
import 'package:how_much_market/screens/product_list/bid_list_screen.dart';
import 'package:how_much_market/screens/product_list/purchase_list_screen.dart';
import 'package:how_much_market/screens/product_list/registration_list_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이페이지'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 나의 거래 섹션
            _buildSectionHeader(context, '나의 거래'),
            _buildSectionCard(
              context,
              icon: Icons.upload_file,
              title: '올린 상품 목록',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrationListScreen()),
                );
              },
            ),
            _buildSectionCard(
              context,
              icon: Icons.gavel,
              title: '입찰 목록',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BidListScreen()),
                );
              },
            ),

            _buildSectionCard(
              context,
              icon: Icons.shopping_bag,
              title: '구매 상품 목록',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PurchaseListScreen()),
                );
              },
            ),
            SizedBox(height: screenHeight * 0.03), // 간격

            // 계정 관리 섹션
            _buildSectionHeader(context, '계정 관리'),
            _buildSectionCard(
              context,
              icon: Icons.lock,
              title: '비밀번호 변경',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
            _buildSectionCard(
              context,
              icon: Icons.location_on,
              title: '거주지 변경',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyCurLocScreen()),
                );
              },
            ),
            _buildSectionCard(
              context,
              icon: Icons.logout,
              title: '로그아웃',
              onTap: () {
                // 로그아웃 기능 구현
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('로그아웃'),
                    content: const Text('정말 로그아웃 하시겠습니까?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // 로그아웃 처리 로직 추가
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('로그아웃 되었습니다.')),
                          );
                        },
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  // 섹션 제목을 만드는 위젯
  Widget _buildSectionHeader(BuildContext context, String sectionTitle) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      child: Text(
        sectionTitle,
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // 각 항목을 카드 형태로 만드는 위젯
  Widget _buildSectionCard(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: screenWidth * 0.04),
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                color: Theme.of(context).primaryColor,
                size: screenWidth * 0.08),
            SizedBox(width: screenWidth * 0.04),
            Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
