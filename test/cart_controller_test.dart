import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/cart/services/cart_service.dart';
import 'package:more_devs_do_zero/features/home/models/product_model.dart';
import 'package:more_devs_do_zero/features/orders/services/order_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';

import 'fake_http_client_adapter.dart';

void main() {
  late FakeHttpClientAdapter adapter;
  late CartController controller;
  final abacaxi = productJson();
  final acerola = productJson(
    id: 'c5ace0f9-8aa9-4230-8e8e-5f02861aa2a8',
    name: 'Acerola',
    price: 7.99,
  );

  setUp(() {
    adapter = FakeHttpClientAdapter(200, cartJson([]));
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
      ..httpClientAdapter = adapter;
    controller = CartController(CartService(dio), OrderService(dio));
  });

  tearDown(() {
    controller.dispose();
  });

  test('adding a product posts it and uses the returned cart', () async {
    adapter.body = cartJson([(abacaxi, 1), (acerola, 2)]);

    await controller.addToCart(Product.fromJson(abacaxi));

    expect(adapter.lastRequest?.method, 'POST');
    expect(adapter.lastRequest?.path, '/cart/items');
    expect(adapter.lastRequest?.data, {
      'productId': abacaxi['id'],
      'quantity': 1,
    });
    expect(controller.items, hasLength(2));
    expect(controller.itemCount, 3);
    expect(controller.totalPrice, closeTo(27.48, 0.001));
    expect(controller.findByProduct(Product.fromJson(acerola))?.quantity, 2);
  });

  test('changing the quantity sends the final quantity', () async {
    adapter.body = cartJson([(abacaxi, 3)]);

    await controller.updateQuantity(Product.fromJson(abacaxi), 3);

    expect(adapter.lastRequest?.method, 'PATCH');
    expect(adapter.lastRequest?.path, '/cart/items/${abacaxi['id']}');
    expect(adapter.lastRequest?.data, {'quantity': 3});
    expect(controller.itemCount, 3);
  });

  test('removing a product deletes it from the cart', () async {
    adapter.body = cartJson([]);

    await controller.removeFromCart(Product.fromJson(abacaxi));

    expect(adapter.lastRequest?.method, 'DELETE');
    expect(adapter.lastRequest?.path, '/cart/items/${abacaxi['id']}');
    expect(controller.items, isEmpty);
  });

  test('a failed request keeps the cart and re-enables the buttons', () async {
    adapter.body = cartJson([(abacaxi, 1)]);
    await controller.loadCart();
    adapter
      ..statusCode = 404
      ..body = {
        'code': 'CART_ITEM_NOT_FOUND',
        'message': 'Item não encontrado no carrinho',
      };

    await expectLater(
      controller.updateQuantity(Product.fromJson(acerola), 2),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Item não encontrado no carrinho',
        ),
      ),
    );
    expect(controller.itemCount, 1);
    expect(controller.isUpdating, isFalse);
  });

  test('checkout creates the order and empties the local cart', () async {
    adapter.body = cartJson([(abacaxi, 2)]);
    await controller.loadCart();
    adapter
      ..statusCode = 201
      ..body = {
        'id': '7c9e6679-7425-40de-944b-e07fc1f90ae7',
        'status': 'PENDING',
        'items': [
          {
            'productId': abacaxi['id'],
            'name': 'Abacaxi pérola',
            'brand': 'Sítio do Vale',
            'imageUrl': 'https://i.postimg.cc/BQMWr9B8/Image.png',
            'unitPrice': 11.5,
            'quantity': 2,
            'subtotal': 23.0,
          },
        ],
        'itemCount': 1,
        'total': 23.0,
        'notes': null,
        'createdAt': '2026-10-13T14:30:00Z',
      };

    final order = await controller.checkout();

    expect(adapter.lastRequest?.method, 'POST');
    expect(adapter.lastRequest?.path, '/orders');
    expect(order.status, 'PENDING');
    expect(order.total, 23.0);
    expect(order.items.single.quantity, 2);
    expect(controller.items, isEmpty);
  });

  test('checkout with an empty cart surfaces the API message', () async {
    adapter
      ..statusCode = 400
      ..body = {'code': 'CART_EMPTY', 'message': 'Seu carrinho está vazio'};

    expect(
      controller.checkout(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Seu carrinho está vazio',
        ),
      ),
    );
  });

  test('reset clears the cart locally without calling the API', () async {
    adapter.body = cartJson([(abacaxi, 1)]);
    await controller.loadCart();
    adapter.requests.clear();

    controller.reset();

    expect(controller.items, isEmpty);
    expect(adapter.requests, isEmpty);
  });
}
