import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/auth/services/auth_service.dart';
import 'package:more_devs_do_zero/features/login/controllers/login_controller.dart';
import 'package:more_devs_do_zero/features/login/services/remember_me_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';

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
  late AuthService authService;
  late MemoryRememberMeStorage rememberMeStorage;

  setUp(() {
    rememberMeStorage = MemoryRememberMeStorage();
    authService = AuthService(simulatedDelay: Duration.zero);
    controller = LoginController(
      authService,
      rememberMeStorage: rememberMeStorage,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  test('a newly registered user can log in', () async {
    await authService.registerUser(
      nome: 'Maria',
      email: 'MARIA@EXAMPLE.COM',
      senha: 'Senha@123',
    );

    controller.emailController.text = 'maria@example.com';
    controller.senhaController.text = 'Senha@123';
    await controller.login();

    expect(controller.user?.nome, 'Maria');
    expect(controller.user?.email, 'maria@example.com');
  });

  test('registering the same email twice is rejected', () async {
    await authService.registerUser(
      nome: 'Maria',
      email: 'maria@example.com',
      senha: 'Senha@123',
    );

    expect(
      () => authService.registerUser(
        nome: 'Outra Maria',
        email: 'maria@example.com',
        senha: 'Outra@123',
      ),
      throwsA(isA<AuthException>()),
    );
  });

  test('an incorrect password is rejected', () async {
    await authService.registerUser(
      nome: 'Maria',
      email: 'maria@example.com',
      senha: 'Senha@123',
    );
    controller.emailController.text = 'maria@example.com';
    controller.senhaController.text = 'senha-errada';

    expect(controller.login, throwsA(isA<AuthException>()));
  });

  test('remember me saves the email after a successful login', () async {
    controller.emailController.text = 'VITOR6890@GMAIL.COM';
    controller.senhaController.text = '123456';
    await controller.changeActiveCheckBox();

    await controller.login();

    expect(rememberMeStorage.email, 'vitor6890@gmail.com');
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
