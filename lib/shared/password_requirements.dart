import 'package:flutter/material.dart';

// Regras de senha compartilhadas entre Cadastro e Redefinir senha
// (as mesmas que a API valida).
mixin PasswordRequirements {
  TextEditingController get senhaController;
  TextEditingController get confirmarSenhaController;

  List<Map<String, bool>> getPasswordRequirements() {
    return [
      {'Mínimo de 6 caracteres': minSeisCaracteres},
      {'No mínimo um caracter especial': possuiCaractereEspecial},
      {'No mínimo uma letra maiúscula': possuiLetraMaiuscula},
      {'No mínimo uma letra minúscula': possuiLetraMinuscula},
      {'Senhas coincidem': senhasCoincidentes},
    ];
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
}
