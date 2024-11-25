import 'package:how_much_market/models/bid.dart';
import 'package:how_much_market/models/product.dart';

class Auction {
  final int id;
  final int startPrice;
  final int currentPrice;
  final String startTime;
  final String endTime;
  final String status;
  final Product product;
  final List<Bid> bids;

  Auction({
    required this.id,
    required this.startPrice,
    required this.currentPrice,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.product,
    required this.bids,
  });

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
      id: json['id'],
      startPrice: json['startPrice'],
      currentPrice: json['currentPrice'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      product: Product.fromJson(json['product']),
      bids: (json['bids'] as List).map((e) => Bid.fromJson(e)).toList(),
    );
  }
}
