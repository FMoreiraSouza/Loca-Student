import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/user-type/user_type_cubit.dart';
import 'package:loca_student/ui/auth/login/pages/login_page.dart';

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
              // LOGO / TÍTULO APP COM BORDA
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset('content/app_icon.png', height: 150),
              ),

              // TÍTULO SECUNDÁRIO
              const Text(
                'Você é',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),

              // BOTÕES
              ElevatedButton(
                onPressed: () => _goToLogin(context, UserType.student),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text('Estudante'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _goToLogin(context, UserType.republic),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
                child: const Text('República'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
