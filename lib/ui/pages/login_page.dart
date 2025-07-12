import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login_bloc.dart';
import 'package:loca_student/bloc/auth/login_event.dart';
import 'package:loca_student/bloc/auth/login_state.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/ui/pages/user_register_page.dart';
import 'package:loca_student/ui/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<UserTypeCubit>().state;
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // Criar FocusNodes para os TextFields
    final emailFocus = FocusNode();
    final passwordFocus = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text(userType == UserType.estudante ? 'Login Estudante' : 'Login Proprietário'),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
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
                    focusNode: emailFocus,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(passwordFocus);
                    },
                  ),
                  TextField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      // Opcional: Pode chamar a ação de login ao pressionar "Concluído"
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
                        return;
                      }
                      context.read<LoginBloc>().add(
                        LoginSubmitted(email: email, password: password, context: context),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  state is LoginLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Preencha todos os campos')),
                              );
                              return;
                            }
                            context.read<LoginBloc>().add(
                              LoginSubmitted(email: email, password: password, context: context),
                            );
                          },
                          child: const Text('Entrar'),
                        ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => const UserRegisterPage()));
                    },
                    child: const Text('Não tem conta? Cadastre-se'),
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
