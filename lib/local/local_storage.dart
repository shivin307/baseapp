import 'package:shared_preferences/shared_preferences.dart';

Future<void> setKeyValue({required String key, required String value}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString(key, value);
}

Future<String?> getKeyValue({required String key}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getString(key);
}

Future<void> setIsLogin({required String key, required bool value}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setBool(key, value);
}

Future<bool?> getIsLogin({required String key}) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  return preferences.getBool(key);
}
