import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/cart/pages/cart_page.dart';
import 'package:provider/provider.dart';

class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCount = context.watch<CartController>().itemCount;

    return Badge(
      isLabelVisible: itemCount > 0,
      label: Text('$itemCount'),
      child: IconButton(
        tooltip: 'Carrinho',
        icon: const Icon(Icons.shopping_cart_outlined),
        onPressed: () => Navigator.pushNamed(context, CartPage.route),
      ),
    );
  }
}
