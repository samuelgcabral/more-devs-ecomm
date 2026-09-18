import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/animated_price_text.dart';

class CartTotalCard extends StatelessWidget {
  const CartTotalCard({super.key, required this.total});

  static const String heroTag = 'cart_total';

  final double total;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(28),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total do pedido', style: AppTextStyle.smallGrey),
                const SizedBox(height: 6),
                AnimatedPriceText(value: total, style: AppTextStyle.title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
