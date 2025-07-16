import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestedStudentModel {
  final String objectId;
  final String studentName;
  final String studentEmail;
  final String studentId;
  final String republicId;

  InterestedStudentModel({
    required this.objectId,
    required this.studentName,
    required this.studentEmail,
    required this.studentId,
    required this.republicId,
  });

  factory InterestedStudentModel.fromParse(ParseObject obj) {
    final student = obj.get<ParseObject>('student');
    final republic = obj.get<ParseObject>('republic');

    return InterestedStudentModel(
      objectId: obj.objectId ?? '',
      studentName: obj.get<String>('studentName') ?? 'Nome não informado',
      studentEmail: obj.get<String>('studentEmail') ?? 'Email não informado',
      studentId: student?.objectId ?? '',
      republicId: republic?.objectId ?? '',
    );
  }
}
