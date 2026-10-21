import 'package:more_devs_do_zero/features/orders/models/order.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class OrderService {
  OrderService(this._api);

  final ApiClient _api;

  Future<Order> createOrder({String? notes}) async {
    final data = await _api.post(
      '/orders',
      data: {'notes': ?notes},
      authenticated: true,
      fallbackMessage: 'Não foi possível finalizar o pedido',
    );

    return Order.fromJson(data as Map<String, dynamic>);
  }
}
