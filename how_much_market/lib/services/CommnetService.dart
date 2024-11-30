import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:how_much_market/models/comment.dart';

class CommentService {
  static const String baseUrl = 'http://13.125.107.235/api/comment';

  // 댓글 가져오기
  static Future<List<Comment>> fetchComments(
      int productId, String token) async {
    final url = Uri.parse('http://13.125.107.235/api/comment/$productId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((commentData) => Comment.fromJson(commentData)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

// 댓글 등록하기
  static Future<void> registerComment(
      int productId, String userId, String content, bool isSecret) async {
    final requestBody = {
      "productId": productId,
      "userId": userId,
      "content": content,
      "isSecret": isSecret
    };

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print('댓글 등록 성공: $responseBody');
      } else {
        print('댓글 등록 실패: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('예외 발생: $e');
    }
  }
}
