import 'package:flutter/material.dart';
import 'package:loca_student/data/models/student_model.dart';

class StudentProfileWidget extends StatelessWidget {
  final StudentModel student;

  const StudentProfileWidget({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Idade: ${student.age != 0 ? student.age : 'Não informado'}'),
        Text('Origem: ${student.origin.isNotEmpty ? student.origin : 'Não informado'}'),
      ],
    );
  }
}
