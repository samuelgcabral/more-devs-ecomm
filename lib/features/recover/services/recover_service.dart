import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class RecoverService {
  RecoverService(this._dio);

  final Dio _dio;

  // A API responde 202 mesmo se o e-mail não existir, para não expor
  // quais e-mails estão cadastrados.
  Future<String> sendCode(String email) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/password/forgot',
        data: {'email': email.trim().toLowerCase()},
      );

      return response.data!['message'] as String;
    } on DioException catch (e) {
      throw AuthException(
        ApiClient.errorMessage(e, fallback: 'Não foi possível enviar o código'),
      );
    }
  }

  // Devolve o resetToken usado para definir a nova senha.
  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/password/verify-code',
        data: {'email': email.trim().toLowerCase(), 'code': code.trim()},
      );

      return response.data!['resetToken'] as String;
    } on DioException catch (e) {
      throw AuthException(
        ApiClient.errorMessage(
          e,
          fallback: 'Não foi possível validar o código',
        ),
      );
    }
  }

  Future<void> resetPassword({
    required String resetToken,
    required String senha,
    required String confirmarSenha,
  }) async {
    try {
      await _dio.post<void>(
        '/auth/password/reset',
        data: {
          'resetToken': resetToken,
          'password': senha,
          'confirmPassword': confirmarSenha,
        },
      );
    } on DioException catch (e) {
      throw AuthException(
        ApiClient.errorMessage(
          e,
          fallback: 'Não foi possível redefinir a senha',
        ),
      );
    }
  }
}
