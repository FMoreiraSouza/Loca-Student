import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}
