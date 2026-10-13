import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/features/cart/controllers/cart_controller.dart';
import 'package:more_devs_do_zero/features/home/controllers/home_controller.dart';
import 'package:more_devs_do_zero/features/home/controllers/products_by_category_controller.dart';
import 'package:more_devs_do_zero/features/login/controllers/login_controller.dart';
import 'package:more_devs_do_zero/features/login/pages/login_page.dart';
import 'package:more_devs_do_zero/features/login/services/login_service.dart';
import 'package:more_devs_do_zero/features/signup/services/signup_service.dart';
import 'package:more_devs_do_zero/routes.dart';
import 'package:more_devs_do_zero/shared/services/api_client.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => SessionService()..load()),
        Provider(
          create: (context) => ApiClient.create(context.read<SessionService>()),
        ),
        Provider(create: (context) => SignupService(context.read<Dio>())),
        Provider(create: (context) => LoginService(context.read<Dio>())),
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
            return HomeController();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ProductsByCategoryController();
          },
        ),
        ChangeNotifierProvider(create: (context) => CartController()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: LoginPage.route,
        );
      },
    );
  }
}
