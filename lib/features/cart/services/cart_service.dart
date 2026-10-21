import 'package:more_devs_do_zero/features/cart/models/cart.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

// Todas as rotas do carrinho são protegidas e respondem com o carrinho
// atualizado.
class CartService {
  CartService(this._api);

  final ApiClient _api;

  Future<Cart> getCart() async {
    final data = await _api.get(
      '/cart',
      authenticated: true,
      fallbackMessage: 'Não foi possível carregar o carrinho',
    );

    return Cart.fromJson(data as Map<String, dynamic>);
  }

  Future<Cart> addItem(String productId, {int quantity = 1}) async {
    final data = await _api.post(
      '/cart/items',
      data: {'productId': productId, 'quantity': quantity},
      authenticated: true,
      fallbackMessage: 'Não foi possível adicionar o produto ao carrinho',
    );

    return Cart.fromJson(data as Map<String, dynamic>);
  }

  Future<Cart> updateQuantity(String productId, int quantity) async {
    final data = await _api.patch(
      '/cart/items/$productId',
      data: {'quantity': quantity},
      authenticated: true,
      fallbackMessage: 'Não foi possível alterar a quantidade',
    );

    return Cart.fromJson(data as Map<String, dynamic>);
  }

  Future<Cart> removeItem(String productId) async {
    final data = await _api.delete(
      '/cart/items/$productId',
      authenticated: true,
      fallbackMessage: 'Não foi possível remover o produto do carrinho',
    );

    return Cart.fromJson(data as Map<String, dynamic>);
  }
}
