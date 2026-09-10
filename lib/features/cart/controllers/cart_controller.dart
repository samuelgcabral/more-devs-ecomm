import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/cart/models/cart_item.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addToCart(Product product) {
    final existingItem = _items.firstWhere(
      (item) => item.product == product,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product == product);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    final existingItem = _items.firstWhere(
      (item) => item.product == product,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      existingItem.quantity = quantity;
      if (existingItem.quantity <= 0) {
        removeFromCart(product);
      }
      notifyListeners();
    }
  }

  double get totalPrice => _items.fold(
    0.0,
    (total, item) => total + (item.product.price * item.quantity),
  );
}
