import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class LocalRepository {
  late SharedPreferences? _prefs;

  LocalRepository() {
    _prefs = null;
  }

  Future<SharedPreferences> getPref() async {
    if (_prefs != null) return _prefs!;
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    SharedPreferences prefs = await getPref();
    return prefs.setString(key, value);
  }

  Future<String> getString(String key) async {
    SharedPreferences prefs = await getPref();
    return prefs.getString(key) ?? StringPool.empty;
  }

  Future<bool> setBool(String key, bool value) async {
    SharedPreferences prefs = await getPref();
    return prefs.setBool(key, value);
  }

  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await getPref();
    return prefs.getBool(key) ?? false;
  }
}
