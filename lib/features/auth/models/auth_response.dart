import 'package:more_devs_do_zero/features/auth/models/auth_tokens.dart';
import 'package:more_devs_do_zero/features/login/model/user.dart';

class AuthResponse {
  const AuthResponse({required this.user, required this.tokens});

  final User user;
  final AuthTokens tokens;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokens.fromJson(json['tokens'] as Map<String, dynamic>),
    );
  }
}
