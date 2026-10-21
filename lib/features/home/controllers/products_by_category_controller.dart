import 'package:flutter/widgets.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/home/services/catalog_service.dart';

enum ProductsByCategoryViewState { loading, success, error }

class ProductsByCategoryController extends ChangeNotifier {
  ProductsByCategoryController(this._catalogService);

  final CatalogService _catalogService;

  List<Product> _categoryProducts = [];

  String _query = '';

  ProductsByCategoryViewState state = ProductsByCategoryViewState.loading;

  //produtos da categoria já filtrados pelo texto da busca
  List<Product> get products {
    if (_query.isEmpty) return _categoryProducts;

    final query = _query.toLowerCase();
    return _categoryProducts.where((product) {
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

  Future<void> getProductsByCategory(Category category) async {
    _query = '';
    changeState(ProductsByCategoryViewState.loading);
    try {
      _categoryProducts = await _catalogService.getProducts(
        categoryId: category.id,
      );

      changeState(ProductsByCategoryViewState.success);
    } catch (e) {
      //caso der erro na requisição ou na deserialização, emite o erro para a tela tratar
      changeState(ProductsByCategoryViewState.error);
    }
  }
}
