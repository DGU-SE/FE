class Comment {
  final String userId;
  final String content;
  final bool secret;

  Comment({
    required this.userId,
    required this.content,
    required this.secret,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'],
      content: json['content'],
      secret: json['secret'],
    );
  }
}
