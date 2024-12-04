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
  final List<Map<String, dynamic>> productPictures;
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

  Product copyWith({
    int? id,
    String? name,
    String? productDetail,
    String? locationName,
    int? price,
    int? currentPrice,
    String? regTime,
    String? dealTime,
    String? auctionEndTime,
    String? productStatus,
    bool? onAuction,
    List<Map<String, dynamic>>? productPictures,
    double? distanceKiloMeter,
    int? locationId,
    String? userName,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      productDetail: productDetail ?? this.productDetail,
      locationName: locationName ?? this.locationName,
      price: price ?? this.price,
      currentPrice: currentPrice ?? this.currentPrice,
      regTime: regTime ?? this.regTime,
      dealTime: dealTime ?? this.dealTime,
      auctionEndTime: auctionEndTime ?? this.auctionEndTime,
      productStatus: productStatus ?? this.productStatus,
      onAuction: onAuction ?? this.onAuction,
      productPictures: productPictures ?? this.productPictures,
      distanceKiloMeter: distanceKiloMeter ?? this.distanceKiloMeter,
      locationId: locationId ?? this.locationId,
      userName: userName ?? this.userName,
    );
  }

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
