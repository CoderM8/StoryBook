import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefService {
  Future<void> setString(String responseString, String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, responseString);

  }

 getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? getValue = prefs.getString(key);
    return getValue;
  }

  Future<void> setBool(bool data, String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, data);
  }

  Future<bool> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool updated = prefs.getBool(key) ?? false;
    return updated;
  }

  Future<void> setInt(int data, String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, data);
  }

  Future<int?> getInt(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? updated = prefs.getInt(key);
    return updated;
  }

  Future<void> remove(removeKey) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(removeKey);
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
