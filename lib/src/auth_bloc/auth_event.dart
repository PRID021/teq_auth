import 'package:teq_flutter_core/teq_flutter_core.dart';

abstract class AuthEvent extends BaseEvent {
  const AuthEvent();
}

class BiometricAuthEvent extends AuthEvent {
  final String authReason;

  const BiometricAuthEvent({required this.authReason});
}

class AuthWithUsernameAndPasswordApiEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthWithUsernameAndPasswordApiEvent({
    required this.email,
    required this.password,
  });
}

class AuthWithGoogleEvent extends AuthEvent {
  const AuthWithGoogleEvent();
}

class ResetAuthStateEvent extends AuthEvent {
  const ResetAuthStateEvent();
}
