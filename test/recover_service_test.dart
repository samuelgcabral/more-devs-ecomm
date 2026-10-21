import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/recover/services/recover_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';

import 'fake_http_client_adapter.dart';

void main() {
  late FakeHttpClientAdapter adapter;
  late RecoverService service;

  setUp(() {
    adapter = FakeHttpClientAdapter(202, {
      'message': 'Código enviado com sucesso',
    });
    final api = fakeApiClient(adapter);
    service = RecoverService(api);
  });

  test('sending the code returns the API message', () async {
    final message = await service.sendCode(' VITOR@EMAIL.COM ');

    expect(adapter.lastRequest?.path, '/auth/password/forgot');
    expect(adapter.lastRequest?.data, {'email': 'vitor@email.com'});
    expect(message, 'Código enviado com sucesso');
  });

  test('a valid code returns the reset token', () async {
    adapter
      ..statusCode = 200
      ..body = {
        'resetToken': 'c1a7e0b2-4d5f-4f3a-b8e9-6a2d1c0f9e87',
        'expiresIn': 900,
      };

    final resetToken = await service.verifyCode(
      email: 'vitor@email.com',
      code: '482913',
    );

    expect(adapter.lastRequest?.path, '/auth/password/verify-code');
    expect(adapter.lastRequest?.data, {
      'email': 'vitor@email.com',
      'code': '482913',
    });
    expect(resetToken, 'c1a7e0b2-4d5f-4f3a-b8e9-6a2d1c0f9e87');
  });

  test('an invalid code throws the API message', () async {
    adapter
      ..statusCode = 400
      ..body = {
        'code': 'INVALID_RESET_CODE',
        'message': 'Código inválido ou expirado',
      };

    expect(
      service.verifyCode(email: 'vitor@email.com', code: '000000'),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Código inválido ou expirado',
        ),
      ),
    );
  });

  test('resetting the password sends the token and both passwords', () async {
    adapter
      ..statusCode = 204
      ..body = {};

    await service.resetPassword(
      resetToken: 'reset-token',
      senha: 'NovaSenha@1',
      confirmarSenha: 'NovaSenha@1',
    );

    expect(adapter.lastRequest?.path, '/auth/password/reset');
    expect(adapter.lastRequest?.data, {
      'resetToken': 'reset-token',
      'password': 'NovaSenha@1',
      'confirmPassword': 'NovaSenha@1',
    });
  });
}
