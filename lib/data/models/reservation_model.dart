import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ReservationModel {
  final String id;
  final String address;
  final String city;
  final String state;
  final double value;
  final String status;
  final ParseObject? studentPointer;
  final ParseObject? republicPointer;
  final String republicUsername;

  ReservationModel({
    required this.id,
    required this.address,
    required this.city,
    required this.state,
    required this.value,
    required this.status,
    this.studentPointer,
    this.republicPointer,
    this.republicUsername = '',
  });

  factory ReservationModel.fromParse(ParseObject obj) {
    final republicObj = obj.get<ParseObject>('republic');

    final userObj = republicObj?.get<ParseObject>('user');

    final username = userObj?.get<String>('username') ?? '';

    return ReservationModel(
      id: obj.objectId ?? '',
      address: obj.get<String>('address') ?? '',
      city: obj.get<String>('city') ?? '',
      state: obj.get<String>('state') ?? '',
      value: (obj.get<num>('value') ?? 0).toDouble(),
      status: obj.get<String>('status') ?? '',
      studentPointer: obj.get<ParseObject>('student'),
      republicPointer: republicObj,
      republicUsername: username,
    );
  }

  ParseObject toParse() {
    final obj = ParseObject('Reservations');
    if (id.isNotEmpty) obj.objectId = id;

    obj.set('address', address);
    obj.set('city', city);
    obj.set('state', state);
    obj.set('value', value);
    obj.set('status', status);
    if (studentPointer != null) obj.set('student', studentPointer!);
    if (republicPointer != null) obj.set('republic', republicPointer!);

    return obj;
  }
}
