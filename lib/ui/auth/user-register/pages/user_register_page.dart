import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_state.dart';
import 'package:loca_student/bloc/user-type/user_type_cubit.dart';
import 'package:loca_student/ui/auth/user-register/widgets/republic_form_widget.dart';
import 'package:loca_student/ui/auth/user-register/widgets/student_form_widget.dart';

class UserRegisterPage extends StatelessWidget {
  const UserRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userType = context.watch<UserTypeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(userType == UserType.student ? 'Cadastro Estudante' : 'Cadastro Proprietário'),
      ),
      body: BlocConsumer<UserRegisterBloc, UserRegisterState>(
        listener: (context, state) {
          if (state is UserRegisterSuccess) {
            Navigator.of(context).pop();
          } else if (state is UserRegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  userType == UserType.student
                      ? 'Preencha os dados para estudante'
                      : 'Preencha os dados para proprietário',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                userType == UserType.student
                    ? StudentFormWidget(state: state)
                    : RepublicFormWidget(state: state),
                if (state is UserRegisterLoading) ...[
                  const SizedBox(height: 24),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
