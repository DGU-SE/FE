import 'package:flutter/material.dart';

class BidListScreen extends StatefulWidget {
  const BidListScreen({super.key});

  @override
  State<BidListScreen> createState() => _BidListScreenState();
}

class _BidListScreenState extends State<BidListScreen> {
  // 예시 데이터
  final List<Map<String, dynamic>> exampleData = [
    {
      'id': 1,
      'title': 'Auction Item 1',
      'startBid': '₩5,000',
      'currentBid': '₩15,000',
      'myBid': '₩12,000',
      'image': 'https://via.placeholder.com/150', // 임시 이미지 URL
    },
    {
      'id': 2,
      'title': 'Auction Item 2',
      'startBid': '₩10,000',
      'currentBid': '₩25,000',
      'myBid': '₩20,000',
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
        title: const Text('내 입찰 상품 목록'),
        // 테마 색
      ),
      body: ListView.builder(
        itemCount: exampleData.length,
        itemBuilder: (context, index) {
          final item = exampleData[index];
          return Card(
            color: const Color(0xFFF5F5F5), // 카드 배경색 아주 옅은 회색
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
                  // 입찰 정보 및 제목
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
                          '입찰 시작가: ${item['startBid']}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        Text(
                          '현재 최고가: ${item['currentBid']}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff3297DF),
                          ),
                        ),
                        Text(
                          '나의 입찰가: ${item['myBid']}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
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
