class Product {
  final String brand;
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final String description;
  final String id;

  Product({
    required this.id,
    required this.category,
    required this.brand,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      brand: json['brand'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      description: json['description'],
      id:
          json['id'] ??
          (throw ArgumentError('Product JSON must contain an "id" field.')),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
