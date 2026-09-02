import 'package:flutter/foundation.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/shared/mocks.dart';

enum ProductsByCategoryViewState { loading, success, error }

class ProductsByCategoryController extends ChangeNotifier {
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

  Future<void> getProductsByCategory(String category) async {
    changeState(ProductsByCategoryViewState.loading);
    //simula o delay da API
    await Future.delayed(Duration(seconds: 3));
    try {
      _categoryProducts = productsJson
          .map((item) => Product.fromJson(item))
          .where((product) => product.category == category)
          .toList();

      changeState(ProductsByCategoryViewState.success);
    } catch (e) {
      //caso der erro na deserialização, emite o erro para a tela tratar
      changeState(ProductsByCategoryViewState.error);
    }
  }
}
