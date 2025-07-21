import 'package:loca_student/data/models/student_model.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';

abstract class IAuthRepository {
  Future<LoginResult> login(String email, String password);

  Future<LoginResult> registerStudent({
    required String username,
    required String emailAddress,
    required String password,
    required StudentModel student,
  });
  Future<LoginResult> registerRepublic({
    required String username,
    required String emailAddress,
    required String password,
    required RepublicModel republic,
  });
  Future<void> logout();
  Future<bool> isLoggedIn();
}
