import 'package:teq_flutter_core/teq_flutter_core.dart';

import '../model/index.dart';

abstract class AuthState extends BaseState {
  const AuthState();
}

class InitAuthState extends AuthState {
  const InitAuthState();
}

class UnAuthState extends AuthState {}

class OnProgressAuthState extends AuthState {
  const OnProgressAuthState();
}

class AuthFailState extends AuthState {
  final String failReason;

  const AuthFailState(this.failReason);
}

class AuthSuccessState<R extends TokenInfo> extends AuthState {
  final R user;

  const AuthSuccessState(this.user);
}

class FirstAuthSuccessState<R extends TokenInfo> extends AuthState {
  final R user;

  const FirstAuthSuccessState(this.user);
}

class BioAuthSuccessState extends AuthState {
  const BioAuthSuccessState();
}
