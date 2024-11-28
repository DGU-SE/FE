import 'package:flutter/material.dart';
import 'package:how_much_market/services/CommnetService.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 경로 확인 필요

class CommentRegistrationScreen extends StatefulWidget {
  final String productTitle;
  final int productId; // productId 추가

  const CommentRegistrationScreen({
    super.key,
    required this.productTitle,
    required this.productId, // productId 전달
  });

  @override
  _CommentRegistrationScreenState createState() =>
      _CommentRegistrationScreenState();
}

class _CommentRegistrationScreenState extends State<CommentRegistrationScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSecret = false;

  // 댓글 등록 API 호출
  Future<void> _registerComment() async {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("댓글 내용을 입력해주세요.")),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("유저 ID가 없습니다.")),
        );
        return;
      } else {
        print("유저아이디 : $userId");
      }

      // 댓글 등록 API 호출
      await CommentService.registerComment(
        widget.productId,
        userId,
        _commentController.text,
        _isSecret,
      );

      Navigator.pop(context); // 댓글 등록 후 화면을 닫음
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("댓글이 등록되었습니다.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("댓글 등록 실패: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "댓글 등록",
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
            Text(
              widget.productTitle,
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                color: Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "댓글을 입력하세요",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _isSecret,
                      onChanged: (bool? value) {
                        setState(() {
                          _isSecret = value ?? false;
                        });
                      },
                    ),
                    const Text("비밀글로 등록"),
                  ],
                ),
                TextButton(
                  onPressed: _registerComment,
                  child: const Text("등록"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
