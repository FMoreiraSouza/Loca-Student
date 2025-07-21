import 'package:loca_student/bloc/user-type/user_type_cubit.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserType userType;

  LoginSuccess(this.userType);
}

class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
