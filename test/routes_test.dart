import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/features/cart/pages/cart_page.dart';
import 'package:more_devs_do_zero/features/cart/pages/checkout_page.dart';
import 'package:more_devs_do_zero/features/home/pages/home_page.dart';
import 'package:more_devs_do_zero/features/login/pages/login_page.dart';
import 'package:more_devs_do_zero/features/recover/pages/recover_page.dart';
import 'package:more_devs_do_zero/routes.dart';

import 'fake_http_client_adapter.dart';
import 'memory_token_storage.dart';

void main() {
  late SessionService session;
  late AppRoutes routes;

  setUp(() {
    session = SessionService(storage: MemoryTokenStorage());
    routes = AppRoutes(session);
  });

  String? routeNameFor(String name) {
    return routes.onGenerateRoute(RouteSettings(name: name))?.settings.name;
  }

  test('protected pages redirect to login without a session', () {
    for (final route in [HomePage.route, CartPage.route, CheckoutPage.route]) {
      expect(routeNameFor(route), LoginPage.route, reason: route);
    }
  });

  test('protected pages open with a session', () async {
    await session.start(AuthResponse.fromJson(authResponseJson()));

    expect(routeNameFor(HomePage.route), HomePage.route);
    expect(routeNameFor(CartPage.route), CartPage.route);
  });

  test('public pages open without a session', () {
    expect(routeNameFor(LoginPage.route), LoginPage.route);
    expect(routeNameFor(RecoverPage.route), RecoverPage.route);
  });

  test('unknown routes are not generated', () {
    expect(routes.onGenerateRoute(const RouteSettings(name: '/nope')), isNull);
  });
}
