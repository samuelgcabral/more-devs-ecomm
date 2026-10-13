import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl =
      'https://api-production-c0289.up.railway.app/api/v1';

  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
      ),
    );
  }
}
