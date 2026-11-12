class ApiException implements Exception {
  final String message;

  // Status HTTP da resposta; null quando nem chegou resposta (sem conexão,
  // timeout).
  final int? statusCode;

  // Código de erro devolvido pela API, ex.: EMAIL_ALREADY_EXISTS.
  final String? code;

  ApiException(this.message, {this.statusCode, this.code});

  bool get isNetworkError => statusCode == null;
}
