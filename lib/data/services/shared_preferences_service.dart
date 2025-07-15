import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  // Salva um valor string no SharedPreferences com a chave fornecida
  Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Busca um valor string do SharedPreferences com a chave fornecida
  Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }
}
