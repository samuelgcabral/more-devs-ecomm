import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';

class ApiClient {
  static const String baseUrl =
      'https://api-production-c0289.up.railway.app/api/v1';

  static const String _requiresAuthKey = 'requiresAuth';

  // Endpoints marcados como protegidos na documentação da API
  // (/users/me, /cart, /orders) devem ser chamados com essas options.
  static Options get authenticated => Options(extra: {_requiresAuthKey: true});

  static Dio create(
    SessionService session, {
    void Function()? onSessionExpired,
  }) {
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
          if (_requiresAuth(options) && token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              _requiresAuth(error.requestOptions)) {
            final wasAuthenticated = session.isAuthenticated;
            await session.clear();
            if (wasAuthenticated) onSessionExpired?.call();
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  static bool _requiresAuth(RequestOptions options) {
    return options.extra[_requiresAuthKey] == true;
  }

  static ApiException exception(DioException e, {required String fallback}) {
    return ApiException(errorMessage(e, fallback: fallback));
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
