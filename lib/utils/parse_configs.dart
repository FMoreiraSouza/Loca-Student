import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ParseConfigs {
  static Future<void> initializeParse() async {
    await Parse().initialize(
      'fp39HoyCcVZjJBIujmayVOKajrPfpvGdyulby2Uf',
      'https://parseapi.back4app.com',
      clientKey: 'OLUQDoRRzHiyMWIuWfkGqdJwjZbKlIKKi3S0250E',
      autoSendSessionId: true,
      debug: true,
    );
  }

  static Future<ParseUser> getCurrentUser() async {
    try {
      final user = await ParseUser.currentUser() as ParseUser?;
      if (user == null) {
        throw Exception('Nenhum usuário logado');
      }
      await user.fetch();
      return user;
    } catch (e) {
      throw Exception('Falha ao obter usuário atual: $e');
    }
  }
}
