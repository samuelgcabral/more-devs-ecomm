class User {
  final String? id;
  final String nome;
  final String email;
  final DateTime? createdAt;

  User({this.id, required this.nome, required this.email, this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      nome: json['name'] as String,
      email: json['email'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nome,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
