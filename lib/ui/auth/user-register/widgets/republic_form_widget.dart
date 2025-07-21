import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/republic_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_state.dart';
import 'package:loca_student/utils/format_methods.dart';
import 'package:loca_student/utils/validators.dart';

class RepublicFormWidget extends StatefulWidget {
  final UserRegisterState state;
  const RepublicFormWidget({super.key, required this.state});

  @override
  RepublicFormWidgetState createState() => RepublicFormWidgetState();
}

class RepublicFormWidgetState extends State<RepublicFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final valueController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final vacanciesController = TextEditingController();
  final phoneController = TextEditingController();

  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final valueFocus = FocusNode();
  final addressFocus = FocusNode();
  final cityFocus = FocusNode();
  final stateFocus = FocusNode();
  final vacanciesFocus = FocusNode();
  final phoneFocus = FocusNode();

  @override
  void dispose() {
    for (final controller in [
      nameController,
      emailController,
      passwordController,
      valueController,
      addressController,
      cityController,
      stateController,

      vacanciesController,
      phoneController,
    ]) {
      controller.dispose();
    }
    for (final focus in [
      emailFocus,
      passwordFocus,
      valueFocus,
      addressFocus,
      cityFocus,
      stateFocus,
      vacanciesFocus,
      phoneFocus,
    ]) {
      focus.dispose();
    }
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UserRegisterBloc>().add(
        RepublicRegisterSubmitted(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          value: double.tryParse(valueController.text.trim()) ?? 0.0,
          address: addressController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          vacancies: int.tryParse(vacanciesController.text.trim()) ?? 0,
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
            textInputAction: TextInputAction.done,
            obscureText: true,
            onEditingComplete: () => FocusScope.of(context).requestFocus(valueFocus),
            decoration: const InputDecoration(labelText: 'Senha'),
            validator: (v) => Validators.password(v, fieldName: 'Senha'),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: valueController,
            focusNode: valueFocus,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(addressFocus),
            decoration: const InputDecoration(labelText: 'Valor (R\$)'),
            validator: (v) => Validators.requiredField(v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: addressController,
            focusNode: addressFocus,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(cityFocus),
            decoration: const InputDecoration(labelText: 'Endereço'),
            validator: (v) => Validators.requiredField(v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: cityController,
            focusNode: cityFocus,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(stateFocus),
            decoration: const InputDecoration(labelText: 'Cidade'),
            validator: (v) => Validators.requiredField(v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: stateController,
            focusNode: stateFocus,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => FocusScope.of(context).requestFocus(vacanciesFocus),
            decoration: const InputDecoration(labelText: 'Estado'),
            validator: (v) => Validators.requiredField(v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: vacanciesController,
            focusNode: vacanciesFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            onEditingComplete: () => FocusScope.of(context).requestFocus(phoneFocus),
            decoration: const InputDecoration(labelText: 'Vagas'),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (v) => Validators.requiredField(v),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: phoneController,
            focusNode: phoneFocus,
            textInputAction: TextInputAction.next,
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
