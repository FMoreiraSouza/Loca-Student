abstract class UserRegisterState {}

class UserRegisterInitial extends UserRegisterState {}

class UserRegisterLoading extends UserRegisterState {}

class UserRegisterSuccess extends UserRegisterState {}

class UserRegisterFailure extends UserRegisterState {
  final String message;

  UserRegisterFailure(this.message);
}
