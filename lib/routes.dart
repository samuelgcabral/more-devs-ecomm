import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/features/cart/pages/cart_page.dart';
import 'package:more_devs_do_zero/features/cart/pages/checkout_page.dart';
import 'package:more_devs_do_zero/features/home/models/category_model.dart';
import 'package:more_devs_do_zero/features/home/pages/home_page.dart';
import 'package:more_devs_do_zero/features/home/pages/products_by_category_page.dart';
import 'package:more_devs_do_zero/features/login/pages/login_page.dart';
import 'package:more_devs_do_zero/features/recover/pages/recover_code_page.dart';
import 'package:more_devs_do_zero/features/recover/pages/recover_page.dart';
import 'package:more_devs_do_zero/features/recover/pages/reset_password_page.dart';
import 'package:more_devs_do_zero/features/signup/pages/signup_page.dart';
import 'package:more_devs_do_zero/features/splash/pages/splash_page.dart';

class AppRoutes {
  AppRoutes(this._session);

  final SessionService _session;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final Map<String, WidgetBuilder> _publicRoutes = {
    SplashPage.route: (context) => const SplashPage(),
    LoginPage.route: (context) => const LoginPage(),
    SignupPage.route: (context) => const SignupPage(),
    RecoverPage.route: (context) => const RecoverPage(),
    RecoverCodePage.route: (context) {
      final email = ModalRoute.of(context)!.settings.arguments as String;
      return RecoverCodePage(email: email);
    },
    ResetPasswordPage.route: (context) {
      final resetToken = ModalRoute.of(context)!.settings.arguments as String;
      return ResetPasswordPage(resetToken: resetToken);
    },
  };

  // Telas que dependem do usuário logado (carrinho, pedidos, "Olá {nome}").
  static final Map<String, WidgetBuilder> _protectedRoutes = {
    HomePage.route: (context) => const HomePage(),
    CartPage.route: (context) => const CartPage(),
    CheckoutPage.route: (context) => const CheckoutPage(),
    ProductsByCategoryPage.route: (context) {
      final category = ModalRoute.of(context)!.settings.arguments as Category;
      return ProductsByCategoryPage(category: category);
    },
  };

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final publicBuilder = _publicRoutes[settings.name];
    if (publicBuilder != null) {
      return MaterialPageRoute(builder: publicBuilder, settings: settings);
    }

    final protectedBuilder = _protectedRoutes[settings.name];
    if (protectedBuilder == null) return null;

    if (!_session.isAuthenticated) {
      return MaterialPageRoute(
        builder: _publicRoutes[LoginPage.route]!,
        settings: const RouteSettings(name: LoginPage.route),
      );
    }
    return MaterialPageRoute(builder: protectedBuilder, settings: settings);
  }
}
