import 'package:shared_preferences/shared_preferences.dart';

class LocalDataHelper {
  static late final SharedPreferences preferences;
  static bool _init = false;
  static Future init() async {
    if (_init) return;
    preferences = await SharedPreferences.getInstance();
    _init = true;
    return preferences;
  }

  static setString(String key, String value) {
    preferences.setString(key, value);
  }

  static String getString(
    String key,
  ) {
    return preferences.getString(key) ?? "";
  }

  static setInt(String key, int value) {
    preferences.setInt(key, value);
  }

  static getInt(String key) {
    return preferences.getInt(key);
  }

  static clearData() {
    preferences.clear();
  }
}
