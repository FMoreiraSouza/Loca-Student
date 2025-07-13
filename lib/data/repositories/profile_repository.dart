import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProfileRepository {
  Future<ParseUser?> getCurrentUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user == null) return null;
    try {
      await user.fetch();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserProfileData() async {
    final user = await getCurrentUser();
    if (user == null) return null;

    final userType = user.get<String>('userType') ?? '';

    // Dados básicos comuns
    final profileMap = <String, dynamic>{
      'email': user.emailAddress ?? '',
      'name': user.username ?? '',
      'userType': userType,
    };

    // Agora busca dados adicionais conforme tipo
    if (userType == 'estudante') {
      final query = QueryBuilder<ParseObject>(ParseObject('Student'))..whereEqualTo('user', user);
      final response = await query.query();

      if (response.success && response.results != null && response.results!.isNotEmpty) {
        final estudante = response.results!.first;
        profileMap.addAll({
          'age': estudante.get<int>('age'),
          'degree': estudante.get<String>('degree'),
          'origin': estudante.get<String>('origin'),
          'sex': estudante.get<String>('sex'),
          'university': estudante.get<String>('university'),
        });
      }
    } else if (userType == 'proprietario') {
      final query = QueryBuilder<ParseObject>(ParseObject('Owner'))..whereEqualTo('user', user);
      final response = await query.query();

      if (response.success && response.results != null && response.results!.isNotEmpty) {
        final proprietario = response.results!.first;
        profileMap.addAll({
          'value': (proprietario.get<num>('value'))?.toDouble(),
          'address': proprietario.get<String>('address'),
          'city': proprietario.get<String>('city'),
          'state': proprietario.get<String>('state'),
          'latitude': (proprietario.get<num>('latitude'))?.toDouble(),
          'longitude': (proprietario.get<num>('longitude'))?.toDouble(),
        });
      }
    }

    return profileMap;
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    await user?.logout();
  }
}
