import 'package:flutter/widgets.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/home/services/catalog_service.dart';
import 'package:more_devs_do_zero/shared/analytics/app_analytics.dart';

enum ProductsByCategoryViewState { loading, success, error }

class ProductsByCategoryController extends ChangeNotifier {
  ProductsByCategoryController(this._catalogService, this._analytics);

  final CatalogService _catalogService;
  final AppAnalytics _analytics;

  List<Product> _categoryProducts = [];

  String _query = '';

  Category? _category;

  // null = todas as marcas
  String? _selectedBrand;

  String? get selectedBrand => _selectedBrand;

  ProductsByCategoryViewState state = ProductsByCategoryViewState.loading;

  // Marcas presentes na categoria, em ordem alfabética e sem repetição.
  List<String> get brands {
    final brands = {for (final product in _categoryProducts) product.brand};
    return brands.toList()..sort();
  }

  //produtos da categoria já filtrados pela marca e pelo texto da busca
  List<Product> get products {
    final query = _query.toLowerCase();
    final brand = _selectedBrand;

    return _categoryProducts.where((product) {
      if (brand != null && product.brand != brand) return false;
      if (query.isEmpty) return true;
      return product.name.toLowerCase().contains(query) ||
          product.brand.toLowerCase().contains(query);
    }).toList();
  }

  void changeState(ProductsByCategoryViewState newState) {
    state = newState;
    notifyListeners();
  }

  void search(String query) {
    _query = query;
    notifyListeners();
  }

  // Valor enviado em item_brand quando o usuário volta para "Todas as Marcas".
  static const String allBrandsValue = 'all';

  void setSelectedBrand(String? brand) {
    if (brand == _selectedBrand) return;
    _selectedBrand = brand;
    notifyListeners();

    final category = _category;
    if (category != null) {
      _analytics.logFilterBrand(
        brand: brand ?? allBrandsValue,
        listName: category.name,
        resultsCount: products.length,
      );
    }
  }

  Future<void> getProductsByCategory(Category category) async {
    _category = category;
    _query = '';
    _selectedBrand = null;
    changeState(ProductsByCategoryViewState.loading);
    try {
      _categoryProducts = await _catalogService.getProducts(
        categoryId: category.id,
      );

      changeState(ProductsByCategoryViewState.success);
      _analytics.logViewItemList(category.name);
    } catch (e) {
      //caso der erro na requisição ou na deserialização, emite o erro para a tela tratar
      changeState(ProductsByCategoryViewState.error);
      _analytics.logLoadError('category_products');
    }
  }
}
