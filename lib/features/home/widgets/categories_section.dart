import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/home/controllers/home_controller.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/widgets/category_card.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
    required this.state,
    required this.categories,
  });

  final CategoriesViewState state;
  final List<Category> categories;

  static final List<Category> _fakeCategories = List.filled(
    4,
    Category(name: 'Categoria', imageUrl: ''),
  );

  @override
  Widget build(BuildContext context) {
    if (state == CategoriesViewState.error) {
      return const Text('Problema ao resgatar categorias');
    }

    final isLoading = state == CategoriesViewState.loading;
    final items = isLoading ? _fakeCategories : categories;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Categorias',
                style: AppTextStyle.subTitle.copyWith(fontSize: 18),
              ),
              const SizedBox(width: 8),
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chevron_right, size: 20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < items.length; index++) ...[
                  if (index > 0) const SizedBox(width: 24),
                  CategoryCard(category: items[index]),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
