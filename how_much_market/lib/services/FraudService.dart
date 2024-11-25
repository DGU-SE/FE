import 'dart:convert';
import 'package:http/http.dart' as http;

class FraudService {
  final String baseUrl = 'http://13.125.107.235/';

  Future<void> reportFraud(Map<String, dynamic> fraudDetails) async {
    final url = Uri.parse('${baseUrl}api/fraud/report');
    final response = await http.post(url, body: jsonEncode(fraudDetails));

    if (response.statusCode != 200) {
      throw Exception('Failed to report fraud.');
    }
  }
}
