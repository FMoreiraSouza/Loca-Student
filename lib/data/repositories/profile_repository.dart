import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProfileRepository {
  Future<Map<String, dynamic>?> getUserProfileData(ParseUser currentUser) async {
    final userType = (currentUser.get('userType') as String?) ?? '';

    final profileMap = <String, dynamic>{
      'email': currentUser.emailAddress ?? '',
      'name': currentUser.username ?? '',
      'userType': userType,
    };

    if (userType == 'estudante') {
      final query = QueryBuilder<ParseObject>(ParseObject('Student'))
        ..whereEqualTo('user', currentUser);
      final response = await query.query();
      if (response.success && response.results != null && response.results!.isNotEmpty) {
        final stud = response.results!.first as ParseObject;
        profileMap.addAll({
          'age': stud.get<int>('age') ?? 0,
          'degree': stud.get<String>('degree') ?? '',
          'origin': stud.get<String>('origin') ?? '',
          'sex': stud.get<String>('sex') ?? '',
        });
      }
    } else if (userType == 'proprietario') {
      final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
        ..whereEqualTo('user', currentUser);
      final response = await query.query();
      if (response.success && response.results != null && response.results!.isNotEmpty) {
        final rep = response.results!.first as ParseObject;
        profileMap.addAll({
          'value': (rep.get<num>('value') ?? 0).toDouble(),
          'address': rep.get<String>('address') ?? '',
          'city': rep.get<String>('city') ?? '',
          'state': rep.get<String>('state') ?? '',
          'latitude': (rep.get<num>('latitude') ?? 0).toDouble(),
          'longitude': (rep.get<num>('longitude') ?? 0).toDouble(),
        });
      }
    }

    return profileMap;
  }

  Future<void> logout(ParseUser currentUser) async {
    await currentUser.logout();
  }
}
