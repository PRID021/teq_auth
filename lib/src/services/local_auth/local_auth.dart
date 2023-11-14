abstract class LocalAuth {
  Future<List<String>> availableBiometrics();
  Future<bool> authenticate(String reason);
}
