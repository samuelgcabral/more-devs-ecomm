import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:more_devs_do_zero/features/auth/models/registered_user.dart';
import 'package:more_devs_do_zero/features/auth/services/auth_storage.dart';
import 'package:more_devs_do_zero/features/login/model/user.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';

class AuthService {
  AuthService({
    this.simulatedDelay = const Duration(seconds: 2),
    AuthStorage? storage,
  }) : _storage = storage ?? SharedPreferencesAuthStorage() {
    const mockEmail = 'vitor6890@gmail.com';
    const mockSalt = 'mock-user-salt';
    _registeredUsers[mockEmail] = RegisteredUser(
      nome: 'Vitor',
      email: mockEmail,
      passwordHash: _hashPassword('123456', mockSalt),
      passwordSalt: mockSalt,
    );
  }

  final Duration simulatedDelay;
  final AuthStorage _storage;
  final Random _random = Random.secure();
  Future<void>? _loadFuture;

  final Map<String, RegisteredUser> _registeredUsers = {};

  Future<User> login({required String email, required String senha}) async {
    await Future.delayed(simulatedDelay);
    await _ensureUsersLoaded();
    final normalizedEmail = email.trim().toLowerCase();
    final registeredUser = _registeredUsers[normalizedEmail];

    if (registeredUser == null ||
        _hashPassword(senha, registeredUser.passwordSalt) !=
            registeredUser.passwordHash) {
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
    await _ensureUsersLoaded();
    final normalizedEmail = email.trim().toLowerCase();

    if (_registeredUsers.containsKey(normalizedEmail)) {
      throw AuthException('Este e-mail já está cadastrado');
    }

    final salt = _generateSalt();
    _registeredUsers[normalizedEmail] = RegisteredUser(
      nome: nome.trim(),
      email: normalizedEmail,
      passwordHash: _hashPassword(senha, salt),
      passwordSalt: salt,
    );
    await _storage.saveUsers(_registeredUsers.values.toList());
  }

  Future<void> _ensureUsersLoaded() {
    return _loadFuture ??= _loadUsers();
  }

  Future<void> _loadUsers() async {
    final storedUsers = await _storage.readUsers();
    for (final user in storedUsers) {
      _registeredUsers[user.email] = user;
    }
  }

  String _generateSalt() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64Encode(bytes);
  }

  String _hashPassword(String password, String salt) {
    return sha256.convert(utf8.encode('$salt$password')).toString();
  }
}
