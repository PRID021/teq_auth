import 'package:shared_preferences/shared_preferences.dart';

import 'data_storage.dart';

class SharedPreferencesDataStorage extends DataStorage {
  final SharedPreferences sharedPreferences;

  SharedPreferencesDataStorage({required this.sharedPreferences});

  @override
  Future clearAll() async {
    return await sharedPreferences.clear();
  }

  @override
  List<Map<String, dynamic>> getAllData() {
    return (sharedPreferences.getKeys())
        .where((element) => sharedPreferences.containsKey(element))
        .map<Map<String, dynamic>>((e) => {e: sharedPreferences.get(e)})
        .toList();
  }


  @override
  Future<bool> remove(String key) => sharedPreferences.remove(key);

  @override
  double? getDouble(String key) => sharedPreferences.getDouble(key);

  @override
  int? getInt(String key) => sharedPreferences.getInt(key);

  @override
  String? getString(String key) => sharedPreferences.getString(key);

  @override
  Future<bool> setDouble(String key, double value) =>
      sharedPreferences.setDouble(key, value);

  @override
  Future<bool> setInt(String key, int value) =>
      sharedPreferences.setInt(key, value);

  @override
  Future<bool> setString(String key, String value) =>
      sharedPreferences.setString(key, value);
}
