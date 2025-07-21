import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:loca_student/data/models/user_model.dart';

class StudentModel extends UserModel {
  final String objectId;
  final int age;
  final String origin;
  final String phone;

  StudentModel({
    this.objectId = '',
    required this.age,
    required this.origin,
    required this.phone,
    required super.username,
    required super.email,
  });

  factory StudentModel.fromParse(ParseObject obj) {
    final userObj = obj.get<ParseObject>('user');
    final username = userObj?.get<String>('username') ?? '';
    final email = userObj?.get<String>('email') ?? '';
    return StudentModel(
      objectId: obj.objectId ?? '',
      age: obj.get<int>('age') ?? 0,
      origin: obj.get<String>('origin') ?? '',
      phone: obj.get<String>('phone') ?? '',
      username: username,
      email: email,
    );
  }

  ParseObject toParse({ParseUser? user}) {
    final studentObj = ParseObject('Student');
    if (objectId.isNotEmpty) {
      studentObj.objectId = objectId;
    }
    studentObj
      ..set('age', age)
      ..set('origin', origin)
      ..set('phone', phone);

    if (user != null) {
      studentObj.set('user', user);
    }

    return studentObj;
  }
}
