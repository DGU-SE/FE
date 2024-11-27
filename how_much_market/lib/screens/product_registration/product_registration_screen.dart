import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductRegistrationScreen extends StatefulWidget {
  const ProductRegistrationScreen({super.key});

  @override
  _ProductRegistrationScreenState createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  String saleType = 'auction'; // 기본값: '경매'
  int auctionDuration = 1;
  DateTime auctionEndTime = DateTime.now().add(const Duration(days: 1));
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  // 상품 등록 API
  Future<void> registerProduct({
    required String saleType,
    required String title,
    required int price,
    required DateTime auctionEndTime,
    required String productDetail,
    required String location,
    required bool onAuction,
  }) async {
    const String apiUrl = 'http://13.125.107.235/api/product'; // 서버 API URL

    final Map<String, dynamic> requestData = {
      'name': title,
      'price': price,
      'dealTime': auctionEndTime.toIso8601String(),
      'locationDTO': {
        'longitude': 22.22, // 예시로 넣은 값, 실제 경도 값으로 바꿔야 함
        'latitude': 33.33, // 예시로 넣은 값, 실제 위도 값으로 바꿔야 함
        'zipcode': null,
        'address': location,
        'addressDetail': null,
      },
      'productDetail': productDetail,
      'onAuction': onAuction,
      'userId': 'unique-user-id', // 실제 사용자 ID를 넣어야 함
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer token', // 실제 토큰을 입력해야 함
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 상품 등록 성공
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('상품이 등록되었습니다.')),
        );
        Navigator.pop(context); // 등록 후 화면 닫기
      } else {
        throw Exception('상품 등록 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품 등록 실패: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("상품 등록"),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 판매 방식 라벨 및 라디오 버튼
              Text(
                '판매방식',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: screenHeight * 0.01),
              Row(
                children: [
                  _buildRadioButton('경매', 'auction', theme),
                  _buildRadioButton('즉시판매', 'direct', theme),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              // 사진 업로드 버튼
              Text(
                '사진 업로드',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: screenHeight * 0.01),
              SizedBox(
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
                child: OutlinedButton(
                  onPressed: () {
                    // 사진 업로드 기능 추가 예정
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.primaryColorLight,
                    side: BorderSide(color: theme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 제목 입력 필드
              Text(
                '제목*',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: '상품 제목을 입력하세요',
                  hintStyle: theme.textTheme.titleSmall,
                  filled: true,
                  fillColor: theme.primaryColorLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 가격 입력 필드
              Text(
                '가격*',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: priceController,
                decoration: InputDecoration(
                  hintText:
                      saleType == 'auction' ? '경매 시작 가격을 입력하세요' : '가격을 입력하세요',
                  hintStyle: theme.textTheme.titleSmall,
                  filled: true,
                  fillColor: theme.primaryColorLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),

              // 경매 기간 설정
              if (saleType == 'auction')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      '경매 기간',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        // 경매 기간 드롭다운
                        SizedBox(
                          width: screenWidth * 0.3,
                          child: DropdownButtonFormField<int>(
                            value: auctionDuration,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: theme.primaryColorLight,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            items: [1, 3, 7]
                                .map((day) => DropdownMenuItem(
                                      value: day,
                                      child: Text('$day일'),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  auctionDuration = value;
                                  auctionEndTime = DateTime.now()
                                      .add(Duration(days: auctionDuration));
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),

                        // 경매 종료 시간 표시
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.primaryColorLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${auctionEndTime.year}-${auctionEndTime.month.toString().padLeft(2, '0')}-${auctionEndTime.day.toString().padLeft(2, '0')} ${auctionEndTime.hour.toString().padLeft(2, '0')}:${auctionEndTime.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: screenHeight * 0.02),

              // 상품 설명 필드
              Text(
                '상품 설명',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '상품 설명을 입력하세요',
                  hintStyle: theme.textTheme.titleSmall,
                  filled: true,
                  fillColor: theme.primaryColorLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // 거래 희망 장소 필드
              Text(
                '거래 희망 장소',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: screenHeight * 0.01),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  hintText: '거래 희망 장소를 입력하세요',
                  hintStyle: theme.textTheme.titleSmall,
                  filled: true,
                  fillColor: theme.primaryColorLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              // 등록 버튼
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      // 제목과 가격이 비어 있으면 경고 메시지
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('제목과 가격을 입력해주세요')),
                      );
                    } else {
                      // 서버에 데이터 전송
                      registerProduct(
                        saleType: saleType,
                        title: titleController.text,
                        price: int.parse(priceController.text),
                        auctionEndTime: auctionEndTime,
                        productDetail: descriptionController.text,
                        location: locationController.text,
                        onAuction: saleType == 'auction',
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.3, vertical: 15),
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "등록하기",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label, String value, ThemeData theme) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            saleType = value;
            // 경매 시작 가격으로 힌트를 바꿔주는 코드
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: saleType == value ? theme.primaryColor : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: saleType == value ? theme.primaryColor : Colors.black38,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                saleType == value
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: saleType == value ? Colors.white : Colors.black54,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: saleType == value ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
