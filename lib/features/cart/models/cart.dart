import 'package:more_devs_do_zero/features/cart/models/cart_item.dart';

class Cart {
  const Cart({
    required this.items,
    required this.itemCount,
    required this.total,
  });

  const Cart.empty() : items = const [], itemCount = 0, total = 0;

  final List<CartItem> items;
  final int itemCount;
  final double total;

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      itemCount: json['itemCount'] as int,
      total: (json['total'] as num).toDouble(),
    );
  }
}
