import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:provider/provider.dart';

class ProductDetailsModal extends StatelessWidget {
  const ProductDetailsModal({
    super.key,
    required this.product,
    required this.scrollController,
  });

  final Product product;
  final ScrollController scrollController;

  static Future<void> show(BuildContext context, Product product) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.73,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        snap: true,
        snapSizes: const [0.73],
        shouldCloseOnMinExtent: true,
        builder: (context, scrollController) => ProductDetailsModal(
          product: product,
          scrollController: scrollController,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      width: 74,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: AspectRatio(
                      aspectRatio: 1.7,
                      child: Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(product.name, style: AppTextStyle.title),
                  const SizedBox(height: 2),
                  Text(product.brand, style: AppTextStyle.smallGrey),
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Consumer<CartController>(
            builder: (context, cartController, child) {
              final existingItem = cartController.findByProduct(product);
              return Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: existingItem == null
                        ? ElevatedButton(
                            onPressed: () {
                              cartController.addToCart(product);
                              AnimatedSnackBar.material(
                                '${product.name} adicionado ao carrinho',
                                type: AnimatedSnackBarType.success,
                                mobileSnackBarPosition:
                                    MobileSnackBarPosition.bottom,
                              ).show(context);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text(
                              'Adicionar no carrinho',
                              style: AppTextStyle.buttonLabel.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _QuantityButton(
                                icon: Icons.remove,
                                onPressed: () => cartController.updateQuantity(
                                  existingItem,
                                  existingItem.quantity - 1,
                                ),
                              ),
                              SizedBox(
                                width: 56,
                                child: Text(
                                  '${existingItem.quantity}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _QuantityButton(
                                icon: Icons.add,
                                onPressed: () => cartController.updateQuantity(
                                  existingItem,
                                  existingItem.quantity + 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
