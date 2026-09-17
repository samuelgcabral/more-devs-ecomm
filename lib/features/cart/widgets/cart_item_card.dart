import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/cart/models/cart_item.dart';
import 'package:more_devs_do_zero/features/cart/widgets/confirm_remove_dialog.dart';
import 'package:more_devs_do_zero/features/cart/widgets/quantity_button.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/animated_price_text.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.cartController,
  });

  final ProductCart item;
  final CartController cartController;

  static const _imageSize = 104.0;
  static const _cardRadius = 20.0;
  static const _quantityMinWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: _imageSize,
            height: _imageSize,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const ColoredBox(
                  color: Color(0xFFF2F2F2),
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.subTitle.copyWith(fontSize: 16),
                          ),
                          Text(
                            item.brand,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.smallGrey.copyWith(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedPriceText(
                      value: item.subtotal,
                      style: AppTextStyle.title.copyWith(fontSize: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  spacing: 32,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QuantityButton(
                      icon: Icons.remove,
                      onPressed: () => _decrement(context),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: _quantityMinWidth,
                      ),
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.title,
                      ),
                    ),
                    QuantityButton(
                      icon: Icons.add,
                      onPressed: () => cartController.updateQuantity(
                        item,
                        item.quantity + 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _decrement(BuildContext context) async {
    if (item.quantity == 1) {
      final confirmed = await confirmRemoveFromCart(context, item.name);
      if (confirmed) {
        cartController.removeFromCart(item);
      }
    } else {
      cartController.updateQuantity(item, item.quantity - 1);
    }
  }
}
