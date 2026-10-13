import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class LoginService {
  LoginService(this._dio);

  final Dio _dio;

  Future<AuthResponse> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email.trim().toLowerCase(), 'password': senha},
      );

      return AuthResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw AuthException(
        ApiClient.errorMessage(
          e,
          fallback: 'Não foi possível fazer login. Tente novamente',
        ),
      );
    }
  }
}
