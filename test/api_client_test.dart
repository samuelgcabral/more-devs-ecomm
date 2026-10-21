import 'package:flutter_test/flutter_test.dart';
import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/features/auth/services/user_service.dart';
import 'package:more_devs_do_zero/features/cart/services/cart_service.dart';
import 'package:more_devs_do_zero/features/home/services/catalog_service.dart';
import 'package:more_devs_do_zero/features/login/services/login_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';

import 'fake_http_client_adapter.dart';
import 'memory_token_storage.dart';

void main() {
  late FakeHttpClientAdapter adapter;
  late MemoryTokenStorage tokenStorage;
  late SessionService session;
  late ApiClient api;
  late int sessionExpiredCalls;

  setUp(() async {
    adapter = FakeHttpClientAdapter(200, {'data': []});
    tokenStorage = MemoryTokenStorage();
    session = SessionService(storage: tokenStorage);
    sessionExpiredCalls = 0;
    api = fakeApiClient(
      adapter,
      session: session,
      onSessionExpired: () => sessionExpiredCalls++,
    );
    await session.start(AuthResponse.fromJson(authResponseJson()));
  });

  test('protected endpoints carry the bearer token', () async {
    adapter.body = cartJson([]);

    await CartService(api).getCart();

    expect(adapter.lastRequest?.headers['Authorization'], 'Bearer jwt-token');
  });

  test('public endpoints are called without the token', () async {
    await CatalogService(api).getCategories();

    expect(adapter.lastRequest?.headers['Authorization'], isNull);
  });

  test('a 401 on a protected endpoint ends the session', () async {
    adapter
      ..statusCode = 401
      ..body = unauthorizedJson();

    await expectLater(
      CartService(api).getCart(),
      throwsA(
        isA<ApiException>().having(
          (e) => e.message,
          'message',
          'Sessão expirada, faça login novamente',
        ),
      ),
    );
    expect(session.isAuthenticated, isFalse);
    expect(session.accessToken, isNull);
    expect(tokenStorage.token, isNull);
    expect(sessionExpiredCalls, 1);
  });

  test('a 401 from the login endpoint keeps the current session', () async {
    adapter
      ..statusCode = 401
      ..body = {
        'code': 'INVALID_CREDENTIALS',
        'message': 'E-mail ou senha incorretos',
      };

    await expectLater(
      LoginService(api).login(email: 'a@b.com', senha: 'errada'),
      throwsA(isA<ApiException>()),
    );
    expect(session.isAuthenticated, isTrue);
    expect(sessionExpiredCalls, 0);
  });

  group('session restore', () {
    setUp(() {
      session = SessionService(storage: tokenStorage);
      api = fakeApiClient(
        adapter,
        session: session,
        onSessionExpired: () => sessionExpiredCalls++,
      );
      adapter.requests.clear();
    });

    test('restores the user from a saved token', () async {
      adapter.body = authResponseJson()['user'] as Map<String, dynamic>;

      final restored = await session.restore(UserService(api));

      expect(restored, isTrue);
      expect(adapter.lastRequest?.path, '/users/me');
      expect(adapter.lastRequest?.headers['Authorization'], 'Bearer jwt-token');
      expect(session.user?.nome, 'Vitor');
    });

    test('does not call the API without a saved token', () async {
      tokenStorage.token = null;

      final restored = await session.restore(UserService(api));

      expect(restored, isFalse);
      expect(adapter.requests, isEmpty);
    });

    test('an expired token is discarded', () async {
      adapter
        ..statusCode = 401
        ..body = unauthorizedJson();

      final restored = await session.restore(UserService(api));

      expect(restored, isFalse);
      expect(tokenStorage.token, isNull);
      // não estava logado no app, então não há sessão para "expirar"
      expect(sessionExpiredCalls, 0);
    });
  });
}
