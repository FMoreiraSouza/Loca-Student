import 'package:loca_student/bloc/auth/user-register/user_register_event.dart';

class StudentRegisterSubmitted extends UserRegisterEvent {
  final String name;
  final String email;
  final String password;
  final int age;
  final String origin;
  final String phone;

  StudentRegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.origin,
    required this.phone,
  });
}
