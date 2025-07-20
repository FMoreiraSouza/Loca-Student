import 'package:loca_student/data/models/user_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentModel extends UserModel {
  final String objectId;
  final int age;
  final String degree;
  final String origin;
  final String sex;

  StudentModel({
    this.objectId = '',
    required this.age,
    required this.degree,
    required this.origin,
    required this.sex,
    required super.username,
    required super.email,
  });

  factory StudentModel.fromParse(ParseObject obj, {ParseUser? user}) {
    return StudentModel(
      objectId: obj.objectId ?? '',
      age: obj.get<int>('age') ?? 0,
      degree: obj.get<String>('degree') ?? '',
      origin: obj.get<String>('origin') ?? '',
      sex: obj.get<String>('sex') ?? '',
      username: user?.username ?? '',
      email: user?.emailAddress ?? '',
    );
  }

  ParseObject toParse({ParseUser? user}) {
    final studentObj = ParseObject('Student');
    if (objectId.isNotEmpty) {
      studentObj.objectId = objectId;
    }
    studentObj
      ..set('age', age)
      ..set('degree', degree)
      ..set('origin', origin)
      ..set('sex', sex);

    if (user != null) {
      studentObj.set('user', user);
    }

    return studentObj;
  }
}
