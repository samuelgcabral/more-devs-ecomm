import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/auth/services/auth_service.dart';

class SignupController {
  SignupController(this._authService);

  final AuthService _authService;
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  TextEditingController emailController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();

  bool checkBoxError = false;

  bool isActiveCheckBox = false;
  bool isLoading = false;

  List<Map<String, bool>> getPasswordRequirements() {
    return [
      {'Mínimo de 6 caracteres': minSeisCaracteres},
      {'No mínimo um caracter especial': possuiCaractereEspecial},
      {'No mínimo uma letra maiúscula': possuiLetraMaiuscula},
      {'No mínimo uma letra minúscula': possuiLetraMinuscula},
      {'Senhas coincidem': senhasCoincidentes},
    ];
  }

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

  String? validateSenha(String? value) {
    if (minSeisCaracteres &&
        possuiCaractereEspecial &&
        possuiLetraMaiuscula &&
        possuiLetraMinuscula) {
      return null;
    }
    return 'Senha não atende aos requisitos';
  }

  String? validateConfirmarSenha(String? value) {
    if (senhasCoincidentes) {
      return null;
    }
    return 'As senhas não coincidem';
  }

  bool get possuiLetraMaiuscula =>
      senhaController.text.contains(RegExp(r'[A-Z]'));
  bool get possuiLetraMinuscula =>
      senhaController.text.contains(RegExp(r'[a-z]'));
  bool get senhasCoincidentes =>
      senhaController.text == confirmarSenhaController.text &&
      senhaController.text.isNotEmpty;
  bool get minSeisCaracteres => senhaController.text.length >= 6;
  bool get possuiCaractereEspecial =>
      senhaController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  void dispose() {
    emailController.dispose();
    nomeController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
  }

  Future<void> signUp() {
    return _authService.registerUser(
      nome: nomeController.text,
      email: emailController.text,
      senha: senhaController.text,
    );
  }
}
