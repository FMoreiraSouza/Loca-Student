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
    final interestObj = ParseObject('InterestStudents');

    if (objectId.isNotEmpty) {
      interestObj.objectId = objectId;
    }

    // Sempre referencie o student existente usando o ID
    interestObj.set('student', ParseObject('Student')..objectId = studentId);

    // Nome e email podem vir do próprio modelo
    interestObj.set('studentName', studentName);
    interestObj.set('studentEmail', studentEmail);

    // Referência à república
    interestObj.set('republic', republic);

    // Status inicial ou o que for necessário
    interestObj.set('status', 'interessado');

    return interestObj;
  }
}
