import 'package:local_auth/local_auth.dart';
import 'dart:io';

import 'local_auth.dart';

class LocalAuthImpl implements LocalAuth {
  LocalAuthImpl._();

  static LocalAuthImpl? _instance;

  static LocalAuthImpl get instance {
    _instance ??= LocalAuthImpl._();
    return _instance!;
  }

  final LocalAuthentication _auth = LocalAuthentication();
  DateTime latestAuthTime = DateTime.now();
  bool _isAuthenticating = false;

  @override
  Future<bool> authenticate(String reason) async {
    _isAuthenticating = true;
    final bool didAuthenticate = await _auth.authenticate(
      localizedReason: reason,
      options: const AuthenticationOptions(
        useErrorDialogs: true,
        biometricOnly: true,
      ),
    );
    if (Platform.isIOS) await Future.delayed(const Duration(seconds: 1));
    latestAuthTime = DateTime.now();
    _isAuthenticating = false;
    return didAuthenticate;
  }

  @override
  Future<List<String>> availableBiometrics() async {
    final types = await _auth.getAvailableBiometrics();
    return types
        .map((e) {
          switch (e) {
            case BiometricType.face:
              return BiometricMethod.face;
            case BiometricType.fingerprint:
              return BiometricMethod.fingerprint;
            default:
              return BiometricMethod.fingerprint;
          }
        })
        .where((element) => element != BiometricMethod.unknown)
        .toList();
  }
}

class BiometricMethod {
  static const face = 'Face ID';
  static const fingerprint = 'Fingerprint';
  static const unknown = 'Unknown';
}
