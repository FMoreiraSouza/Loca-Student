abstract class UserRegisterEvent {}

class StudentRegisterSubmitted extends UserRegisterEvent {
  final String name;
  final int age;
  final String degree;
  final String origin;
  final String sex;
  final String university;
  final String email;
  final String password;

  StudentRegisterSubmitted({
    required this.name,
    required this.age,
    required this.degree,
    required this.origin,
    required this.sex,
    required this.university,
    required this.email,
    required this.password,
  });
}
