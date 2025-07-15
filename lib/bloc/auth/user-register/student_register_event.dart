import 'package:loca_student/bloc/auth/user-register/user_register_event.dart';

class StudentRegisterSubmitted extends UserRegisterEvent {
  final String name;
  final int age;
  final String degree;
  final String origin;
  final String sex;
  final String email;
  final String password;

  StudentRegisterSubmitted({
    required this.name,
    required this.age,
    required this.degree,
    required this.origin,
    required this.sex,
    required this.email,
    required this.password,
  });
}
