import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'user_model.dart';

class RepublicModel extends UserModel {
  final String objectId;
  final double value;
  final String address;
  final String city;
  final String state;
  final double latitude;
  final double longitude;
  final int vacancies;
  final String phone;

  RepublicModel({
    this.objectId = '',
    required this.value,
    required this.address,
    required this.city,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.vacancies,
    required this.phone,
    required super.username,
    required super.email,
  });

  factory RepublicModel.fromParse(ParseObject obj, {ParseUser? user}) {
    final num? valueNum = obj.get<num>('value');
    final num? latNum = obj.get<num>('latitude');
    final num? lonNum = obj.get<num>('longitude');

    return RepublicModel(
      objectId: obj.objectId ?? '',
      value: (valueNum ?? 0).toDouble(),
      address: obj.get<String>('address') ?? '',
      city: obj.get<String>('city') ?? '',
      state: obj.get<String>('state') ?? '',
      latitude: (latNum ?? 0).toDouble(),
      longitude: (lonNum ?? 0).toDouble(),
      vacancies: obj.get<int>('vacancies') ?? 0,
      phone: obj.get<String>('phone') ?? '',
      username: user?.username ?? '',
      email: user?.emailAddress ?? '',
    );
  }

  ParseObject toParse({ParseUser? user}) {
    final republic = ParseObject('Republic');

    if (objectId.isNotEmpty) {
      republic.objectId = objectId;
    }

    republic
      ..set('value', value)
      ..set('address', address)
      ..set('city', city)
      ..set('state', state)
      ..set('latitude', latitude)
      ..set('longitude', longitude)
      ..set('vacancies', vacancies)
      ..set('phone', phone);

    if (user != null) {
      republic.set('user', user);
    }

    return republic;
  }
}
