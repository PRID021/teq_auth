abstract class AuthApi {
  Future<R> loginByAccessToken<R>(String accessToken);

  Future<R> login<R>(String email, String password);

  Future<R> loginGoogle<R>(String googleToken);

  Future<R> logout<R>();

  Future<R> forgetPassword<R>(String account, String password);
}
