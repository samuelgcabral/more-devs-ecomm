import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/home/widgets/product_card.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.products,
  });

  final bool isLoading;
  final bool hasError;
  final List<Product> products;

  static final List<Product> _fakeProducts = List.filled(
    4,
    Product(
      brand: 'Marca do produto',
      name: 'Nome do produto',
      imageUrl: '',
      price: 0,
      category: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Produtos', style: AppTextStyle.title),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
        if (hasError)
          const Text('Problema ao resgatar produtos')
        else
          Builder(
            builder: (context) {
              final items = isLoading ? _fakeProducts : products;

              return Skeletonizer(
                enabled: isLoading,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: isLoading
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  child: IntrinsicHeight(
                    child: Row(
                      children: items.map((Product product) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            width: 150,
                            child: ProductCard(product: product),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
