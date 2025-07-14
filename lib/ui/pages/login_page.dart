import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login_bloc.dart';
import 'package:loca_student/bloc/auth/login_event.dart';
import 'package:loca_student/bloc/auth/login_state.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/ui/pages/user_register_page.dart';
import 'package:loca_student/ui/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  void _submitLogin(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<UserTypeCubit>().state;

    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            final selectedType = context.read<UserTypeCubit>().state;
            final userTypeFromBackend = state.userType;

            // Verifica se o tipo selecionado pelo usuário é o mesmo do backend
            if (selectedType != userTypeFromBackend) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Esse usuário não corresponde ao tipo em questão')),
              );
              return;
            }

            // Se estiver tudo certo, navega para a HomePage
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => HomePage(userType: state.userType)));
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        tooltip: 'Voltar',
                      ),
                      userType == UserType.estudante
                          ? Image.asset('content/student.png', height: 200)
                          : Image.asset('content/republic.png', height: 200),
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
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(passwordFocus);
                        },
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
                        onEditingComplete: () {
                          // Fechar o teclado
                          FocusScope.of(context).unfocus();
                        },
                      ),

                      const SizedBox(height: 16),
                      state is LoginLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () => _submitLogin(context),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
