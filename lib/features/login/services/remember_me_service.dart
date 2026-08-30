import 'package:shared_preferences/shared_preferences.dart';

abstract class RememberMeStorage {
  Future<String?> readEmail();
  Future<void> saveEmail(String email);
  Future<void> clearEmail();
}

class RememberMeService implements RememberMeStorage {
  static const String _emailKey = 'remembered_login_email';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  @override
  Future<String?> readEmail() {
    return _preferences.getString(_emailKey);
  }

  @override
  Future<void> saveEmail(String email) async {
    await _preferences.setString(_emailKey, email);
  }

  @override
  Future<void> clearEmail() async {
    await _preferences.remove(_emailKey);
  }
}
