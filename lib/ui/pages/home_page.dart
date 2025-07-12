import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<UserTypeCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text(userType == UserType.estudante ? 'Home Estudante' : 'Home Proprietário'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          'Bem-vindo, ${userType == UserType.estudante ? 'Estudante' : 'Proprietário'}!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
