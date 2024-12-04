import 'package:how_much_market/models/auction.dart';
import 'package:how_much_market/models/user.dart';

class Bid {
  final int id;
  final int amount;
  final User user;
  final Auction auction;

  Bid({
    required this.id,
    required this.amount,
    required this.user,
    required this.auction,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'],
      amount: json['amount'],
      user: User.fromJson(json['user']),
      auction: Auction.fromJson(json['auction']),
    );
  }
}
