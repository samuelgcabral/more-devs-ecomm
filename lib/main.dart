import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/features/auth/services/user_service.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/cart/services/cart_service.dart';
import 'package:more_devs_do_zero/features/home/controllers/home_controller.dart';
import 'package:more_devs_do_zero/features/home/controllers/products_by_category_controller.dart';
import 'package:more_devs_do_zero/features/home/services/catalog_service.dart';
import 'package:more_devs_do_zero/features/login/controllers/login_controller.dart';
import 'package:more_devs_do_zero/features/login/pages/login_page.dart';
import 'package:more_devs_do_zero/features/login/services/login_service.dart';
import 'package:more_devs_do_zero/features/orders/services/order_service.dart';
import 'package:more_devs_do_zero/features/recover/services/recover_service.dart';
import 'package:more_devs_do_zero/features/signup/services/signup_service.dart';
import 'package:more_devs_do_zero/features/splash/pages/splash_page.dart';
import 'package:more_devs_do_zero/routes.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';
import 'package:more_devs_do_zero/shared/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Chamado pelo ApiClient quando uma rota protegida responde 401
  // (token expirado ou invalidado pela troca de senha).
  static void _onSessionExpired() {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    context.read<CartController>().reset();
    context.read<LoginController>().logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.route,
      (route) => false,
    );
    showErrorSnackBar(context, 'Sessão expirada, faça login novamente');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => SessionService()),
        Provider(
          create: (context) => ApiClient(
            context.read<SessionService>(),
            onSessionExpired: _onSessionExpired,
          ),
        ),
        Provider(create: (context) => SignupService(context.read<ApiClient>())),
        Provider(create: (context) => LoginService(context.read<ApiClient>())),
        Provider(
          create: (context) => RecoverService(context.read<ApiClient>()),
        ),
        Provider(create: (context) => UserService(context.read<ApiClient>())),
        Provider(
          create: (context) => CatalogService(context.read<ApiClient>()),
        ),
        Provider(create: (context) => CartService(context.read<ApiClient>())),
        Provider(create: (context) => OrderService(context.read<ApiClient>())),
        ChangeNotifierProvider(
          create: (context) {
            return LoginController(
              context.read<LoginService>(),
              context.read<SessionService>(),
            )..loadRememberedEmail();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return HomeController(context.read<CatalogService>());
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProductsByCategoryController(context.read<CatalogService>());
          },
        ),
        ChangeNotifierProvider(
          create: (context) => CartController(
            context.read<CartService>(),
            context.read<OrderService>(),
          ),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppRoutes.navigatorKey,
          onGenerateRoute: AppRoutes(
            context.read<SessionService>(),
          ).onGenerateRoute,
          initialRoute: SplashPage.route,
        );
      },
    );
  }
}
