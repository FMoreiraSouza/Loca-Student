import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/student_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_state.dart';

class StudentFormWidget extends StatefulWidget {
  final UserRegisterState state;
  const StudentFormWidget({super.key, required this.state});

  @override
  StudentFormWidgetState createState() => StudentFormWidgetState();
}

class StudentFormWidgetState extends State<StudentFormWidget> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final degreeController = TextEditingController();
  final originController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameFocus = FocusNode();
  final ageFocus = FocusNode();
  final degreeFocus = FocusNode();
  final originFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  String? selectedSex;

  @override
  void dispose() {
    for (final controller in [
      nameController,
      ageController,
      degreeController,
      originController,
      emailController,
      passwordController,
    ]) {
      controller.dispose();
    }
    for (final focus in [
      nameFocus,
      ageFocus,
      degreeFocus,
      originFocus,
      emailFocus,
      passwordFocus,
    ]) {
      focus.dispose();
    }
    super.dispose();
  }

  void _onSubmit() {
    context.read<UserRegisterBloc>().add(
      StudentRegisterSubmitted(
        name: nameController.text.trim(),
        age: int.tryParse(ageController.text.trim()) ?? 0,
        degree: degreeController.text.trim(),
        origin: originController.text.trim(),
        sex: selectedSex ?? '',
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state is UserRegisterLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameController,
          focusNode: nameFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(ageFocus),
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ageController,
          focusNode: ageFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(degreeFocus),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Idade'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: degreeController,
          focusNode: degreeFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(originFocus),
          decoration: const InputDecoration(labelText: 'Grau a cursar'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: originController,
          focusNode: originFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(emailFocus),
          decoration: const InputDecoration(labelText: 'De onde vem'),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedSex,
          decoration: const InputDecoration(labelText: 'Sexo'),
          items: const [
            DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
            DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
            DropdownMenuItem(value: 'Outro', child: Text('Outro')),
          ],
          onChanged: (value) => setState(() => selectedSex = value),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          focusNode: emailFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFocus),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: passwordController,
          focusNode: passwordFocus,
          textInputAction: TextInputAction.done,
          onEditingComplete: () => FocusScope.of(context).unfocus(),
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Senha'),
        ),
        const SizedBox(height: 24),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else
          ElevatedButton(onPressed: _onSubmit, child: const Text('Cadastrar')),
      ],
    );
  }
}
