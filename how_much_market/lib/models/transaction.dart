import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/models/user.dart';

class Transaction {
  final int id;
  final int finalPrice;
  final String status;
  final Product product;
  final User buyer;
  final User seller;

  Transaction({
    required this.id,
    required this.finalPrice,
    required this.status,
    required this.product,
    required this.buyer,
    required this.seller,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      finalPrice: json['finalPrice'],
      status: json['status'],
      product: Product.fromJson(json['product']),
      buyer: User.fromJson(json['buyer']),
      seller: User.fromJson(json['seller']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'finalPrice': finalPrice,
      'status': status,
      'product': product.toJson(),
      'buyer': buyer.toJson(),
      'seller': seller.toJson(),
    };
  }
}
