import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ReservationModel {
  final String id;
  final String address;
  final String city;
  final String state;
  final double value;
  final String status;

  ReservationModel({
    required this.id,
    required this.address,
    required this.city,
    required this.state,
    required this.value,
    required this.status,
  });

  factory ReservationModel.fromParse(ParseObject obj) {
    return ReservationModel(
      id: obj.objectId ?? '',
      address: obj.get<String>('address') ?? 'Endereço não informado',
      city: obj.get<String>('city') ?? 'Cidade não informada',
      state: obj.get<String>('state') ?? 'Estado não informado',
      value: (obj.get<num>('value') ?? 0).toDouble(),
      status: obj.get<String>('status') ?? 'Desconhecido',
    );
  }
}
