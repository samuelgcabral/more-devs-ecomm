import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/signup/services/signup_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';

import 'fake_http_client_adapter.dart';

void main() {
  SignupService buildService(FakeHttpClientAdapter adapter) {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
      ..httpClientAdapter = adapter;
    return SignupService(dio);
  }

  Future<void> register(SignupService service) {
    return service.register(
      nome: ' Vitor ',
      email: 'VITOR@EMAIL.COM',
      senha: 'Senha@123',
      confirmarSenha: 'Senha@123',
      aceitouTermos: true,
    );
  }

  test('register posts the payload and deserializes the response', () async {
    final adapter = FakeHttpClientAdapter(201, {
      'user': {
        'id': '9b2f6c1e-7a4d-4e8b-b1c3-2d5e6f7a8b90',
        'name': 'Vitor',
        'email': 'vitor@email.com',
        'createdAt': '2026-10-13T14:30:00Z',
      },
      'tokens': {
        'accessToken': 'jwt-token',
        'tokenType': 'Bearer',
        'expiresIn': 604800,
      },
    });

    final response = await buildService(adapter).register(
      nome: ' Vitor ',
      email: 'VITOR@EMAIL.COM',
      senha: 'Senha@123',
      confirmarSenha: 'Senha@123',
      aceitouTermos: true,
    );

    expect(adapter.lastRequest?.method, 'POST');
    expect(adapter.lastRequest?.path, '/auth/register');
    expect(adapter.lastRequest?.data, {
      'name': 'Vitor',
      'email': 'vitor@email.com',
      'password': 'Senha@123',
      'confirmPassword': 'Senha@123',
      'acceptedTerms': true,
    });
    expect(response.user.id, '9b2f6c1e-7a4d-4e8b-b1c3-2d5e6f7a8b90');
    expect(response.user.nome, 'Vitor');
    expect(response.user.email, 'vitor@email.com');
    expect(response.user.createdAt, DateTime.utc(2026, 10, 13, 14, 30));
    expect(response.tokens.accessToken, 'jwt-token');
    expect(response.tokens.tokenType, 'Bearer');
    expect(response.tokens.expiresIn, 604800);
  });

  test('an already registered email throws the API message', () async {
    final adapter = FakeHttpClientAdapter(409, {
      'code': 'EMAIL_ALREADY_EXISTS',
      'message': 'Este e-mail já está cadastrado',
    });

    expect(
      () => register(buildService(adapter)),
      throwsA(
        isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Este e-mail já está cadastrado',
        ),
      ),
    );
  });

  test('a validation error throws the first field message', () async {
    final adapter = FakeHttpClientAdapter(422, {
      'code': 'VALIDATION_ERROR',
      'message': 'Dados inválidos',
      'details': [
        {'field': 'email', 'message': 'E-mail inválido'},
      ],
    });

    expect(
      () => register(buildService(adapter)),
      throwsA(
        isA<AuthException>().having(
          (e) => e.message,
          'message',
          'E-mail inválido',
        ),
      ),
    );
  });
}
