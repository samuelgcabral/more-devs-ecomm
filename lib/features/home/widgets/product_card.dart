import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/shared/analytics/app_analytics.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/currency_format.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.listName,
    required this.onTap,
  });

  final Product product;

  // Lista de onde o card veio: AppAnalytics.homeListName ou o nome da
  // categoria. Vai no item_list_name do view_item.
  final String listName;
  final VoidCallback onTap;

  void _handleTap(BuildContext context) {
    context.read<AppAnalytics>().logViewItem(product, listName);
    onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
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
          SizedBox(height: 2),
          Text(product.price.toBRL(), style: AppTextStyle.smallBlack),
        ],
      ),
    );
  }
}
