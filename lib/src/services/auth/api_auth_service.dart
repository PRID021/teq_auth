import 'package:teq_auth/src/services/auth/auth_service.dart';
import '../../auth_data/auth_api.dart';
import 'auth_type.dart';

abstract class AuthParam {
  const AuthParam();
}

class None extends AuthParam {
  const None();
}

class AccessTokenParam {
  final String accessToken;

  const AccessTokenParam({required this.accessToken});
}

class Credential extends AuthParam {
  final String email;
  final String password;

  Credential({required this.email, required this.password});
}

class GoogleToken extends AuthParam {
  final String googleToken;

  const GoogleToken({required this.googleToken});
}

class AccountPasswordParam extends AuthParam {
  final String account;
  final String password;

  AccountPasswordParam({required this.account, required this.password});
}

class ApiAuthService implements AuthService {
  final AuthApi authApi;

  ApiAuthService({required this.authApi});

  @override
  Future<R> signOut<R>() async {
    return authApi.logout<R>();
  }

  @override
  Future<R> signIn<R>(
      {required AuthType signInType,
      AuthParam authParam = const None()}) async {
    switch (signInType) {
      case AuthType.accessToken:
        if (authParam is AccessTokenParam) {
          return authApi.loginByAccessToken<R>(
              (authParam as AccessTokenParam).accessToken);
        }
        throw "$authParam is not AccessTokenParam type";
      case AuthType.userAndPass:
        if (authParam is Credential) {
          return authApi.login<R>(authParam.email, authParam.password);
        }
        throw "$authParam is not Credential type";

      case AuthType.google:
        if (authParam is GoogleToken) {
          return authApi.loginGoogle<R>(authParam.googleToken);
        }
        throw "$authParam is not GoogleToken type";
      default:
        throw UnsupportedError(
            "Auth Method ${signInType.runtimeType} not supported");
    }
  }

  @override
  Future<R> updatePass<R>() {
    throw UnimplementedError();
  }

  @override
  Future<R> forgetPass<R>({required AccountPasswordParam authParam}) {
    return authApi.forgetPassword<R>(authParam.account, authParam.password);
  }
}
