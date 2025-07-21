import 'package:loca_student/data/models/student_model.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

abstract class IProfileRepository {
  Future<StudentModel?> getStudentProfile(ParseUser currentUser);
  Future<RepublicModel?> getRepublicProfile(ParseUser currentUser);
  Future<dynamic> getUserProfile(ParseUser currentUser);
  Future<void> logout(ParseUser currentUser);
}
