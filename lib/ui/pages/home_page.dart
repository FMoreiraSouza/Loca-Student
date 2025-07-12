import 'package:flutter/material.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';

class HomePage extends StatelessWidget {
  final UserType? userType; // Recebe o userType como parâmetro

  const HomePage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    // Para depuração, logar o userType recebido
    print('UserType na HomePage: $userType');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userType == UserType.estudante
              ? 'Home Estudante'
              : userType == UserType.proprietario
              ? 'Home Proprietário'
              : 'Home',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text(
          userType == null
              ? 'Bem-vindo!'
              : 'Bem-vindo, ${userType == UserType.estudante ? 'Estudante' : 'Proprietário'}!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
