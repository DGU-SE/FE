import 'dart:convert';
import 'package:http/http.dart' as http;

class FraudService {
  final String baseUrl = 'http://13.125.107.235/';

  Future<void> reportFraud(int productId, String description) async {
    final url = Uri.parse('${baseUrl}api/fraud-report');
    final Map<String, dynamic> fraudDetails = {
      'productId': productId,
      'description': description,
    };
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(fraudDetails),
    );

    if (response.statusCode != 200) {
      print('응답 본문: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to report fraud: ${response.body}');
    }
  }
}
