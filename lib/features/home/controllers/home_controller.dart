import 'package:flutter/widgets.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/home/services/catalog_service.dart';

enum CategoriesViewState { loading, success, error }

enum ProductsViewState { loading, success, error }

class HomeController extends ChangeNotifier {
  HomeController(this._catalogService);

  final CatalogService _catalogService;

  List<Category> categories = [];

  CategoriesViewState categoriesState = CategoriesViewState.loading;

  List<Product> products = [];

  ProductsViewState productsState = ProductsViewState.loading;

  void changeCategoriesState(CategoriesViewState state) {
    categoriesState = state;
    notifyListeners();
  }

  void changeProductsState(ProductsViewState state) {
    productsState = state;
    notifyListeners();
  }

  Future<void> getCategories() async {
    changeCategoriesState(CategoriesViewState.loading);
    try {
      categories = await _catalogService.getCategories();

      changeCategoriesState(CategoriesViewState.success);
    } catch (e) {
      //caso der erro na requisição ou na deserialização, emite o erro para a tela tratar
      changeCategoriesState(CategoriesViewState.error);
    }
  }

  Future<void> getProducts() async {
    changeProductsState(ProductsViewState.loading);
    try {
      products = await _catalogService.getProducts();

      changeProductsState(ProductsViewState.success);
    } catch (e) {
      //caso der erro na requisição ou na deserialização, emite o erro para a tela tratar
      changeProductsState(ProductsViewState.error);
    }
  }
}
