import 'package:flutter/material.dart';
import 'package:how_much_market/screens/account/trash_register_screen.dart';
import 'package:how_much_market/screens/main/home_screen.dart';

class TrashLoginScreen extends StatefulWidget {
  const TrashLoginScreen({super.key});

  @override
  State<TrashLoginScreen> createState() => _TrashLoginScreenState();
}

class _TrashLoginScreenState extends State<TrashLoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      setState(() {});
    });
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    double padding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '이거얼마?켓',
                style: TextStyle(
                  fontSize: screenWidth * 0.12,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff3297DF),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // 로그인 텍스트 추가
              Text(
                '로그인',
                style: TextStyle(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: '아이디를 입력하세요',
                  labelStyle: const TextStyle(color: Color(0xff3297DF)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.03),

              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: '비밀번호를 입력하세요',
                  labelStyle: const TextStyle(color: Color(0xff3297DF)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
                style: const TextStyle(color: Colors.black),
              ),
              SizedBox(height: screenHeight * 0.04),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3297DF),
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.025),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    shadowColor: Colors.grey.withOpacity(0.3),
                    elevation: 6,
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TrashLoginScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
