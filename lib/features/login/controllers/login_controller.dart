import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/auth/services/session_service.dart';
import 'package:more_devs_do_zero/features/login/model/user.dart';
import 'package:more_devs_do_zero/features/login/services/login_service.dart';
import 'package:more_devs_do_zero/features/login/services/remember_me_service.dart';

class LoginController extends ChangeNotifier {
  LoginController(
    this._loginService,
    this._sessionService, {
    RememberMeStorage? rememberMeStorage,
  }) : _rememberMeStorage = rememberMeStorage ?? RememberMeService();

  final LoginService _loginService;
  final SessionService _sessionService;
  final RememberMeStorage _rememberMeStorage;
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final int _caracterMinimoSenha = 6;
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isActiveCheckBox = false;

  User? user;

  bool isLoading = false;

  bool get isEmailValid => _emailRegex.hasMatch(emailController.text.trim());
  bool get isSenhaValid =>
      senhaController.text.trim().length >= _caracterMinimoSenha;

  Future<void> loadRememberedEmail() async {
    final rememberedEmail = await _rememberMeStorage.readEmail();

    if (rememberedEmail == null || rememberedEmail.isEmpty) return;

    emailController.text = rememberedEmail;
    isActiveCheckBox = true;
    notifyListeners();
  }

  Future<void> changeActiveCheckBox() async {
    isActiveCheckBox = !isActiveCheckBox;
    notifyListeners();

    if (!isActiveCheckBox) {
      await _rememberMeStorage.clearEmail();
    }
  }

  void changeIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> logout() async {
    user = null;
    senhaController.clear();
    isLoading = false;

    if (!isActiveCheckBox) {
      emailController.clear();
    }

    notifyListeners();
    await _sessionService.clear();
  }

  Future<void> handleLogin() async {
    if (!key.currentState!.validate()) {
      throw ErrorDescription('validacao_incorreta');
    }

    changeIsLoading(true);
    try {
      await login();
      if (!isActiveCheckBox) emailController.clear();
      senhaController.clear();
    } finally {
      changeIsLoading(false);
    }
  }

  Future<void> login() async {
    final response = await _loginService.login(
      email: emailController.text,
      senha: senhaController.text,
    );
    await _sessionService.start(response);
    user = response.user;
    await _updateRememberedEmail();
  }

  Future<void> _updateRememberedEmail() async {
    if (isActiveCheckBox) {
      await _rememberMeStorage.saveEmail(
        emailController.text.trim().toLowerCase(),
      );
    } else {
      await _rememberMeStorage.clearEmail();
    }
  }

  String? validateEmail(String? value) {
    if (_emailRegex.hasMatch(emailController.text)) {
      return null;
    }
    return 'E-mail inválido';
  }

  String? validateSenha(String? value) {
    if (senhaController.text.length >= _caracterMinimoSenha) {
      return null;
    }
    return 'Senha inválida';
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
