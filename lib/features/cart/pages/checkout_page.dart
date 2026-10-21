import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/home/pages/home_page.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/currency_format.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
import 'package:more_devs_do_zero/shared/widgets/app_snack_bar.dart';
import 'package:more_devs_do_zero/shared/widgets/cart_total_card.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});
  static const String route = '/checkout';

  Future<void> _confirmOrder(
    BuildContext context,
    CartController cartController,
  ) async {
    try {
      await cartController.checkout();
      if (!context.mounted) return;
      showSuccessSnackBar(context, 'Pedido realizado com sucesso');
      Navigator.popUntil(context, ModalRoute.withName(HomePage.route));
    } on ApiException catch (e) {
      if (!context.mounted) return;
      showErrorSnackBar(context, e.message);
    }
  }

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
                child: CartTotalCard(total: cartController.totalPrice),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.product.name} ${item.product.brand}',
                            style: AppTextStyle.smallBlack,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          item.subtotal.toBRL(),
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
            child: Consumer<CartController>(
              builder: (context, cartController, child) {
                return AppElevatedButton(
                  label: 'Confirmar pedido',
                  type: ButtonType.filled,
                  isLoading: cartController.isUpdating,
                  onPressed: cartController.items.isEmpty
                      ? null
                      : () => _confirmOrder(context, cartController),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
