import 'package:flutter/material.dart';
import 'trash_location_setting_screen.dart'; // LocationSettingScreen 파일을 import

class TrashRegisterScreen extends StatefulWidget {
  const TrashRegisterScreen({super.key});

  @override
  State<TrashRegisterScreen> createState() => _TrashRegisterScreenState();
}

class _TrashRegisterScreenState extends State<TrashRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedBank;

  void _checkDuplicateId() {
    // 아이디 중복 확인 로직을 여기에 추가하세요
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('아이디 중복 확인 중...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('회원가입'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.04),

              // 아이디 필드와 중복 확인 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '아이디',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _checkDuplicateId,
                    child: const Text(
                      '중복 확인',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '아이디를 입력하세요',
                  hintStyle: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0), // 패딩 조정
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '아이디를 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.015),

              // 비밀번호 필드
              const Text(
                '비밀번호 (특수문자 포함 8자 이상)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '비밀번호를 입력하세요',
                  hintStyle: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0), // 패딩 조정
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.length < 8 ||
                      !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return '특수문자를 포함하여 8자 이상 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.015),

              // 닉네임 필드
              const Text(
                '닉네임',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '닉네임을 입력하세요',
                  hintStyle: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0), // 패딩 조정
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '닉네임을 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.015),

              // 계좌번호 필드
              const Text(
                '계좌번호',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: '계좌번호를 입력하세요',
                  hintStyle: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0), // 패딩 조정
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '계좌번호를 입력해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.015),

              // 거래은행 필드
              const Text(
                '거래은행',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              DropdownButtonFormField<String>(
                value: selectedBank,
                items: <String>['국민은행', '신한은행', '농협은행', '우리은행']
                    .map((bank) => DropdownMenuItem(
                          value: bank,
                          child: Text(bank),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBank = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: '은행을 선택하세요',
                  hintStyle: TextStyle(
                      color: Colors.grey[500], fontWeight: FontWeight.normal),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 10.0), // 패딩 조정
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '거래은행을 선택해주세요';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.04),

              // 다음 단계 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationSettingScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '다음단계 (거주지설정)',
                    style: TextStyle(
                      fontSize: 16, // slightly reduced font size
                      color: Colors.white,
                      fontWeight: FontWeight.bold, // added bold
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
