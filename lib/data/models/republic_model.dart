import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RepublicModel {
  final String objectId;
  final String username;
  final double value;
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final String email;
  final int vacancies;
  final String phone;

  RepublicModel({
    required this.objectId,
    required this.username,
    required this.value,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.email,
    required this.vacancies,
    required this.phone,
  });

  // Factory para criar a partir de ParseObject
  factory RepublicModel.fromParse(ParseObject obj) {
    return RepublicModel(
      objectId: obj.objectId ?? '',
      username: obj.get<String>('username') ?? '',
      value: obj.get<double>('value') ?? 0.0,
      address: obj.get<String>('address') ?? '',
      city: obj.get<String>('city') ?? '',
      state: obj.get<String>('state') ?? '',
      latitude: obj.get<double>('latitude') ?? 0.0,
      longitude: obj.get<double>('longitude') ?? 0.0,
      email: obj.get<String>('emailAddress') ?? '',
      vacancies: obj.get<int>('vacancies') ?? 0,
      phone: obj.get<String>('phone') ?? '',
    );
  }
}
