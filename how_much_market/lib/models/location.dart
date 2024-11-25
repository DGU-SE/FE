class Location {
  final double longitude;
  final double latitude;
  final String zipcode;
  final String address;
  final String addressDetail;

  Location({
    required this.longitude,
    required this.latitude,
    required this.zipcode,
    required this.address,
    required this.addressDetail,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      longitude: json['longitude'],
      latitude: json['latitude'],
      zipcode: json['zipcode'],
      address: json['address'],
      addressDetail: json['addressDetail'],
    );
  }
}
