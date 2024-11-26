import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:how_much_market/models/comment.dart';

class CommentService {
  static const String baseUrl = 'http://13.125.107.235/api/comment';

  static Future<List<Comment>> fetchComments(
      int productId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$productId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Comment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch comments');
    }
  }
}
