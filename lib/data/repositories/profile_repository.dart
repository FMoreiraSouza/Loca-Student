import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:loca_student/data/models/student_model.dart';
import 'package:loca_student/data/models/republic_model.dart';

class ProfileRepository {
  Future<StudentModel?> getStudentProfile(ParseUser currentUser) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Student'))
      ..whereEqualTo('user', currentUser);

    final response = await query.query();
    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final studObj = response.results!.first as ParseObject;

      return StudentModel.fromParse(studObj);
    }
    return null;
  }

  Future<RepublicModel?> getRepublicProfile(ParseUser currentUser) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUser);

    final response = await query.query();
    if (response.success && response.results != null && response.results!.isNotEmpty) {
      final repObj = response.results!.first as ParseObject;

      return RepublicModel.fromParse(repObj);
    }
    return null;
  }

  Future<dynamic> getUserProfile(ParseUser currentUser) async {
    final userType = (currentUser.get('userType') as String?) ?? '';

    if (userType == 'estudante') {
      return await getStudentProfile(currentUser);
    } else if (userType == 'república') {
      return await getRepublicProfile(currentUser);
    }
    return null;
  }

  Future<void> logout(ParseUser currentUser) async {
    await currentUser.logout();
  }
}
