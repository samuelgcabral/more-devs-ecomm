import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';

class ApiClient {
  ApiClient(
    this._session, {
    this.onSessionExpired,
    HttpClientAdapter? httpClientAdapter,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 15),
           receiveTimeout: const Duration(seconds: 15),
           contentType: Headers.jsonContentType,
         ),
       ) {
    if (httpClientAdapter != null) _dio.httpClientAdapter = httpClientAdapter;
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _addToken, onError: _handleUnauthorized),
    );
  }

  static const String baseUrl =
      'https://api-production-c0289.up.railway.app/api/v1';

  static const String _requiresAuthKey = 'requiresAuth';

  final Dio _dio;
  final SessionService _session;

  final void Function()? onSessionExpired;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool authenticated = false,
    required String fallbackMessage,
  }) {
    return _request(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: _options(authenticated),
      ),
      fallbackMessage,
    );
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    bool authenticated = false,
    required String fallbackMessage,
  }) {
    return _request(
      () => _dio.post(path, data: data, options: _options(authenticated)),
      fallbackMessage,
    );
  }

  Future<dynamic> patch(
    String path, {
    Object? data,
    bool authenticated = false,
    required String fallbackMessage,
  }) {
    return _request(
      () => _dio.patch(path, data: data, options: _options(authenticated)),
      fallbackMessage,
    );
  }

  Future<dynamic> delete(
    String path, {
    bool authenticated = false,
    required String fallbackMessage,
  }) {
    return _request(
      () => _dio.delete(path, options: _options(authenticated)),
      fallbackMessage,
    );
  }

  Options _options(bool authenticated) {
    return Options(extra: {_requiresAuthKey: authenticated});
  }

  Future<dynamic> _request(
    Future<Response<dynamic>> Function() request,
    String fallbackMessage,
  ) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (e) {
      final data = e.response?.data;
      throw ApiException(
        _errorMessage(e, fallback: fallbackMessage),
        statusCode: e.response?.statusCode,
        code: data is Map<String, dynamic> && data['code'] is String
            ? data['code'] as String
            : null,
      );
    }
  }

  void _addToken(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _session.accessToken;
    if (_requiresAuth(options) && token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  Future<void> _handleUnauthorized(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401 &&
        _requiresAuth(error.requestOptions)) {
      final wasAuthenticated = _session.isAuthenticated;
      await _session.clear();
      if (wasAuthenticated) onSessionExpired?.call();
    }
    handler.next(error);
  }

  bool _requiresAuth(RequestOptions options) {
    return options.extra[_requiresAuthKey] == true;
  }

  String _errorMessage(DioException e, {required String fallback}) {
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
