import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';

class ApiClient {
  static const String baseUrl =
      'https://api-production-c0289.up.railway.app/api/v1';

  static Dio create(SessionService session) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = session.accessToken;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    return dio;
  }

  static String errorMessage(DioException e, {required String fallback}) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final details = data['details'];
      if (details is List && details.isNotEmpty) {
        final detail = details.first;
        if (detail is Map && detail['message'] is String) {
          return detail['message'] as String;
        }
      }
      if (data['message'] is String) return data['message'] as String;
    }

    if (e.response == null) {
      return 'Não foi possível conectar ao servidor. Verifique sua conexão';
    }
    return fallback;
  }
}
