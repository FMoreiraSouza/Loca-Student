import 'package:flutter/material.dart';

class StudentProfileWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const StudentProfileWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Idade: ${data['age'] ?? 'Não informado'}'),
        Text('Curso: ${data['degree'] ?? 'Não informado'}'),
        Text('Origem: ${data['origin'] ?? 'Não informado'}'),
        Text('Sexo: ${data['sex'] ?? 'Não informado'}'),
        Text('Universidade: ${data['university'] ?? 'Não informado'}'),
      ],
    );
  }
}
