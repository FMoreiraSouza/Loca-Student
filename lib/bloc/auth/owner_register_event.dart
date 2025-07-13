import 'package:loca_student/bloc/auth/student_register_event.dart';

class OwnerRegisterSubmitted extends UserRegisterEvent {
  final String name;
  final double value;
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final String email;
  final String password;

  OwnerRegisterSubmitted({
    required this.name,
    required this.value,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.email,
    required this.password,
  });
}
