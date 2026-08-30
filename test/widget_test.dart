import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/login/controllers/login_controller.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';

void main() {
  late LoginController controller;

  setUp(() {
    controller = LoginController(simulatedDelay: Duration.zero);
  });

  tearDown(() {
    controller.dispose();
  });

  test('a newly registered user can log in', () async {
    await controller.registerUser(
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
    await controller.registerUser(
      nome: 'Maria',
      email: 'maria@example.com',
      senha: 'Senha@123',
    );

    expect(
      () => controller.registerUser(
        nome: 'Outra Maria',
        email: 'maria@example.com',
        senha: 'Outra@123',
      ),
      throwsA(isA<AuthException>()),
    );
  });

  test('an incorrect password is rejected', () async {
    await controller.registerUser(
      nome: 'Maria',
      email: 'maria@example.com',
      senha: 'Senha@123',
    );
    controller.emailController.text = 'maria@example.com';
    controller.senhaController.text = 'senha-errada';

    expect(controller.login, throwsA(isA<AuthException>()));
  });
}
