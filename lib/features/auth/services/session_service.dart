import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/features/auth/services/user_service.dart';
import 'package:more_devs_do_zero/features/login/model/user.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenStorage {
  Future<String?> readToken();
  Future<void> saveToken(String token);
  Future<void> clearToken();
}

class SharedPreferencesTokenStorage implements TokenStorage {
  static const String _tokenKey = 'access_token';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<String?> readToken() {
    return _preferences.getString(_tokenKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _preferences.setString(_tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await _preferences.remove(_tokenKey);
  }
}

class SessionService {
  SessionService({TokenStorage? storage})
    : _storage = storage ?? SharedPreferencesTokenStorage();

  final TokenStorage _storage;

  User? user;
  String? accessToken;

  bool get isAuthenticated => user != null;

  Future<void> load() async {
    accessToken ??= await _storage.readToken();
  }

  // Restaura a sessão ao abrir o app a partir do token salvo.
  Future<bool> restore(UserService userService) async {
    await load();
    if (accessToken == null) return false;

    try {
      user = await userService.me();
      return true;
    } on ApiException {
      return false;
    }
  }

  Future<void> start(AuthResponse response) async {
    user = response.user;
    accessToken = response.tokens.accessToken;
    await _storage.saveToken(response.tokens.accessToken);
  }

  Future<void> clear() async {
    user = null;
    accessToken = null;
    await _storage.clearToken();
  }
}
