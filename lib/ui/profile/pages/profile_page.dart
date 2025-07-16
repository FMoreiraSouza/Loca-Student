// lib/ui/profile/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/profile/profile_cubit.dart';
import 'package:loca_student/bloc/profile/profile_state.dart';
import 'package:loca_student/ui/user_type/pages/user_type_page.dart';
import 'package:loca_student/ui/profile/widgets/republic_profile_widget.dart';
import 'package:loca_student/ui/profile/widgets/student_profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.initial) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const UserTypePage()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              _buildContent(context, state),
              if (state.status == ProfileStatus.loading)
                Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileState state) {
    switch (state.status) {
      case ProfileStatus.failure:
        return Center(child: Text('Erro: ${state.errorMessage}'));

      case ProfileStatus.success:
        final data = state.profileData!;
        final userType = data['userType'] as String;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                'Nome: ${data['name'] ?? 'Não informado'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${data['email'] ?? 'Não informado'}',
                style: const TextStyle(fontSize: 16),
              ),
              const Divider(height: 32),
              if (userType == 'estudante')
                StudentProfileWidget(data: data)
              else if (userType == 'proprietario')
                RepublicProfileWidget(data: data),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.read<ProfileCubit>().logout(),
                child: const Text('Sair'),
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
