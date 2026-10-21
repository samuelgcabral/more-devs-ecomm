import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/auth/models/auth_response.dart';
import 'package:more_devs_do_zero/features/signup/services/signup_service.dart';
import 'package:more_devs_do_zero/shared/password_requirements.dart';

class SignupController with PasswordRequirements {
  SignupController(this._signupService);

  final SignupService _signupService;
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  TextEditingController emailController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  @override
  TextEditingController senhaController = TextEditingController();
  @override
  TextEditingController confirmarSenhaController = TextEditingController();

  bool checkBoxError = false;

  bool isActiveCheckBox = false;
  bool isLoading = false;

  bool validateCheckBox() {
    checkBoxError = !isActiveCheckBox;
    return isActiveCheckBox;
  }

  void changeActiveCheckBox() {
    isActiveCheckBox = !isActiveCheckBox;
    if (isActiveCheckBox) {
      checkBoxError = false;
    }
  }

  String? validateEmail(String? value) {
    if (_emailRegex.hasMatch(emailController.text.trim())) {
      return null;
    }
    return 'E-mail inválido';
  }

  String? validateNome(String? value) {
    if (nomeController.text.trim().isNotEmpty) {
      return null;
    }
    return 'Nome inválido';
  }

  void dispose() {
    emailController.dispose();
    nomeController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
  }

  Future<AuthResponse> signUp() {
    return _signupService.register(
      nome: nomeController.text,
      email: emailController.text,
      senha: senhaController.text,
      confirmarSenha: confirmarSenhaController.text,
      aceitouTermos: isActiveCheckBox,
    );
  }
}
