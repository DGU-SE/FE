class ProductSearch {
  final int id;
  final String name;
  final int price;
  final String productDetail;
  final String locationName;
  final DateTime regTime;
  final DateTime dealTime;
  final String productStatus;
  final bool onAuction;

  ProductSearch({
    required this.id,
    required this.name,
    required this.price,
    required this.productDetail,
    required this.locationName,
    required this.regTime,
    required this.dealTime,
    required this.productStatus,
    required this.onAuction,
  });

  factory ProductSearch.fromJson(Map<String, dynamic> json) {
    return ProductSearch(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      productDetail: json['productDetail'],
      locationName: json['locationName'],
      regTime: DateTime.parse(json['regTime']),
      dealTime: DateTime.parse(json['dealTime']),
      productStatus: json['productStatus'],
      onAuction: json['onAuction'],
    );
  }
}
