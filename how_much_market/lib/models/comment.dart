class Comment {
  final int productId;
  final String userId;
  final String content;
  final bool secret;

  Comment({
    required this.productId,
    required this.userId,
    required this.content,
    required this.secret,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      productId: json['productId'],
      userId: json['userId'],
      content: json['content'],
      secret: json['secret'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'userId': userId,
      'content': content,
      'secret': secret,
    };
  }
}
