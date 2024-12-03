class Product {
  final int id;
  final String name;
  final String productDetail;
  final int price;
  final int currentPrice;
  String locationName;
  final String regTime;
  final String dealTime;
  final String auctionEndTime;
  final String productStatus;
  final bool onAuction;
  final List<Map<String, dynamic>>
      productPictures; // Map<String, dynamic>로 리스트 유지
  final double distanceKiloMeter;
  final int locationId;
  final String userName;

  Product({
    required this.id,
    required this.name,
    required this.productDetail,
    this.locationName = '',
    required this.price,
    required this.currentPrice,
    required this.regTime,
    required this.dealTime,
    required this.auctionEndTime,
    required this.productStatus,
    required this.onAuction,
    required this.productPictures,
    required this.distanceKiloMeter,
    required this.locationId,
    required this.userName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print('Raw distanceKiloMeter: ${json['distanceKiloMeter']}');
    print(
        'Raw distanceKiloMeter type: ${json['distanceKiloMeter'].runtimeType}');
    return Product(
      id: json['id'],
      name: json['name'],
      productDetail: json['productDetail'],
      locationName: json['locationName'] ?? '',
      price: json['price'],
      currentPrice: json['currentPrice'],
      regTime: json['regTime'],
      dealTime: json['dealTime'],
      auctionEndTime: json['auctionEndTime'],
      productStatus: json['productStatus'],
      onAuction: json['onAuction'],
      productPictures: List<Map<String, dynamic>>.from(json['productPictures']),
      distanceKiloMeter: json['distanceKiloMeter'] ?? 0.0,
      locationId: json['locationId'] ?? 0,
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'productDetail': productDetail,
      'price': price,
      'currentPrice': currentPrice,
      'regTime': regTime,
      'dealTime': dealTime,
      'auctionEndTime': auctionEndTime,
      'productStatus': productStatus,
      'onAuction': onAuction,
      'productPictures': productPictures,
      'distanceKiloMeter': distanceKiloMeter,
      'locationId': locationId,
      'userName': userName,
    };
  }
}
