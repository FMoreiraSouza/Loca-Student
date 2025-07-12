import 'package:flutter/material.dart';

abstract class UserRegisterEvent {}

class UserRegisterSubmitted extends UserRegisterEvent {
  final String name;
  final int? age;
  final String? degree;
  final String? origin;
  final String? sex;
  final String? university;
  final String? propertyType;
  final double? value;
  final String? address;
  final String email;
  final String password;
  final BuildContext context;

  UserRegisterSubmitted({
    required this.name,
    this.age,
    this.degree,
    this.origin,
    this.sex,
    this.university,
    this.propertyType,
    this.value,
    this.address,
    required this.email,
    required this.password,
    required this.context,
  });
}
