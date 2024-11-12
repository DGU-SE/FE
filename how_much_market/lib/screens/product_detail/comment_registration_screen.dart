import 'package:flutter/material.dart';

class CommentRegistrationScreen extends StatefulWidget {
  final String productTitle;

  const CommentRegistrationScreen({super.key, required this.productTitle});

  @override
  _CommentRegistrationScreenState createState() =>
      _CommentRegistrationScreenState();
}

class _CommentRegistrationScreenState extends State<CommentRegistrationScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isSecret = false;

  void _registerComment() {
    if (_commentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("댓글 내용을 입력해주세요.")),
      );
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("댓글이 등록되었습니다.")),
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
