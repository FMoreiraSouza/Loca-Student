import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TenantModel {
  final String objectId;
  final String studentName;
  final String studentEmail;

  TenantModel({required this.objectId, required this.studentName, required this.studentEmail});

  factory TenantModel.fromParse(ParseObject obj) {
    return TenantModel(
      objectId: obj.objectId ?? '',
      studentName: obj.get<String>('studentName') ?? 'Nome não informado',
      studentEmail: obj.get<String>('studentEmail') ?? 'Email não informado',
    );
  }
}
