class Comment {
  final String userId;
  final String userName;
  final String content;
  final bool secret;

  Comment({
    required this.userId,
    required this.userName,
    required this.content,
    required this.secret,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'],
      userName: json['userName'],
      content: json['content'],
      secret: json['secret'],
    );
  }
}
