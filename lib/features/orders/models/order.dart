import 'package:more_devs_do_zero/features/orders/models/order_item.dart';

class Order {
  const Order({
    required this.id,
    required this.status,
    required this.items,
    required this.itemCount,
    required this.total,
    required this.notes,
    required this.createdAt,
  });

  final String id;
  final String status;
  final List<OrderItem> items;
  final int itemCount;
  final double total;
  final String? notes;
  final DateTime createdAt;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      itemCount: json['itemCount'] as int,
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
