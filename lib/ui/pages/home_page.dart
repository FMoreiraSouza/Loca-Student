import 'package:flutter/material.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/ui/pages/owner_page.dart';
import 'package:loca_student/ui/pages/student_page.dart';

class HomePage extends StatelessWidget {
  final UserType? userType;

  const HomePage({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    // Redireciona logo após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userType == UserType.estudante) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const StudentPage()));
      } else if (userType == UserType.proprietario) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OwnerPage()));
      } else {
        // Caso indefinido (fallback)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Tipo de usuário inválido')));
      }
    });

    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Mostra algo enquanto redireciona
      ),
    );
  }
}
