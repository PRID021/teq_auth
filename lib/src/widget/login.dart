import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:teq_auth/src/auth_bloc/auth_bloc.dart';
import 'package:teq_flutter_core/teq_flutter_core.dart';

import '../../teq_auth.dart';

class LoginWidget extends StatefulWidget {
  final AuthService authServices;
  final TokenService tokenService;
  final GoogleSignIn googleSignIn;
  final LocalAuth localAuth;
  final Widget Function(BuildContext, AuthState) builder;

  const LoginWidget({
    super.key,
    required this.authServices,
    required this.tokenService,
    required this.googleSignIn,
    required this.localAuth,
    required this.builder,
  });

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends TeqWidgetState<AuthBloc, LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: widget.builder,
      ),
    );
  }

  @override
  AuthBloc getBloc() => AuthBloc(
        authServices: widget.authServices,
        tokenService: widget.tokenService,
        googleSignIn: widget.googleSignIn,
        localAuth: widget.localAuth,
      );
}
