class OrderItem {
  const OrderItem({
    required this.productId,
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });

  // Pode ser null se o produto tiver sido removido do catálogo depois da compra.
  final String? productId;
  final String name;
  final String brand;
  final String imageUrl;
  final double unitPrice;
  final int quantity;
  final double subtotal;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String?,
      name: json['name'] as String,
      brand: json['brand'] as String,
      imageUrl: json['imageUrl'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}
