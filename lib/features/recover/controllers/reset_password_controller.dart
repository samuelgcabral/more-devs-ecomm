import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/recover/services/recover_service.dart';
import 'package:more_devs_do_zero/shared/password_requirements.dart';

class ResetPasswordController with PasswordRequirements {
  ResetPasswordController(this._recoverService, {required this.resetToken});

  final RecoverService _recoverService;
  final String resetToken;

  @override
  TextEditingController senhaController = TextEditingController();
  @override
  TextEditingController confirmarSenhaController = TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword() {
    return _recoverService.resetPassword(
      resetToken: resetToken,
      senha: senhaController.text,
      confirmarSenha: confirmarSenhaController.text,
    );
  }

  void dispose() {
    senhaController.dispose();
    confirmarSenhaController.dispose();
  }
}
