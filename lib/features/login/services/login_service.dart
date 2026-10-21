import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class LoginService {
  LoginService(this._api);

  final ApiClient _api;

  Future<AuthResponse> login({
    required String email,
    required String senha,
  }) async {
    final data = await _api.post(
      '/auth/login',
      data: {'email': email.trim().toLowerCase(), 'password': senha},
      fallbackMessage: 'Não foi possível fazer login. Tente novamente',
    );

    return AuthResponse.fromJson(data as Map<String, dynamic>);
  }
}
