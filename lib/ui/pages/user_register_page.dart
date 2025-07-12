import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_event.dart';
import 'package:loca_student/bloc/auth/user_register_state.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/ui/pages/home_page.dart';

class UserRegisterPage extends StatelessWidget {
  const UserRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<UserTypeCubit>().state;
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final degreeController = TextEditingController();
    final originController = TextEditingController();
    String? sex; // Para o DropdownButton
    final universityController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final typeController = TextEditingController();
    final valueController = TextEditingController();
    final addressController = TextEditingController();

    // Criar FocusNodes para cada TextField
    final nameFocus = FocusNode();
    final ageFocus = FocusNode();
    final degreeFocus = FocusNode();
    final originFocus = FocusNode();
    final universityFocus = FocusNode();
    final typeFocus = FocusNode();
    final valueFocus = FocusNode();
    final addressFocus = FocusNode();
    final emailFocus = FocusNode();
    final passwordFocus = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userType == UserType.estudante ? 'Cadastro Estudante' : 'Cadastro Proprietário',
        ),
      ),
      body: BlocConsumer<UserRegisterBloc, UserRegisterState>(
        listener: (context, state) {
          if (state is UserRegisterSuccess) {
            Navigator.of(
              context,
            ).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
          } else if (state is UserRegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userType == UserType.estudante
                      ? 'Preencha os dados para estudante'
                      : 'Preencha os dados para proprietário',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  focusNode: nameFocus,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(
                      context,
                    ).requestFocus(userType == UserType.estudante ? ageFocus : typeFocus);
                  },
                ),
                if (userType == UserType.estudante) ...[
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
                  TextField(
                    controller: degreeController,
                    focusNode: degreeFocus,
                    decoration: const InputDecoration(labelText: 'Grau a cursar'),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(originFocus);
                    },
                  ),
                  TextField(
                    controller: originController,
                    focusNode: originFocus,
                    decoration: const InputDecoration(labelText: 'De onde vem'),
                    textInputAction: TextInputAction.done,
                    onEditingComplete: () {
                      // Não move o foco para o dropdown "Sexo", apenas fecha o teclado
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Sexo'),
                    value: sex,
                    items: [
                      'Masculino',
                      'Feminino',
                      'Outro',
                    ].map((sex) => DropdownMenuItem(value: sex, child: Text(sex))).toList(),
                    onChanged: (value) => sex = value,
                    // O usuário toca manualmente no dropdown
                  ),
                  TextField(
                    controller: universityController,
                    focusNode: universityFocus,
                    decoration: const InputDecoration(labelText: 'Universidade'),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(emailFocus);
                    },
                  ),
                ],
                if (userType == UserType.proprietario) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Tipo de imóvel'),
                    value: typeController.text.isEmpty ? null : typeController.text,
                    items: [
                      'Alojamento Estudantil',
                      'República',
                    ].map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                    onChanged: (value) => typeController.text = value ?? '',
                    // O usuário toca manualmente no dropdown
                  ),
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
                  TextField(
                    controller: addressController,
                    focusNode: addressFocus,
                    decoration: const InputDecoration(labelText: 'Endereço'),
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(emailFocus);
                    },
                  ),
                ],
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
                    // Disparar a ação de cadastro ao pressionar "Concluído"
                    if (_validateFields(
                      context,
                      userType,
                      nameController,
                      ageController,
                      degreeController,
                      originController,
                      sex,
                      universityController,
                      typeController,
                      valueController,
                      addressController,
                      emailController,
                      passwordController,
                    )) {
                      context.read<UserRegisterBloc>().add(
                        UserRegisterSubmitted(
                          name: nameController.text.trim(),
                          age: userType == UserType.estudante
                              ? int.tryParse(ageController.text.trim()) ?? 0
                              : null,
                          degree: userType == UserType.estudante
                              ? degreeController.text.trim()
                              : null,
                          origin: userType == UserType.estudante
                              ? originController.text.trim()
                              : null,
                          sex: userType == UserType.estudante ? sex : null,
                          university: userType == UserType.estudante
                              ? universityController.text.trim()
                              : null,
                          propertyType: userType == UserType.proprietario
                              ? typeController.text.trim()
                              : null,
                          value: userType == UserType.proprietario
                              ? double.tryParse(valueController.text.trim()) ?? 0.0
                              : null,
                          address: userType == UserType.proprietario
                              ? addressController.text.trim()
                              : null,
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context: context,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                state is UserRegisterLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () {
                          if (_validateFields(
                            context,
                            userType,
                            nameController,
                            ageController,
                            degreeController,
                            originController,
                            sex,
                            universityController,
                            typeController,
                            valueController,
                            addressController,
                            emailController,
                            passwordController,
                          )) {
                            context.read<UserRegisterBloc>().add(
                              UserRegisterSubmitted(
                                name: nameController.text.trim(),
                                age: userType == UserType.estudante
                                    ? int.tryParse(ageController.text.trim()) ?? 0
                                    : null,
                                degree: userType == UserType.estudante
                                    ? degreeController.text.trim()
                                    : null,
                                origin: userType == UserType.estudante
                                    ? originController.text.trim()
                                    : null,
                                sex: userType == UserType.estudante ? sex : null,
                                university: userType == UserType.estudante
                                    ? universityController.text.trim()
                                    : null,
                                propertyType: userType == UserType.proprietario
                                    ? typeController.text.trim()
                                    : null,
                                value: userType == UserType.proprietario
                                    ? double.tryParse(valueController.text.trim()) ?? 0.0
                                    : null,
                                address: userType == UserType.proprietario
                                    ? addressController.text.trim()
                                    : null,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                context: context,
                              ),
                            );
                          }
                        },
                        child: const Text('Cadastrar'),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _validateFields(
    BuildContext context,
    UserType? userType,
    TextEditingController nameController,
    TextEditingController ageController,
    TextEditingController degreeController,
    TextEditingController originController,
    String? sex,
    TextEditingController universityController,
    TextEditingController typeController,
    TextEditingController valueController,
    TextEditingController addressController,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nome, email e senha são obrigatórios')));
      return false;
    }
    if (userType == UserType.estudante &&
        (ageController.text.trim().isEmpty ||
            degreeController.text.trim().isEmpty ||
            originController.text.trim().isEmpty ||
            sex == null ||
            universityController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos para estudante')));
      return false;
    }
    if (userType == UserType.proprietario &&
        (typeController.text.trim().isEmpty ||
            valueController.text.trim().isEmpty ||
            addressController.text.trim().isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Preencha todos os campos para proprietário')));
      return false;
    }
    return true;
  }
}
