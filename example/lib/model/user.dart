import 'package:teq_auth/teq_auth.dart';

class User extends TokenInfo {
  final String name;

  User(
      {required this.name,
      required super.accessToken,
      required super.refreshToken});
}
