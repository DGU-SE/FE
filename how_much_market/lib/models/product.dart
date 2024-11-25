import 'package:how_much_market/models/user.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final int price;
  final User seller;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.seller,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      seller: User.fromJson(json['seller']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'seller': seller.toJson(),
    };
  }
}
