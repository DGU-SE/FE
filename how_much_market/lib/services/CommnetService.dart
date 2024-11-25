import 'dart:convert';
import 'package:http/http.dart' as http;

class CommentService {
  final String baseUrl = 'http://13.125.107.235/';

  Future<void> postComment(int productId, String comment) async {
    final url = Uri.parse('${baseUrl}api/comment');
    final response = await http.post(url,
        body: jsonEncode({'productId': productId, 'comment': comment}));

    if (response.statusCode != 200) {
      throw Exception('Failed to post comment.');
    }
  }

  Future<List<dynamic>> getComments(int productId) async {
    final url = Uri.parse('${baseUrl}api/comment/$productId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch comments.');
    }
  }
}
