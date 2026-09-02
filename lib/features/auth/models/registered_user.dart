class RegisteredUser {
  const RegisteredUser({
    required this.nome,
    required this.email,
    required this.passwordHash,
    required this.passwordSalt,
  });

  final String nome;
  final String email;
  final String passwordHash;
  final String passwordSalt;

  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    return RegisteredUser(
      nome: json['nome'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      passwordSalt: json['passwordSalt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'passwordHash': passwordHash,
      'passwordSalt': passwordSalt,
    };
  }
}
