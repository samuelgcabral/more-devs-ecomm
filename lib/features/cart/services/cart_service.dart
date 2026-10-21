import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/cart/models/cart.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class CartService {
  CartService(this._dio);

  final Dio _dio;

  Future<Cart> getCart() {
    return _request(
      () => _dio.get('/cart', options: ApiClient.authenticated),
      fallback: 'Não foi possível carregar o carrinho',
    );
  }

  Future<Cart> addItem(String productId, {int quantity = 1}) {
    return _request(
      () => _dio.post(
        '/cart/items',
        data: {'productId': productId, 'quantity': quantity},
        options: ApiClient.authenticated,
      ),
      fallback: 'Não foi possível adicionar o produto ao carrinho',
    );
  }

  Future<Cart> updateQuantity(String productId, int quantity) {
    return _request(
      () => _dio.patch(
        '/cart/items/$productId',
        data: {'quantity': quantity},
        options: ApiClient.authenticated,
      ),
      fallback: 'Não foi possível alterar a quantidade',
    );
  }

  Future<Cart> removeItem(String productId) {
    return _request(
      () => _dio.delete(
        '/cart/items/$productId',
        options: ApiClient.authenticated,
      ),
      fallback: 'Não foi possível remover o produto do carrinho',
    );
  }

  // Todas as rotas do carrinho respondem com o carrinho atualizado.
  Future<Cart> _request(
    Future<Response<dynamic>> Function() request, {
    required String fallback,
  }) async {
    try {
      final response = await request();
      return Cart.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiClient.exception(e, fallback: fallback);
    }
  }
}
