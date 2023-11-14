import '../../../teq_auth.dart';

abstract class AuthService {
  Future<R> signIn<R>(
      {required AuthType signInType, AuthParam authParam = const None()});

  Future<R> signOut<R>();

  Future<R> forgetPass<R>({required AccountPasswordParam authParam});

  Future<R> updatePass<R>();
}
