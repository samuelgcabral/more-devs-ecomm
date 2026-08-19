class SignupController {
  bool isActiveCheckBox = false;
  String email = '';
  String nome = '';
  String senha = '';
  String confirmarSenha = '';
  bool isActiveButton = false;
  bool isLoading = false;

  void setEmail(String emailParam) {
    email = emailParam;
    changeActiveButton();
  }

  void setNome(String nomeParam) {
    nome = nomeParam;
    changeActiveButton();
  }

  void setSenha(String senhaParam) {
    senha = senhaParam;
    changeActiveButton();
  }

  void setConfirmarSenha(String confirmarSenhaParam) {
    confirmarSenha = confirmarSenhaParam;
    changeActiveButton();
  }

  List<Map<String, bool>> getPasswordRequirements() {
    return [
      {'Mínimo de 6 caracteres': minSeisCaracteres},
      {'No mínimo um caracter especial': possuiCaractereEspecial},
      {'No mínimo uma letra maiúscula': possuiLetraMaiuscula},
      {'No mínimo uma letra minúscula': possuiLetraMinuscula},
      {'Senhas coincidem': senhasCoincidentes},
    ];
  }

  void changeActiveButton() {
    isActiveButton =
        email.trim().isNotEmpty &&
        nome.trim().isNotEmpty &&
        senha.trim().isNotEmpty &&
        confirmarSenha.trim().isNotEmpty &&
        isActiveCheckBox &&
        minSeisCaracteres &&
        possuiCaractereEspecial &&
        possuiLetraMaiuscula &&
        possuiLetraMinuscula &&
        senhasCoincidentes;
  }

  void changeActiveCheckBox() {
    isActiveCheckBox = !isActiveCheckBox;
    changeActiveButton();
  }

  Future<void> signUp() async {
    await Future.delayed(Duration(seconds: 2));
  }

  bool get possuiLetraMaiuscula => senha.contains(RegExp(r'[A-Z]'));
  bool get possuiLetraMinuscula => senha.contains(RegExp(r'[a-z]'));
  bool get senhasCoincidentes => senha == confirmarSenha && senha.isNotEmpty;
  bool get minSeisCaracteres => senha.length >= 6;
  bool get possuiCaractereEspecial =>
      senha.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
}
