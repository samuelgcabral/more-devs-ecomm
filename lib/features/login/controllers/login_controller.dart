class LoginController {
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final int _caracterMinimoSenha = 6;

  bool isActiveCheckBox = false;
  String email = '';
  String senha = '';
  bool isActiveButton = false;

  bool get isEmailValid => _emailRegex.hasMatch(email.trim());
  bool get isSenhaValid => senha.trim().length >= _caracterMinimoSenha;

  String? get emailError {
    if (email.trim().isEmpty || isEmailValid) return null;
    return 'E-mail inválido';
  }

  String? get senhaError {
    if (senha.isEmpty || isSenhaValid) {
      return null;
    }
    return 'E-mail inválido';
  }

  void setEmail(String emailParam) {
    email = emailParam;
    changeActiveButton();
  }

  void setSenha(String senhaParam) {
    senha = senhaParam;
    changeActiveButton();
  }

  void changeActiveButton() {
    isActiveButton = isEmailValid && isSenhaValid;
  }

  void changeActiveCheckBox() {
    isActiveCheckBox = !isActiveCheckBox;
  }
}
