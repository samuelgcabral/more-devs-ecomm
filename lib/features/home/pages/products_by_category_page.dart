import 'dart:async';

import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/widgets/cart_icon_button.dart';
import 'package:more_devs_do_zero/features/home/controllers/products_by_category_controller.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/home/widgets/brand_filter.dart';
import 'package:more_devs_do_zero/features/home/widgets/product_card.dart';
import 'package:more_devs_do_zero/features/home/widgets/product_details_modal.dart';
import 'package:more_devs_do_zero/shared/analytics/analytics_mixin.dart';
import 'package:more_devs_do_zero/shared/app_text_style.dart';
import 'package:more_devs_do_zero/shared/widgets/app_text_field.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductsByCategoryPage extends StatefulWidget {
  const ProductsByCategoryPage({super.key, required this.category});

  static const String route = '/products-by-category';

  final Category category;

  @override
  State<ProductsByCategoryPage> createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage>
    with AnalyticsMixin {
  @override
  String get screenName => ProductsByCategoryPage.route;

  static const Duration _searchDebounce = Duration(seconds: 1);

  Timer? _searchTimer;

  static final List<Product> _fakeProducts = List.filled(
    6,
    Product(
      brand: 'Marca do produto',
      name: 'Nome do produto',
      imageUrl: '',
      price: 0,
      categoryId: '',
      category: '',
      description: '',
      id: '',
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsByCategoryController>().getProductsByCategory(
        widget.category,
      );
    });
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    super.dispose();
  }

  // A lista é filtrada a cada tecla, mas o evento search só sai depois de
  // 1 s sem digitar, para não registrar cada letra.
  void _onSearchChanged(String query) {
    final controller = context.read<ProductsByCategoryController>();
    controller.search(query);

    _searchTimer?.cancel();
    final term = query.trim();
    if (term.isEmpty) return;

    _searchTimer = Timer(_searchDebounce, () {
      if (!mounted) return;
      analytics.logSearch(
        searchTerm: term,
        listName: widget.category.name,
        resultsCount: controller.products.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.category.name, style: AppTextStyle.title),
        actions: [const CartIconButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: AppTextField(
              hintText: 'Buscar produtos',
              prefixIcon: const Icon(Icons.search),
              onChanged: _onSearchChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Consumer<ProductsByCategoryController>(
              builder: (context, controller, child) {
                return BrandFilter(
                  brands: controller.brands,
                  selectedBrand: controller.selectedBrand,
                  onChanged: controller.setSelectedBrand,
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<ProductsByCategoryController>(
              builder: (context, controller, child) {
                if (controller.state == ProductsByCategoryViewState.error) {
                  return const Center(
                    child: Text('Problema ao resgatar produtos'),
                  );
                }

                final isLoading =
                    controller.state == ProductsByCategoryViewState.loading;
                final products = isLoading
                    ? _fakeProducts
                    : controller.products;

                if (!isLoading && products.isEmpty) {
                  return const Center(child: Text('Nenhum produto encontrado'));
                }

                return Skeletonizer(
                  enabled: isLoading,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return ProductCard(
                        product: product,
                        listName: widget.category.name,
                        onTap: () {
                          ProductDetailsModal.show(context, product);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
