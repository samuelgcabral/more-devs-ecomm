import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/orders/models/order.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class OrderService {
  OrderService(this._dio);

  final Dio _dio;

  Future<Order> createOrder({String? notes}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/orders',
        data: {'notes': ?notes},
        options: ApiClient.authenticated,
      );

      return Order.fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiClient.exception(
        e,
        fallback: 'Não foi possível finalizar o pedido',
      );
    }
  }
}
