import 'package:flutter/material.dart';

class RegistrationListScreen extends StatefulWidget {
  const RegistrationListScreen({super.key});

  @override
  State<RegistrationListScreen> createState() => _RegistrationListScreenState();
}

class _RegistrationListScreenState extends State<RegistrationListScreen> {
  // 예시 데이터
  final List<Map<String, dynamic>> exampleData = [
    {
      'id': 1,
      'title': 'Example Product 1',
      'date': '2024-11-16',
      'price': '₩10,000',
      'image': 'https://via.placeholder.com/150', // 임시 이미지 URL
    },
    {
      'id': 2,
      'title': 'Example Product 2',
      'date': '2024-11-15',
      'price': '₩20,000',
      'image': 'https://via.placeholder.com/150',
    },
  ];

  @override
  void initState() {
    super.initState();
    // 나중에 API로 데이터를 받아올 경우 이 부분 사용
    // fetchData();
  }

  // API로 데이터 가져오는 메서드 (주석 처리)
  // Future<void> fetchData() async {
  //   // 예: API 호출 및 상태 업데이트
  //   final response = await http.get(Uri.parse('API_ENDPOINT'));
  //   setState(() {
  //     exampleData = jsonDecode(response.body);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 흰색
      appBar: AppBar(
        title: const Text('내가 올린 상품 목록'),
      ),
      body: ListView.builder(
        itemCount: exampleData.length,
        itemBuilder: (context, index) {
          final item = exampleData[index];
          return Card(
            color: const Color(0xFFF5F5F5), // 카드 배경색: 아주 옅은 회색
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // 이미지: 1:1 비율 유지
                  Flexible(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1, // 1:1 비율 유지
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(item['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // 상품 정보 및 버튼
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          '날짜: ${item['date']}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        Text(
                          '가격: ${item['price']}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            // 수정 버튼
                            Flexible(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff3297DF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  print('수정 ${item['id']}');
                                },
                                child: const Text(
                                  '수정',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            // 삭제 버튼
                            Flexible(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Color(0xff3297DF)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                onPressed: () {
                                  print('삭제 ${item['id']}');
                                },
                                child: const Text(
                                  '삭제',
                                  style: TextStyle(
                                    color: Color(0xff3297DF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
