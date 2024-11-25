import 'package:how_much_market/models/product.dart';

class ProductPicture {
  final int id;
  final String blobUrl;
  final Product product;

  ProductPicture({
    required this.id,
    required this.blobUrl,
    required this.product,
  });

  factory ProductPicture.fromJson(Map<String, dynamic> json) {
    return ProductPicture(
      id: json['id'],
      blobUrl: json['blobUrl'],
      product: Product.fromJson(json['product']),
    );
  }
}
