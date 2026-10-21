import 'package:more_devs_do_zero/features/recover/services/recover_service.dart';

class RecoverController {
  RecoverController(this._recoverService);

  final RecoverService _recoverService;

  String email = '';
  bool isActiveButton = false;
  bool isLoading = false;

  void setEmail(String emailParam) {
    email = emailParam;
    changeActiveButton();
  }

  void changeActiveButton() {
    isActiveButton = email.trim().isNotEmpty;
  }

  Future<String> sendCode() => _recoverService.sendCode(email);
}
