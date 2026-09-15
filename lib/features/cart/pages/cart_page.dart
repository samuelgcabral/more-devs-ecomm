import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/cart/widgets/quantity_button.dart';
import 'package:more_devs_do_zero/shared/widgets/app_elevated_button.dart';
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
              final item = items[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: image, name/brand, and price+delete pinned
                    // to the top-right corner of the card.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const ColoredBox(
                                    color: Color(0xFFF2F2F2),
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text(item.name), Text(item.brand)],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'R\$${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.delete, size: 20),
                                    onPressed: () {
                                      cartController.removeFromCart(item);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Second row: quantity stepper, indented to sit under
                    // the name/brand column above (past the 56px image +
                    // 8px gap).
                    Padding(
                      padding: const EdgeInsets.only(left: 64),
                      child: Row(
                        children: [
                          QuantityButton(
                            icon: Icons.remove,
                            onPressed: () async {
                              if (item.quantity == 1) {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Remover item'),
                                    content: Text(
                                      'Remover ${item.name} do carrinho?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, true),
                                        child: const Text('Remover'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true) {
                                  cartController.removeFromCart(item);
                                }
                              } else {
                                cartController.updateQuantity(
                                  item,
                                  item.quantity - 1,
                                );
                              }
                            },
                          ),
                          SizedBox(
                            width: 40,
                            child: Text(
                              '${item.quantity}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          QuantityButton(
                            icon: Icons.add,
                            onPressed: () {
                              cartController.updateQuantity(
                                item,
                                item.quantity + 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
              border: Border(top: BorderSide(color: Colors.black26)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'R\$${cartController.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 160,
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
