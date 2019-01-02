import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lang');
  }

  static void storeLang(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', newValue);
  }
}