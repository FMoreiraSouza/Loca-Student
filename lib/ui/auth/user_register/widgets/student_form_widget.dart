import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/student_register_event.dart';
import 'package:loca_student/bloc/auth/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_state.dart';

class StudentForm extends StatefulWidget {
  final UserRegisterState state;

  const StudentForm({super.key, required this.state});

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final degreeController = TextEditingController();
  final originController = TextEditingController();
  String? sex;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameFocus = FocusNode();
  final ageFocus = FocusNode();
  final degreeFocus = FocusNode();
  final originFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    degreeController.dispose();
    originController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocus.dispose();
    ageFocus.dispose();
    degreeFocus.dispose();
    originFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  bool _validateFields(BuildContext context) {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        degreeController.text.trim().isEmpty ||
        originController.text.trim().isEmpty ||
        sex == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos para estudante')));
      return false;
    }
    return true;
  }

  void _submitForm(BuildContext context) {
    if (_validateFields(context)) {
      context.read<UserRegisterBloc>().add(
        StudentRegisterSubmitted(
          name: nameController.text.trim(),
          age: int.tryParse(ageController.text.trim()) ?? 0,
          degree: degreeController.text.trim(),
          origin: originController.text.trim(),
          sex: sex ?? "",
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: nameController,
          focusNode: nameFocus,
          decoration: const InputDecoration(labelText: 'Nome'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(ageFocus);
          },
        ),
        SizedBox(height: 8),
        TextField(
          controller: ageController,
          focusNode: ageFocus,
          decoration: const InputDecoration(labelText: 'Idade'),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(degreeFocus);
          },
        ),
        SizedBox(height: 8),
        TextField(
          controller: degreeController,
          focusNode: degreeFocus,
          decoration: const InputDecoration(labelText: 'Grau a cursar'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(originFocus);
          },
        ),
        SizedBox(height: 8),
        TextField(
          controller: originController,
          focusNode: originFocus,
          decoration: const InputDecoration(labelText: 'De onde vem'),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Sexo'),
          value: sex,
          items: [
            'Masculino',
            'Feminino',
            'Outro',
          ].map((sex) => DropdownMenuItem(value: sex, child: Text(sex))).toList(),
          onChanged: (value) => setState(() => sex = value),
        ),
        SizedBox(height: 8),

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
        SizedBox(height: 8),
        TextField(
          controller: passwordController,
          focusNode: passwordFocus,
          decoration: const InputDecoration(labelText: 'Senha'),
          obscureText: true,
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            // Fechar o teclado
            FocusScope.of(context).unfocus();
          },
        ),
        const SizedBox(height: 24),
        widget.state is UserRegisterLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: () => _submitForm(context), child: const Text('Cadastrar')),
      ],
    );
  }
}
