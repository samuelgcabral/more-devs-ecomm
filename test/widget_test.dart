import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/features/login/controllers/login_controller.dart';
import 'package:more_devs_do_zero/features/login/services/login_service.dart';
import 'package:more_devs_do_zero/features/login/services/remember_me_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

import 'fake_http_client_adapter.dart';
import 'memory_token_storage.dart';

class MemoryRememberMeStorage implements RememberMeStorage {
  String? email;

  @override
  Future<void> clearEmail() async => email = null;

  @override
  Future<String?> readEmail() async => email;

  @override
  Future<void> saveEmail(String email) async => this.email = email;
}

void main() {
  late LoginController controller;
  late FakeHttpClientAdapter adapter;
  late SessionService sessionService;
  late MemoryTokenStorage tokenStorage;
  late MemoryRememberMeStorage rememberMeStorage;

  setUp(() {
    rememberMeStorage = MemoryRememberMeStorage();
    tokenStorage = MemoryTokenStorage();
    sessionService = SessionService(storage: tokenStorage);
    adapter = FakeHttpClientAdapter(
      200,
      authResponseJson(name: 'Maria', email: 'maria@example.com'),
    );
    final dio = ApiClient.create(sessionService)..httpClientAdapter = adapter;
    controller = LoginController(
      LoginService(dio),
      sessionService,
      rememberMeStorage: rememberMeStorage,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  test(
    'a successful login posts the credentials and stores the user',
    () async {
      controller.emailController.text = ' MARIA@EXAMPLE.COM ';
      controller.senhaController.text = 'Senha@123';
      await controller.login();

      expect(adapter.lastRequest?.path, '/auth/login');
      expect(adapter.lastRequest?.data, {
        'email': 'maria@example.com',
        'password': 'Senha@123',
      });
      expect(controller.user?.nome, 'Maria');
      expect(controller.user?.email, 'maria@example.com');
    },
  );

  test(
    'a successful login starts the session and persists the token',
    () async {
      controller.emailController.text = 'maria@example.com';
      controller.senhaController.text = 'Senha@123';
      await controller.login();

      expect(sessionService.user?.nome, 'Maria');
      expect(sessionService.accessToken, 'jwt-token');
      expect(tokenStorage.token, 'jwt-token');
    },
  );

  test('incorrect credentials are rejected with the API message', () async {
    adapter
      ..statusCode = 401
      ..body = {
        'code': 'INVALID_CREDENTIALS',
        'message': 'E-mail ou senha incorretos',
      };
    controller.emailController.text = 'maria@example.com';
    controller.senhaController.text = 'senha-errada';

    await expectLater(
      controller.login,
      throwsA(
        isA<AuthException>().having(
          (e) => e.message,
          'message',
          'E-mail ou senha incorretos',
        ),
      ),
    );
    expect(controller.user, isNull);
    expect(tokenStorage.token, isNull);
  });

  test('logout clears the session and the persisted token', () async {
    controller.emailController.text = 'maria@example.com';
    controller.senhaController.text = 'Senha@123';
    await controller.login();

    await controller.logout();

    expect(controller.user, isNull);
    expect(sessionService.user, isNull);
    expect(sessionService.accessToken, isNull);
    expect(tokenStorage.token, isNull);
  });

  test('remember me saves the email after a successful login', () async {
    controller.emailController.text = 'MARIA@EXAMPLE.COM';
    controller.senhaController.text = 'Senha@123';
    await controller.changeActiveCheckBox();

    await controller.login();

    expect(rememberMeStorage.email, 'maria@example.com');
  });

  test('a remembered email is loaded into the login field', () async {
    rememberMeStorage.email = 'vitor6890@gmail.com';

    await controller.loadRememberedEmail();

    expect(controller.emailController.text, 'vitor6890@gmail.com');
    expect(controller.isActiveCheckBox, isTrue);
  });

  test('unchecking remember me removes the saved email', () async {
    rememberMeStorage.email = 'vitor6890@gmail.com';
    await controller.loadRememberedEmail();

    await controller.changeActiveCheckBox();

    expect(rememberMeStorage.email, isNull);
    expect(controller.isActiveCheckBox, isFalse);
  });
}
