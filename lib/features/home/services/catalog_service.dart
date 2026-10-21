import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class CatalogService {
  CatalogService(this._dio);

  final Dio _dio;

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/categories');

      return (response.data!['data'] as List<dynamic>)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiClient.exception(
        e,
        fallback: 'Não foi possível carregar as categorias',
      );
    }
  }

  Future<List<Product>> getProducts({String? categoryId}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products',
        queryParameters: {'categoryId': ?categoryId},
      );

      return (response.data!['data'] as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiClient.exception(
        e,
        fallback: 'Não foi possível carregar os produtos',
      );
    }
  }
}
