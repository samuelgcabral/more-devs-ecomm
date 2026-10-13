import 'package:dio/dio.dart';
import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';

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
      throw AuthException(_errorMessage(e));
    }
  }

  String _errorMessage(DioException e) {
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
    return 'Não foi possível concluir o cadastro. Tente novamente';
  }
}
