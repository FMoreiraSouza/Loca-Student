import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_event.dart';
import 'package:loca_student/bloc/auth/user_register_state.dart';

class OwnerForm extends StatefulWidget {
  final UserRegisterState state;

  const OwnerForm({super.key, required this.state});

  @override
  _OwnerFormState createState() => _OwnerFormState();
}

class _OwnerFormState extends State<OwnerForm> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final valueController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final vacanciesController = TextEditingController();
  final passwordController = TextEditingController();

  final nameFocus = FocusNode();
  final typeFocus = FocusNode();
  final valueFocus = FocusNode();
  final addressFocus = FocusNode();
  final emailFocus = FocusNode();
  final vacanciesFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    valueController.dispose();
    addressController.dispose();
    emailController.dispose();
    vacanciesController.dispose();
    passwordController.dispose();
    nameFocus.dispose();
    typeFocus.dispose();
    valueFocus.dispose();
    addressFocus.dispose();
    emailFocus.dispose();
    vacanciesFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  bool _validateFields(BuildContext context) {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        typeController.text.trim().isEmpty ||
        valueController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos para proprietário')));
      return false;
    }
    return true;
  }

  void _submitForm(BuildContext context) {
    if (_validateFields(context)) {
      context.read<UserRegisterBloc>().add(
        UserRegisterSubmitted(
          name: nameController.text.trim(),
          propertyType: typeController.text.trim(),
          value: double.tryParse(valueController.text.trim()) ?? 0.0,
          address: addressController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
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
            FocusScope.of(context).requestFocus(typeFocus);
          },
        ),
        SizedBox(height: 8),
        TextField(
          controller: valueController,
          focusNode: valueFocus,
          decoration: const InputDecoration(labelText: 'Valor (R\$)'),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(addressFocus);
          },
        ),
        SizedBox(height: 8),
        TextField(
          controller: addressController,
          focusNode: addressFocus,
          decoration: const InputDecoration(labelText: 'Endereço'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(emailFocus);
          },
        ),
        SizedBox(height: 8),
        TextField(
          controller: emailController,
          focusNode: emailFocus,
          decoration: const InputDecoration(labelText: 'Email'),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(vacanciesFocus);
          },
        ),
        SizedBox(height: 8),
        TextField(
          controller: vacanciesController,
          focusNode: vacanciesFocus,
          decoration: const InputDecoration(labelText: 'Vagas'),
          keyboardType: TextInputType.number,
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
          onEditingComplete: () => _submitForm(context),
        ),
        const SizedBox(height: 24),
        widget.state is UserRegisterLoading
            ? const Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: () => _submitForm(context), child: const Text('Cadastrar')),
      ],
    );
  }
}
