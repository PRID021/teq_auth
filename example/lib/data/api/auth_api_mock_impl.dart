import 'package:teq_auth/teq_auth.dart';
import 'package:teq_flutter_core/teq_flutter_core.dart';
import '../../model/user.dart';

class AuthApiMockImpl extends BaseAPI implements AuthApi {
  @override
  Future<R> forgetPassword<R>(String account, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    final user = User(
        name: "Fake",
        accessToken: "accessToken-Fake",
        refreshToken: "refreshToken-Fake");
    return user as R;
  }

  @override
  Future<R> login<R>(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    final user = User(
        name: "Teq User",
        accessToken: "accessToken-Fake",
        refreshToken: "refreshToken-Fake");
    return user as R;
  }

  @override
  Future<R> loginByAccessToken<R>(String accessToken) async {
    throw UnimplementedError();
  }

  @override
  Future<R> loginGoogle<R>(String googleToken) async {
    await Future.delayed(const Duration(seconds: 2));
    final user = User(
        name: "Google User",
        accessToken: "accessToken-Fake",
        refreshToken: "refreshToken-Fake");
    return user as R;
  }

  @override
  Future<R> logout<R>() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
