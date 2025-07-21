import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TenantModel {
  final String objectId;
  final String studentName;
  final String studentEmail;
  final String studentId;
  final String republicId;
  final bool belongs;

  TenantModel({
    this.objectId = '',
    required this.studentName,
    required this.studentEmail,
    required this.studentId,
    required this.republicId,
    this.belongs = true,
  });

  factory TenantModel.fromParse(ParseObject obj) {
    final studentObj = obj.get<ParseObject>('student');
    final republicObj = obj.get<ParseObject>('republic');

    return TenantModel(
      objectId: obj.objectId ?? '',
      studentName: obj.get<String>('studentName') ?? 'Nome não informado',
      studentEmail: obj.get<String>('studentEmail') ?? 'Email não informado',
      studentId: studentObj?.objectId ?? '',
      republicId: republicObj?.objectId ?? '',
      belongs: obj.get<bool>('belongs') ?? false,
    );
  }

  ParseObject toParse() {
    final tenantObj = ParseObject('Tenants');
    if (objectId.isNotEmpty) {
      tenantObj.objectId = objectId;
    }

    final studentPointer = ParseObject('Student')..objectId = studentId;
    final republicPointer = ParseObject('Republic')..objectId = republicId;

    tenantObj
      ..set('student', studentPointer)
      ..set('republic', republicPointer)
      ..set('studentName', studentName)
      ..set('studentEmail', studentEmail)
      ..set('belongs', belongs);

    return tenantObj;
  }
}
