import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/currency_format.dart';
import 'package:more_devs_do_zero/shared/widgets/animated_price_text.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});
  static const String route = '/checkout';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5FC),
      appBar: AppBar(
        title: Text('Finalizar pedido', style: AppTextStyle.subTitle),
        centerTitle: true,
      ),
      body: Consumer<CartController>(
        builder: (context, cartController, child) {
          final items = cartController.items;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Hero(
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
                        Text('Total do pedido', style: AppTextStyle.smallGrey),
                        const SizedBox(height: 6),
                        AnimatedPriceText(
                          value: cartController.totalPrice,
                          style: AppTextStyle.title,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${items[index].quantity}x ${items[index].name}',
                            style: AppTextStyle.smallBlack,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          items[index].subtotal.toBRL(),
                          style: AppTextStyle.smallGrey,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: AppElevatedButton(
              label: 'Confirmar pedido',
              type: ButtonType.filled,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
