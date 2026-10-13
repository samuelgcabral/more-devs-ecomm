import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.statusCode, this.body);

  int statusCode;
  Map<String, dynamic> body;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
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
