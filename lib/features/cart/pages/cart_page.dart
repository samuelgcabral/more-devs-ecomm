import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  static const String route = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrinho')),
      body: Consumer<CartController>(
        builder: (context, cartController, child) {
          final items = cartController.items;
          if (items.isEmpty) {
            return const Center(child: Text('Seu carrinho está vazio.'));
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:'),
                    Text('\$${cartController.totalPrice.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.network(item.imageUrl, width: 50, height: 50),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name),
                                Text('\$${item.price.toStringAsFixed(2)}'),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                cartController.updateQuantity(
                                  item,
                                  item.quantity - 1,
                                );
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cartController.updateQuantity(
                                  item,
                                  item.quantity + 1,
                                );
                              },
                            ),
                          ],
                        ),
                        Text('Subtotal: \$${item.subtotal.toStringAsFixed(2)}'),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cartController.removeFromCart(item);
                          },
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
    );
  }
}
