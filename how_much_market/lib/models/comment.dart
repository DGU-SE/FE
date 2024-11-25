import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/models/user.dart';

class Comment {
  final int id;
  final Product product;
  final User user;
  final String content;
  final String createdAt;
  final bool isSecret;

  Comment({
    required this.id,
    required this.product,
    required this.user,
    required this.content,
    required this.createdAt,
    required this.isSecret,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      product: Product.fromJson(json['product']),
      user: User.fromJson(json['user']),
      content: json['content'],
      createdAt: json['createdAt'],
      isSecret: json['isSecret'],
    );
  }
}
