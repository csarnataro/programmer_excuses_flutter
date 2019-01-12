import 'package:shared_preferences/shared_preferences.dart';

/// Helper for storing and retrieving the preferred language for the app
/// in the SharedPreferences
class PrefsHelper {

  /// Stores the preferred language
  static void storeLang(String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', newValue);
  } 

  /// Retrieves the preferred language
  static Future<String> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('lang');
  }
}
