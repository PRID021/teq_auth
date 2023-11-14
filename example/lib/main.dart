import 'package:example/data/api/auth_api_mock_impl.dart';
import 'package:flutter/material.dart';
import 'package:teq_auth/teq_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:teq_flutter_core/teq_flutter_core.dart';

import 'configs.dart';
import 'model/user.dart';

late final SharedPreferences ref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ref = await SharedPreferences.getInstance();
  await Configs.configNetwork();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginWidget(
        authServices: ApiAuthService(authApi: AuthApiMockImpl()),
        localAuth: LocalAuthImpl.instance,
        tokenService: TeqTokenService(
          localStorageData:
              SharedPreferencesDataStorage(sharedPreferences: ref),
        ),
        googleSignIn: GoogleSignIn(),
        builder: (context, authState) {
          return Scaffold(
            body: _buildBody(context, authState),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: ElevatedButton(
                onPressed: () => _resetState(context),
                child: const Text("Reset State"),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthState authState) {
    if (authState is InitAuthState) {
      return const SignInSection();
    }
    if (authState is OnProgressAuthState) {
      return LayoutLoading();
    }
    if (authState is AuthFailState) {
      return Center(
          child: Text("Auth Fail with error: ${authState.failReason}"));
    }

    if (authState is AuthSuccessState) {
      final isUserType = (authState.user is User);
      return Center(
        child: Text(
            "Hi ${isUserType ? (authState.user as User).name : authState.user.accessToken}"),
      );
    }
    if (authState is FirstAuthSuccessState) {
      final isUserType = (authState.user is User);
      return Center(
        child: Text(
            "Welcome onboard with us ${isUserType ? (authState.user as User).name : authState.user.accessToken}"),
      );
    }
    return Center(
      child: Text("AuthState: $authState}"),
    );
  }

  _resetState(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    authBloc.add(const ResetAuthStateEvent());
  }
}

class SignInSection extends StatelessWidget {
  const SignInSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          width: double.infinity,
        ),
        ElevatedButton(
          onPressed: () => _loginWithUserPass(context),
          child: const Text("Login with user pass"),
        ),
        ElevatedButton(
          onPressed: () => _loginWithGoogle(context),
          child: const Text("Login with google"),
        ),
        ElevatedButton(
          onPressed: () => _localAuth(context),
          child: const Text("Auth with local Auth"),
        ),
      ],
    );
  }

  void _loginWithUserPass(BuildContext context) {
    AuthBloc bloc = context.read<AuthBloc>();
    bloc.add(const AuthWithUsernameAndPasswordApiEvent(
        email: 'user@github.com', password: '12344'));
  }

  void _loginWithGoogle(BuildContext context) {
    AuthBloc bloc = context.read<AuthBloc>();
    bloc.add(const AuthWithGoogleEvent());
  }

  _localAuth(BuildContext context) {
    AuthBloc bloc = context.read<AuthBloc>();
    bloc.add(const BiometricAuthEvent(
        authReason: "Let move on to the next step by sign in now!!"));
  }
}
