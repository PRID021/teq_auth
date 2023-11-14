import 'package:flutter/foundation.dart';

abstract class TokenService {
  String? getAccessToken();
  String? getRefreshToken();

  Future<bool> setToken({ required String accessToken,  required String refreshToken});

  void subscribe (Listenable listenable);
}
