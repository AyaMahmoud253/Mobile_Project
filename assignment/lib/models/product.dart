class Product {
  final int id;
  final String name;
  final int restaurantId;

  Product({
    required this.id,
    required this.name,
    required this.restaurantId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['Id'],
      name: json['Name'],
      restaurantId: json['RestaurantId'],
    );
  }
}
