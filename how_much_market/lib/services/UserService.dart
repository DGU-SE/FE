import 'dart:convert';
import 'package:how_much_market/models/location.dart';
import 'package:how_much_market/models/user.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://13.125.107.235/';

  Future<void> signUp(User user) async {
    final url = Uri.parse('${baseUrl}api/user/join');
    final response = await http.post(url, body: jsonEncode(user.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to sign up.');
    }
  }

  Future<User> login(String id, String pw) async {
    final url = Uri.parse('${baseUrl}api/auth/login');
    final response =
        await http.post(url, body: jsonEncode({'id': id, 'pw': pw}));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to log in.');
    }
  }

  Future<User> getUserInfo(String userId) async {
    final url = Uri.parse('${baseUrl}api/user/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user info.');
    }
  }

  Future<bool> isDuplicateId(String userId) async {
    final url = Uri.parse('${baseUrl}api/user/id/duplicate?userId=$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['isDuplicate'];
    } else {
      throw Exception('Failed to check duplicate ID.');
    }
  }

  Future<void> updateLocation(String userId, Location location) async {
    final url = Uri.parse('${baseUrl}api/user/$userId/location');
    final response = await http.patch(url, body: jsonEncode(location.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to update location.');
    }
  }
}
