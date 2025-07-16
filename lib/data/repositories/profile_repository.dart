import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProfileRepository {
  Future<ParseUser?> getCurrentUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user == null) return null;
    await user.fetch();
    return user;
  }

  Future<Map<String, dynamic>?> getUserProfileData() async {
    final user = await getCurrentUser();
    if (user == null) return null;

    final userType = (user.get('userType') as String?) ?? '';

    final profileMap = <String, dynamic>{
      'email': user.emailAddress ?? '',
      'name': user.username ?? '',
      'userType': userType,
    };

    if (userType == 'estudante') {
      final query = QueryBuilder<ParseObject>(ParseObject('Student'))..whereEqualTo('user', user);
      final response = await query.query();
      if (response.success && response.results != null && response.results!.isNotEmpty) {
        final stud = response.results!.first as ParseObject;
        profileMap.addAll({
          'age': (stud.get('age') as int?) ?? 0,
          'degree': (stud.get('degree') as String?) ?? '',
          'origin': (stud.get('origin') as String?) ?? '',
          'sex': (stud.get('sex') as String?) ?? '',
        });
      }
    } else if (userType == 'proprietario') {
      final query = QueryBuilder<ParseObject>(ParseObject('Republic'))..whereEqualTo('user', user);
      final response = await query.query();
      if (response.success && response.results != null && response.results!.isNotEmpty) {
        final rep = response.results!.first as ParseObject;
        final rawValue = rep.get('value') as num?;
        final rawLatitude = rep.get('latitude') as num?;
        final rawLongitude = rep.get('longitude') as num?;

        profileMap.addAll({
          'value': rawValue?.toDouble() ?? 0.0,
          'address': (rep.get('address') as String?) ?? '',
          'city': (rep.get('city') as String?) ?? '',
          'state': (rep.get('state') as String?) ?? '',
          'latitude': rawLatitude?.toDouble() ?? 0.0,
          'longitude': rawLongitude?.toDouble() ?? 0.0,
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
