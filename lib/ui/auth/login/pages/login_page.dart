﻿import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login/login_bloc.dart';
import 'package:loca_student/bloc/auth/login/login_event.dart';
import 'package:loca_student/bloc/auth/login/login_state.dart';
import 'package:loca_student/bloc/user-type/user_type_cubit.dart';
import 'package:loca_student/ui/auth/user-register/pages/user_register_page.dart';
import 'package:loca_student/ui/republic-home/pages/republic_home_page.dart';
import 'package:loca_student/ui/student-home/pages/student_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  void _onSubmit() {
    context.read<LoginBloc>().add(
      LoginSubmitted(email: emailController.text.trim(), password: passwordController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<UserTypeCubit>().state;

    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            _showErrorDialog(context, 'Erro de login', state.message);
          }
          if (state is LoginSuccess) {
            if (state.userType == UserType.student) {
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => const StudentHomePage()));
            } else if (state.userType == UserType.republic) {
              Navigator.of(
                context,
              ).pushReplacement(MaterialPageRoute(builder: (_) => const RepublicHomePage()));
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Tipo de usuário inválido')));
            }
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewPadding.top -
                      MediaQuery.of(context).viewInsets.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_circle_left, size: 50),
                        onPressed: () => Navigator.of(context).pop(),
                        tooltip: 'Voltar',
                      ),
                      userType == UserType.student
                          ? Image.asset('content/student.png', height: 200, color: Colors.white)
                          : Image.asset('content/republic.png', height: 200, color: Colors.white),
                      const SizedBox(height: 24),
                      TextField(
                        controller: emailController,
                        focusNode: emailFocus,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: Color(0xFF4B4B4B)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFocus),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        focusNode: passwordFocus,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock, color: Color(0xFF4B4B4B)),
                        ),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: () => FocusScope.of(context).unfocus(),
                      ),
                      const SizedBox(height: 16),
                      state is LoginLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _onSubmit,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Entrar'),
                              ),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
