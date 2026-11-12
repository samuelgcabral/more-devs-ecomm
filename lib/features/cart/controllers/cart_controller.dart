import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/models/cart.dart';
import 'package:more_devs_do_zero/features/cart/models/cart_item.dart';
import 'package:more_devs_do_zero/features/cart/services/cart_service.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/orders/models/order.dart';
import 'package:more_devs_do_zero/features/orders/services/order_service.dart';
import 'package:more_devs_do_zero/shared/analytics/app_analytics.dart';

// O carrinho fica no servidor: cada ação chama a API e substitui o estado
// local pelo carrinho que ela devolve.
class CartController extends ChangeNotifier {
  CartController(this._cartService, this._orderService, this._analytics);

  final CartService _cartService;
  final OrderService _orderService;
  final AppAnalytics _analytics;

  Cart _cart = const Cart.empty();

  // Enquanto uma requisição está em andamento, os botões ficam desabilitados
  // para evitar que dois cliques enviem a mesma quantidade.
  bool isUpdating = false;

  List<CartItem> get items => List.unmodifiable(_cart.items);

  double get totalPrice => _cart.total;

  int get itemCount =>
      _cart.items.fold(0, (total, item) => total + item.quantity);

  CartItem? findByProduct(Product product) {
    for (final item in _cart.items) {
      if (item.product == product) return item;
    }
    return null;
  }

  Future<void> loadCart() => _update(_cartService.getCart);

  // Os eventos só saem depois que a API confirma a mudança.
  Future<void> addToCart(Product product) async {
    await _update(() => _cartService.addItem(product.id));
    _analytics.logAddToCart(product);
  }

  // Aumentar a quantidade (+) não gera evento. Diminuir (-) gera
  // remove_from_cart com a quantidade retirada.
  Future<void> updateQuantity(Product product, int quantity) async {
    final previousQuantity = findByProduct(product)?.quantity ?? 0;
    await _update(() => _cartService.updateQuantity(product.id, quantity));

    final removed = previousQuantity - quantity;
    if (removed > 0) _analytics.logRemoveFromCart(product, removed);
  }

  Future<void> removeFromCart(Product product) async {
    final removed = findByProduct(product)?.quantity ?? 0;
    await _update(() => _cartService.removeItem(product.id));
    if (removed > 0) _analytics.logRemoveFromCart(product, removed);
  }

  Future<Order> checkout() async {
    isUpdating = true;
    notifyListeners();
    try {
      final order = await _orderService.createOrder();
      // a API esvazia o carrinho ao criar o pedido
      _cart = const Cart.empty();
      return order;
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }

  // Limpa apenas o estado local (logout / sessão expirada).
  void reset() {
    _cart = const Cart.empty();
    isUpdating = false;
    notifyListeners();
  }

  Future<void> _update(Future<Cart> Function() request) async {
    isUpdating = true;
    notifyListeners();
    try {
      _cart = await request();
    } finally {
      isUpdating = false;
      notifyListeners();
    }
  }
}
