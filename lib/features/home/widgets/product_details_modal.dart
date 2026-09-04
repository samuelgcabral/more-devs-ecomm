import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';

class ProductDetailsModal extends StatelessWidget {
  const ProductDetailsModal({super.key, required this.product});

  final Product product;

  static Future<void> show(BuildContext context, Product product) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) => ProductDetailsModal(product: product),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Center(child: Text(product.name)),
    );
  }
}
