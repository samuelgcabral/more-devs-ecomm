import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class CatalogService {
  CatalogService(this._api);

  final ApiClient _api;

  Future<List<Category>> getCategories() async {
    final data = await _api.get(
      '/categories',
      fallbackMessage: 'Não foi possível carregar as categorias',
    );

    return (data['data'] as List<dynamic>)
        .map((item) => Category.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Product>> getProducts({String? categoryId}) async {
    final data = await _api.get(
      '/products',
      queryParameters: {'categoryId': ?categoryId},
      fallbackMessage: 'Não foi possível carregar os produtos',
    );

    return (data['data'] as List<dynamic>)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
