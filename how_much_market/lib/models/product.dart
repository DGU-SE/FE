class Product {
  final int id;
  final String name;
  final String productDetail;
  final int price;
  String locationName;
  final String regTime;
  final String dealTime;
  final String productStatus;
  final bool onAuction;
  final List<Map<String, dynamic>>
      productPictures; // Map<String, dynamic>로 리스트 유지
  final double distanceKiloMeter;
  final int locationId;

  Product({
    required this.id,
    required this.name,
    required this.productDetail,
    this.locationName = '',
    required this.price,
    required this.regTime,
    required this.dealTime,
    required this.productStatus,
    required this.onAuction,
    required this.productPictures,
    required this.distanceKiloMeter,
    required this.locationId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      productDetail: json['productDetail'],
      locationName: json['locationName'] ?? '',
      price: json['price'],
      regTime: json['regTime'],
      dealTime: json['dealTime'],
      productStatus: json['productStatus'],
      onAuction: json['onAuction'],
      productPictures: List<Map<String, dynamic>>.from(json['productPictures']),
      distanceKiloMeter: json['distanceKiloMeter'] ?? 0.0,
      locationId: json['locationId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'productDetail': productDetail,
      'price': price,
      'regTime': regTime,
      'dealTime': dealTime,
      'productStatus': productStatus,
      'onAuction': onAuction,
      'productPictures': productPictures,
      'distanceKiloMeter': distanceKiloMeter,
      'locationId': locationId,
    };
  }
}
