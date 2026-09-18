import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/cart/pages/checkout_page.dart';
import 'package:more_devs_do_zero/features/cart/widgets/cart_item_card.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/animated_price_text.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  static const String route = '/cart';

  // static const _continueButtonWidth = 160.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5FC),
      appBar: AppBar(
        title: Text('Carrinho', style: AppTextStyle.subTitle),
        centerTitle: true,
      ),
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
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 128,
                      color: Colors.black,
                    ),
                    SizedBox(height: 16),
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
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
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
          if (cartController.items.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: 'cart_total',
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total do pedido',
                            style: AppTextStyle.smallGrey,
                          ),
                          const SizedBox(height: 6),
                          AnimatedPriceText(
                            value: cartController.totalPrice,
                            style: AppTextStyle.title,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: AppElevatedButton(
                      label: 'Continuar',
                      type: ButtonType.filled,
                      onPressed: () =>
                          Navigator.pushNamed(context, CheckoutPage.route),
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
