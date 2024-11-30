import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data'; // UTF-8 디코딩을 위한 패키지

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  String _responseMessage = '';
  List<dynamic> _comments = []; // 댓글 리스트를 저장

  // 댓글 조회 요청을 보내는 함수
  Future<void> fetchComments() async {
    final url = Uri.parse('http://13.125.107.235/api/comment/1'); // IP 주소 수정
    String authToken = await getAuthToken(); // SharedPreferences에서 토큰 가져오기

    if (authToken.isEmpty) {
      setState(() {
        _responseMessage = '인증 토큰이 없습니다.';
      });
      return;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken', // Bearer 토큰 헤더에 추가
          'Content-Type': 'application/json',
        },
      );

      // 서버에서 받은 응답 상태 코드 확인
      if (response.statusCode == 200) {
        try {
          // 응답 데이터를 UTF-8로 디코딩하여 출력
          String decodedResponse =
              utf8.decode(response.bodyBytes); // bodyBytes로 바이트 배열을 가져오고 디코딩
          print('응답 데이터: $decodedResponse');

          // 응답을 JSON 배열로 파싱
          List<dynamic> jsonResponse = json.decode(decodedResponse);

          // 댓글 목록을 _comments에 저장
          setState(() {
            _comments = jsonResponse;
            _responseMessage = '댓글 조회 성공';
          });
        } catch (e) {
          setState(() {
            _responseMessage = '응답 데이터 파싱 오류: $e';
          });
        }
      } else {
        setState(() {
          _responseMessage =
              '댓글 조회 실패: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = '오류 발생: $e';
      });
    }
  }

  // SharedPreferences에서 토큰을 가져오는 함수
  Future<String> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken') ?? ''; // 기본값은 빈 문자열
  }

  @override
  void initState() {
    super.initState();
    fetchComments(); // 화면이 시작될 때 자동으로 댓글 조회
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('댓글 조회'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _responseMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 20),
            // 댓글 목록 표시
            _comments.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true, // 리스트뷰가 화면을 벗어나지 않게 함
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      var comment = _comments[index];
                      return ListTile(
                        title: Text(comment['content']),
                        subtitle: Text('작성자: ${comment['userId']}'),
                        trailing: comment['secret']
                            ? const Icon(Icons.lock, color: Colors.red)
                            : null, // secret 댓글은 자물쇠 아이콘 표시
                      );
                    },
                  )
                : Container(), // 댓글이 없으면 빈 화면 표시
          ],
        ),
      ),
    );
  }
}
