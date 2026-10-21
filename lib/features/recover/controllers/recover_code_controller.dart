import 'package:flutter/material.dart';
import 'package:more_devs_do_zero/features/recover/services/recover_service.dart';

class RecoverCodeController {
  RecoverCodeController(this._recoverService, {required this.email});

  final RecoverService _recoverService;
  final String email;
  final RegExp _codeRegex = RegExp(r'^\d{6}$');

  TextEditingController codeController = TextEditingController();

  bool isLoading = false;
  bool isResending = false;

  String? validateCode(String? value) {
    if (_codeRegex.hasMatch(codeController.text.trim())) {
      return null;
    }
    return 'O código deve ter 6 dígitos';
  }

  Future<String> verifyCode() {
    return _recoverService.verifyCode(email: email, code: codeController.text);
  }

  Future<String> resendCode() => _recoverService.sendCode(email);

  void dispose() {
    codeController.dispose();
  }
}
