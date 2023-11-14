import 'package:flutter/cupertino.dart';
import 'package:teq_auth/src/services/token/token_service.dart';

import '../local_storage/data_storage.dart';

enum TeqTokenKeys {
  accessToken("TEQ_ACCESS_TOKEN"),
  refreshToken("REFRESH_TOKEN");

  const TeqTokenKeys(this.key);

  final String key;
}

class TeqTokenService extends ChangeNotifier implements TokenService {
  final DataStorage localStorageData;

  TeqTokenService({required this.localStorageData});

  @override
  String? getAccessToken() {
    try {
      final accessToken =
          localStorageData.getString(TeqTokenKeys.accessToken.key);
      return accessToken;
    } catch (e) {
      print(" ${TeqTokenKeys.accessToken.key}  TeqTokenService ===> 28: $e");
    }
  }

  @override
  String? getRefreshToken() {
    final refreshToken =
        localStorageData.getString(TeqTokenKeys.refreshToken.key);
    return refreshToken;
  }

  @override
  void subscribe(Listenable listenable) {
    listenable.addListener(() {});
  }

  @override
  Future<bool> setToken(
      {required String accessToken, required String refreshToken}) async {
    final setRefresh =
        localStorageData.setString(TeqTokenKeys.refreshToken.key, refreshToken);
    final setAccess =
        localStorageData.setString(TeqTokenKeys.accessToken.key, accessToken);
    final results = await Future.wait([setRefresh, setAccess]);
    return results.reduce((value, element) => value && element);
  }
}
