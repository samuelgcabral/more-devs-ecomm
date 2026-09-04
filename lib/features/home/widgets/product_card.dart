import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Skeleton.replace(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const ColoredBox(
                        color: Color(0xFFF2F2F2),
                        child: Center(
                          child: Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(product.brand, style: AppTextStyle.smallGrey),
          Text(product.name, style: AppTextStyle.smallBlack),
          Text(
            '\$${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
            style: AppTextStyle.smallGreen,
          ),
        ],
      ),
    );
  }
}
