import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class SignupService {
  SignupService(this._api);

  final ApiClient _api;

  Future<AuthResponse> register({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
    required bool aceitouTermos,
  }) async {
    final data = await _api.post(
      '/auth/register',
      data: {
        'name': nome.trim(),
        'email': email.trim().toLowerCase(),
        'password': senha,
        'confirmPassword': confirmarSenha,
        'acceptedTerms': aceitouTermos,
      },
      fallbackMessage: 'Não foi possível concluir o cadastro. Tente novamente',
    );

    return AuthResponse.fromJson(data as Map<String, dynamic>);
  }
}
