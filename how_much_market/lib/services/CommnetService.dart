import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:how_much_market/models/comment.dart';

class CommentService {
  static const String baseUrl = 'http://13.125.107.235/api/comment';

  // 댓글 가져오기
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

  // 댓글 등록하기
  static Future<void> registerComment(
    int productId,
    String token,
    String content,
    bool isSecret,
    String userId, // 사용자 ID 추가
  ) async {
    final Map<String, dynamic> requestData = {
      'productId': productId,
      'userId': userId,
      'content': content,
      'isSecret': isSecret,
    };

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Authorization 헤더에 토큰 추가
      },
      body: json.encode(requestData),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to register comment');
    }
  }
}
