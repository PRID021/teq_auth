import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teq_auth/src/auth_bloc/auth_state.dart';
import 'package:teq_auth/src/services/local_auth/index.dart';
import 'package:teq_auth/src/services/token/token_service.dart';
import 'package:teq_flutter_core/teq_flutter_core.dart';
import '../model/index.dart';
import '../services/auth/api_auth_service.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/auth_type.dart';

import 'auth_event.dart';

class AuthBloc extends BaseBloc<AuthState> {
  AuthBloc(
      {initState = const InitAuthState(),
      required this.authServices,
      required this.tokenService,
      required this.googleSignIn,
      required this.localAuth})
      : super(initState) {
    on<AuthWithUsernameAndPasswordApiEvent>(_handelAuthWithEmailAndPasswordApi);
    on<BiometricAuthEvent>(_handelAuthWithBiometric);
    on<AuthWithGoogleEvent>(_handelAuthWithGoogle);
    on<ResetAuthStateEvent>(_handelRestAuthState);
  }

  final AuthService authServices;
  final TokenService tokenService;
  final GoogleSignIn googleSignIn;
  final LocalAuth localAuth;

  Future<void> _handelAuthWithEmailAndPasswordApi<R extends TokenInfo>(
      AuthWithUsernameAndPasswordApiEvent event,
      Emitter<AuthState> emit) async {
    emit(const OnProgressAuthState());
    try {
      final user = await authServices.signIn<R>(
          signInType: AuthType.userAndPass,
          authParam: Credential(email: event.email, password: event.password));
      _checkFirstAuthAndSaveToken(user, emit);
    } catch (e) {
      emit(AuthFailState(e.toString()));
    }
  }

  FutureOr<void> _handelAuthWithBiometric(
      BiometricAuthEvent event, Emitter<AuthState> emit) async {
    emit(const OnProgressAuthState());
    try {
      final isSuccess = await localAuth.authenticate(event.authReason);
      if (!isSuccess) {
        emit(unknownError);
        return;
      }
      emit(const BioAuthSuccessState());
      return;
    } catch (e) {
      emit(AuthFailState(e.toString()));
      return;
    }
  }

  FutureOr<void> _handelAuthWithGoogle<R extends TokenInfo>(
      AuthWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(const OnProgressAuthState());
    await googleSignIn.signOut();
    final userGoogle = await googleSignIn.signIn();
    final googleToken = await userGoogle?.authentication;
    if (googleToken != null && googleToken?.idToken != null) {
      final user = await authServices.signIn<R>(
          signInType: AuthType.google,
          authParam: GoogleToken(googleToken: googleToken.idToken!));
      _checkFirstAuthAndSaveToken(user, emit);
      return;
    }
    emit(unknownError);
  }

  bool get isFirstAuthenticate =>
      tokenService.getAccessToken() != null ? false : true;

  AuthFailState get unknownError => const AuthFailState("Unknown Reason");

  void _checkFirstAuthAndSaveToken<R extends TokenInfo>(
      R? user, Emitter<AuthState> emit) {
    if (user == null) {
      emit(unknownError);
      return;
    }
    if (isFirstAuthenticate) {
      emit(FirstAuthSuccessState<R>(user));
    } else {
      emit(AuthSuccessState<R>(user));
    }
    tokenService.setToken(
        accessToken: user.accessToken, refreshToken: user.refreshToken);
  }

  FutureOr<void> _handelRestAuthState(
      ResetAuthStateEvent event, Emitter<AuthState> emit) {
    emit(const InitAuthState());
  }
}
