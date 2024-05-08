import 'package:assignment/models/product.dart';

class Restaurant {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['Id'],
      name: json['Name'],
      address: json['Address'],
      latitude: json['Latitude'],
      longitude: json['Longitude'],
    );
  }
}
