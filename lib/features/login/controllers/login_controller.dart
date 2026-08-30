import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/login/model/user.dart';
import 'package:more_devs_do_zero/features/login/services/remember_me_service.dart';
import 'package:more_devs_do_zero/shared/exceptions/auth_exception.dart';

class LoginController extends ChangeNotifier {
  LoginController({
    this.simulatedDelay = const Duration(seconds: 2),
    RememberMeStorage? rememberMeStorage,
  }) : _rememberMeStorage = rememberMeStorage ?? RememberMeService();

  final Duration simulatedDelay;
  final RememberMeStorage _rememberMeStorage;
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final int _caracterMinimoSenha = 6;
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isActiveCheckBox = false;

  User? user;

  bool isLoading = false;

  final Map<String, ({String nome, String senha})> _registeredUsers = {
    'vitor6890@gmail.com': (nome: 'Vitor', senha: '123456'),
  };

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
    //Simula chamada da API
    await Future.delayed(simulatedDelay);
    final email = emailController.text.trim().toLowerCase();
    final registeredUser = _registeredUsers[email];

    if (registeredUser == null ||
        senhaController.text != registeredUser.senha) {
      throw AuthException('E-mail ou senha incorretos');
    }
    user = User(nome: registeredUser.nome, email: email);
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

  Future<void> registerUser({
    required String nome,
    required String email,
    required String senha,
  }) async {
    await Future.delayed(simulatedDelay);
    final normalizedEmail = email.trim().toLowerCase();

    if (_registeredUsers.containsKey(normalizedEmail)) {
      throw AuthException('Este e-mail já está cadastrado');
    }

    _registeredUsers[normalizedEmail] = (nome: nome.trim(), senha: senha);
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
