import 'package:more_devs_do_zero/features/login/model/user.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

class UserService {
  UserService(this._api);

  final ApiClient _api;

  Future<User> me() async {
    final data = await _api.get(
      '/users/me',
      authenticated: true,
      fallbackMessage: 'Não foi possível carregar seus dados',
    );

    return User.fromJson(data as Map<String, dynamic>);
  }
}
