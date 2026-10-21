import 'package:more_devs_do_zero/shared/services/api_client.dart';

class RecoverService {
  RecoverService(this._api);

  final ApiClient _api;

  // A API responde 202 mesmo se o e-mail não existir, para não expor
  // quais e-mails estão cadastrados.
  Future<String> sendCode(String email) async {
    final data = await _api.post(
      '/auth/password/forgot',
      data: {'email': email.trim().toLowerCase()},
      fallbackMessage: 'Não foi possível enviar o código',
    );

    return data['message'] as String;
  }

  // Devolve o resetToken usado para definir a nova senha.
  Future<String> verifyCode({
    required String email,
    required String code,
  }) async {
    final data = await _api.post(
      '/auth/password/verify-code',
      data: {'email': email.trim().toLowerCase(), 'code': code.trim()},
      fallbackMessage: 'Não foi possível validar o código',
    );

    return data['resetToken'] as String;
  }

  Future<void> resetPassword({
    required String resetToken,
    required String senha,
    required String confirmarSenha,
  }) async {
    await _api.post(
      '/auth/password/reset',
      data: {
        'resetToken': resetToken,
        'password': senha,
        'confirmPassword': confirmarSenha,
      },
      fallbackMessage: 'Não foi possível redefinir a senha',
    );
  }
}
