import 'package:flutter/material.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context; // Adicionado para acessar outros BLoCs

  LoginSubmitted({required this.email, required this.password, required this.context});
}
