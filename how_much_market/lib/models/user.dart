import 'package:how_much_market/models/location.dart';
import 'package:how_much_market/models/product.dart';
import 'package:how_much_market/models/transaction.dart';

class User {
  final String id;
  final String pw;
  final String name;
  final String accountNumber;
  final Location location;
  final List<Product> products;
  final List<Transaction> purchases;
  final List<Transaction> sales;

  User({
    required this.id,
    required this.pw,
    required this.name,
    required this.accountNumber,
    required this.location,
    required this.products,
    required this.purchases,
    required this.sales,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      pw: json['pw'],
      name: json['name'],
      accountNumber: json['accountNumber'],
      location: Location.fromJson(json['location']),
      products:
          (json['products'] as List).map((e) => Product.fromJson(e)).toList(),
      purchases: (json['purchases'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList(),
      sales:
          (json['sales'] as List).map((e) => Transaction.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pw': pw,
      'name': name,
      'accountNumber': accountNumber,
      'location': location.toJson(),
      'products': products.map((e) => e.toJson()).toList(),
      'purchases': purchases.map((e) => e.toJson()).toList(),
      'sales': sales.map((e) => e.toJson()).toList(),
    };
  }
}
