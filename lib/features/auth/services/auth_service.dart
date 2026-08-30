import 'package:more_devs_do_zero/features/login/model/user.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';

class AuthService {
  AuthService({this.simulatedDelay = const Duration(seconds: 2)});

  final Duration simulatedDelay;

  final Map<String, ({String nome, String senha})> _registeredUsers = {
    'vitor6890@gmail.com': (nome: 'Vitor', senha: '123456'),
  };

  Future<User> login({required String email, required String senha}) async {
    await Future.delayed(simulatedDelay);
    final normalizedEmail = email.trim().toLowerCase();
    final registeredUser = _registeredUsers[normalizedEmail];

    if (registeredUser == null || senha != registeredUser.senha) {
      throw AuthException('E-mail ou senha incorretos');
    }

    return User(nome: registeredUser.nome, email: normalizedEmail);
  }

  Future<void> registerUser({
    required String nome,
    required String email,
    required String senha,
  }) async {
    await Future.delayed(simulatedDelay);
    final normalizedEmail = email.trim().toLowerCase();

    if (_registeredUsers.containsKey(normalizedEmail)) {
      throw AuthException('Este e-mail já está cadastrado');
    }

    _registeredUsers[normalizedEmail] = (nome: nome.trim(), senha: senha);
  }
}
