import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login_bloc.dart';
import 'package:loca_student/bloc/auth/login_event.dart';
import 'package:loca_student/bloc/auth/login_state.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/ui/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<UserTypeCubit>().state;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(userType == UserType.estudante ? 'Login Estudante' : 'Login Proprietário'),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Navegar para a próxima página (exemplo: HomePage)
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ), // Substitua por sua página real
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userType == UserType.estudante
                        ? 'Formulário para estudantes'
                        : 'Formulário para proprietários',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  state is LoginLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(
                              LoginSubmitted(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                context: context,
                              ),
                            );
                          },
                          child: const Text('Entrar'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
