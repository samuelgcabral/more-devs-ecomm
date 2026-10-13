import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class SignupService {
  SignupService(this._dio);

  final Dio _dio;

  Future<AuthResponse> register({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
    required bool aceitouTermos,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': nome.trim(),
          'email': email.trim().toLowerCase(),
          'password': senha,
          'confirmPassword': confirmarSenha,
          'acceptedTerms': aceitouTermos,
        },
      );

      return AuthResponse.fromJson(response.data!);
    } on DioException catch (e) {
      throw AuthException(
        ApiClient.errorMessage(
          e,
          fallback: 'Não foi possível concluir o cadastro. Tente novamente',
        ),
      );
    }
  }
}
