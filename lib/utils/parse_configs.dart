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
}
