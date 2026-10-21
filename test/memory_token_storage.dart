import 'package:more_devs_do_zero/features/auth/services/session_service.dart';

class MemoryTokenStorage implements TokenStorage {
  String? token;

  @override
  Future<void> clearToken() async => token = null;

  @override
  Future<String?> readToken() async => token;

  @override
  Future<void> saveToken(String token) async => this.token = token;
}
