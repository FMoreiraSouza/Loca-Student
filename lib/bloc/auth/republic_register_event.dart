import 'package:loca_student/bloc/auth/user_register_event.dart';

class RepublicRegisterSubmitted extends UserRegisterEvent {
  final String name;
  final double value;
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final String email;
  final String password;
  final int vacancies;
  final String phone;

  RepublicRegisterSubmitted({
    required this.name,
    required this.value,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.email,
    required this.password,
    required this.vacancies,
    required this.phone,
  });
}
