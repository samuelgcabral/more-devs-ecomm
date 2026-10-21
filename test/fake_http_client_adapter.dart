import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

import 'memory_token_storage.dart';

class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.statusCode, this.body);

  int statusCode;
  Map<String, dynamic> body;
  final List<RequestOptions> requests = [];

  RequestOptions? get lastRequest => requests.isEmpty ? null : requests.last;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

Map<String, dynamic> authResponseJson({
  String name = 'Vitor',
  String email = 'vitor@email.com',
}) {
  return {
    'user': {
      'id': '9b2f6c1e-7a4d-4e8b-b1c3-2d5e6f7a8b90',
      'name': name,
      'email': email,
      'createdAt': '2026-10-13T14:30:00Z',
    },
    'tokens': {
      'accessToken': 'jwt-token',
      'tokenType': 'Bearer',
      'expiresIn': 604800,
    },
  };
}

Map<String, dynamic> productJson({
  String id = '19dd8360-f174-4262-a6cf-e2f3cda8b5c5',
  String name = 'Abacaxi pérola',
  double price = 11.5,
}) {
  return {
    'id': id,
    'name': name,
    'brand': 'Sítio do Vale',
    'imageUrl': 'https://i.postimg.cc/BQMWr9B8/Image.png',
    'price': price,
    'categoryId': 'f7616dbe-9cbb-4dde-93b6-0a8c2eda5cfa',
    'category': 'Frutas',
    'description': 'Abacaxi pérola suculento.',
  };
}

Map<String, dynamic> cartJson(List<(Map<String, dynamic>, int)> items) {
  final cartItems = [
    for (final (product, quantity) in items)
      {
        'product': product,
        'quantity': quantity,
        'subtotal': (product['price'] as double) * quantity,
      },
  ];
  return {
    'items': cartItems,
    'itemCount': cartItems.length,
    'total': cartItems.fold<double>(
      0,
      (total, item) => total + (item['subtotal'] as double),
    ),
    'updatedAt': '2026-10-13T14:30:00Z',
  };
}

Map<String, dynamic> unauthorizedJson() {
  return {
    'code': 'UNAUTHORIZED',
    'message': 'Sessão expirada, faça login novamente',
  };
}

// ApiClient real (mesmo interceptor de token e 401) respondendo pelo adapter falso.
ApiClient fakeApiClient(
  FakeHttpClientAdapter adapter, {
  SessionService? session,
  void Function()? onSessionExpired,
}) {
  return ApiClient(
    session ?? SessionService(storage: MemoryTokenStorage()),
    onSessionExpired: onSessionExpired,
    httpClientAdapter: adapter,
  );
}
