import 'package:more_devs_do_zero/shared/exceptions/api_exception.dart';

enum SignupExceptionType {
  emailAlreadyExists('email_already_exists'),
  validationError('validation_error'),
  network('network_error'),
  unknown('unknown');

  const SignupExceptionType(this.value);

  // Valor enviado ao analytics como error_type.
  final String value;

  static SignupExceptionType fromApiException(ApiException e) {
    if (e.isNetworkError) return network;
    if (e.code == 'EMAIL_ALREADY_EXISTS' || e.statusCode == 409) {
      return emailAlreadyExists;
    }
    if (e.code == 'VALIDATION_ERROR' ||
        e.statusCode == 400 ||
        e.statusCode == 422) {
      return validationError;
    }
    return unknown;
  }
}

// Continua sendo um ApiException (mesma mensagem para o usuário), mas carrega
// o tipo do erro até a página para o tracking.
class SignupException extends ApiException {
  SignupException(this.type, super.message, {super.statusCode, super.code});

  factory SignupException.fromApiException(ApiException e) {
    return SignupException(
      SignupExceptionType.fromApiException(e),
      e.message,
      statusCode: e.statusCode,
      code: e.code,
    );
  }

  final SignupExceptionType type;
}
