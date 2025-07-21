import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/student_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_state.dart';
import 'package:loca_student/utils/validators.dart';
import 'package:loca_student/utils/format_methods.dart';

class StudentFormWidget extends StatefulWidget {
  final UserRegisterState state;
  const StudentFormWidget({super.key, required this.state});

  @override
  StudentFormWidgetState createState() => StudentFormWidgetState();
}

class StudentFormWidgetState extends State<StudentFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final originController = TextEditingController();
  final phoneController = TextEditingController();

  final passwordFocus = FocusNode();
  final emailFocus = FocusNode();
  final ageFocus = FocusNode();
  final originFocus = FocusNode();
  final phoneFocus = FocusNode();

  String? selectedGenre;

  @override
  void dispose() {
    for (final controller in [
      nameController,
      emailController,
      passwordController,
      ageController,
      originController,
      phoneController,
    ]) {
      controller.dispose();
    }
    for (final focus in [emailFocus, passwordFocus, ageFocus, originFocus, phoneFocus]) {
      focus.dispose();
    }
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UserRegisterBloc>().add(
        StudentRegisterSubmitted(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          age: int.tryParse(ageController.text.trim()) ?? 0,
          origin: originController.text.trim(),
          phone: phoneController.text.replaceAll(RegExp(r'\D'), ''),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.state is UserRegisterLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(emailFocus),
            decoration: const InputDecoration(labelText: 'Nome'),
            validator: (v) => Validators.requiredField(v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: emailController,
            focusNode: emailFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFocus),
            decoration: const InputDecoration(labelText: 'Email'),
            validator: Validators.email,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: passwordController,
            focusNode: passwordFocus,
            textInputAction: TextInputAction.next,
            obscureText: true,
            onEditingComplete: () => FocusScope.of(context).requestFocus(ageFocus),
            decoration: const InputDecoration(labelText: 'Senha'),
            validator: (v) => Validators.password(v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: ageController,
            focusNode: ageFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            onEditingComplete: () => FocusScope.of(context).requestFocus(originFocus),
            decoration: const InputDecoration(labelText: 'Idade'),
            validator: Validators.age,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: originController,
            focusNode: originFocus,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(phoneFocus),
            decoration: const InputDecoration(labelText: 'Origem'),
            validator: (v) => Validators.requiredField(v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: phoneController,
            focusNode: phoneFocus,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              final masked = FormatMethods().applyPhoneMask(value);
              if (masked != value) {
                phoneController.value = TextEditingValue(
                  text: masked,
                  selection: TextSelection.collapsed(offset: masked.length),
                );
              }
            },
            decoration: const InputDecoration(labelText: 'Telefone'),
            validator: Validators.phone,
          ),
          const SizedBox(height: 24),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else
            ElevatedButton(onPressed: _onSubmit, child: const Text('Cadastrar')),
        ],
      ),
    );
  }
}
