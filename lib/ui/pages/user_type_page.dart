import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/ui/pages/login_page.dart';

class UserTypePage extends StatelessWidget {
  const UserTypePage({super.key});

  void _goToLogin(BuildContext context, UserType type) {
    context.read<UserTypeCubit>().setUserType(type);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Você é', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _goToLogin(context, UserType.estudante),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Estudante'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _goToLogin(context, UserType.proprietario),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Proprietário'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
