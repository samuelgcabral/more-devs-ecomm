import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/auth/services/auth_service.dart';
import 'package:more_devs_do_zero/features/login/model/user.dart';
import 'package:more_devs_do_zero/features/login/services/remember_me_service.dart';

class LoginController extends ChangeNotifier {
  LoginController(this._authService, {RememberMeStorage? rememberMeStorage})
    : _rememberMeStorage = rememberMeStorage ?? RememberMeService();

  final AuthService _authService;
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
    user = await _authService.login(
      email: emailController.text,
      senha: senhaController.text,
    );
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
