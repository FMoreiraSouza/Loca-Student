import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/republic_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_state.dart';

class RepublicFormWidget extends StatefulWidget {
  final UserRegisterState state;
  const RepublicFormWidget({super.key, required this.state});

  @override
  RepublicFormWidgetState createState() => RepublicFormWidgetState();
}

class RepublicFormWidgetState extends State<RepublicFormWidget> {
  final nameController = TextEditingController();
  final valueController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final emailController = TextEditingController();
  final vacanciesController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final nameFocus = FocusNode();
  final valueFocus = FocusNode();
  final addressFocus = FocusNode();
  final cityFocus = FocusNode();
  final stateFocus = FocusNode();
  final emailFocus = FocusNode();
  final vacanciesFocus = FocusNode();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();

  @override
  void dispose() {
    for (final controller in [
      nameController,
      valueController,
      addressController,
      cityController,
      stateController,
      emailController,
      vacanciesController,
      phoneController,
      passwordController,
    ]) {
      controller.dispose();
    }

    for (final focus in [
      nameFocus,
      valueFocus,
      addressFocus,
      cityFocus,
      stateFocus,
      emailFocus,
      vacanciesFocus,
      phoneFocus,
      passwordFocus,
    ]) {
      focus.dispose();
    }
    super.dispose();
  }

  void _onSubmit() {
    context.read<UserRegisterBloc>().add(
      RepublicRegisterSubmitted(
        name: nameController.text.trim(),
        value: double.tryParse(valueController.text.trim()) ?? 0.0,
        address: addressController.text.trim(),
        city: cityController.text.trim(),
        state: stateController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        vacancies: int.tryParse(vacanciesController.text.trim()) ?? 0,
        phone: phoneController.text.trim(),
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
          onEditingComplete: () => FocusScope.of(context).requestFocus(valueFocus),
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: valueController,
          focusNode: valueFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(addressFocus),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Valor (R\$)'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: addressController,
          focusNode: addressFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(cityFocus),
          decoration: const InputDecoration(labelText: 'Endereço'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: cityController,
          focusNode: cityFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(stateFocus),
          decoration: const InputDecoration(labelText: 'Cidade'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: stateController,
          focusNode: stateFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(emailFocus),
          decoration: const InputDecoration(labelText: 'Estado'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          focusNode: emailFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(vacanciesFocus),
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: vacanciesController,
          focusNode: vacanciesFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(phoneFocus),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Vagas'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: phoneController,
          focusNode: phoneFocus,
          textInputAction: TextInputAction.next,
          onEditingComplete: () => FocusScope.of(context).requestFocus(passwordFocus),
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'Telefone'),
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
