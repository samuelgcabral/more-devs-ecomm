import 'package:more_devs_do_zero/features/home/models/product_model.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    required this.subtotal,
  });

  final Product product;
  final int quantity;
  final double subtotal;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}
