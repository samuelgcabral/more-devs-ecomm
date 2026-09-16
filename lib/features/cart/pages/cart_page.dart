import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/cart/widgets/cart_item_card.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/animated_price_text.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  static const String route = '/cart';

  static const _continueButtonWidth = 160.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrinho', style: AppTextStyle.subTitle)),
      body: Consumer<CartController>(
        builder: (context, cartController, child) {
          final items = cartController.items;
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Seu carrinho está vazio.'),
                    const SizedBox(height: 16),
                    AppElevatedButton(
                      label: 'Voltar para a loja',
                      type: ButtonType.filled,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return CartItemCard(
                item: items[index],
                cartController: cartController,
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartController>(
        builder: (context, cartController, child) {
          if (cartController.items.isEmpty) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AnimatedPriceText(
                      value: cartController.totalPrice,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.title,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: _continueButtonWidth,
                    child: AppElevatedButton(
                      label: 'Continuar',
                      type: ButtonType.filled,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
