import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/pages/login_page.dart';
import 'package:more_devs_do_zero/pages/signup_page.dart';

class AppRoutes {
  static final Map<String, WidgetBuilder> routes = {
    LoginPage.route: (context) => const LoginPage(),
    SignupPage.route: (context) => const SignupPage(),
  };
}
