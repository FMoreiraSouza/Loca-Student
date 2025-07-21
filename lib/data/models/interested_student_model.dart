import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'student_model.dart';

class InterestedStudentModel {
  final String objectId;
  final String studentName;
  final String studentEmail;
  final String studentId;
  final String republicId;
  final StudentModel? student;

  InterestedStudentModel({
    required this.objectId,
    required this.studentName,
    required this.studentEmail,
    required this.studentId,
    required this.republicId,
    this.student,
  });

  factory InterestedStudentModel.fromParse(ParseObject obj) {
    final studentObj = obj.get<ParseObject>('student');
    StudentModel? studentModel;
    if (studentObj != null) {
      studentModel = StudentModel.fromParse(studentObj);
    }
    final republicObj = obj.get<ParseObject>('republic');

    return InterestedStudentModel(
      objectId: obj.objectId ?? '',
      studentName: obj.get<String>('studentName') ?? 'Nome não informado',
      studentEmail: obj.get<String>('studentEmail') ?? 'Email não informado',
      studentId: studentObj?.objectId ?? '',
      republicId: republicObj?.objectId ?? '',
      student: studentModel,
    );
  }

  ParseObject toParse({required ParseObject republic}) {
    final interestedObj = ParseObject('InterestedStudents');

    if (objectId.isNotEmpty) {
      interestedObj.objectId = objectId;
    }

    interestedObj.set('student', ParseObject('Student')..objectId = studentId);
    interestedObj.set('studentName', studentName);
    interestedObj.set('studentEmail', studentEmail);
    interestedObj.set('republic', republic);
    interestedObj.set('status', 'interessado');

    return interestedObj;
  }
}
