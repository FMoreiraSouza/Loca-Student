import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/profile/profile_cubit.dart';
import 'package:loca_student/bloc/profile/profile_state.dart';
import 'package:loca_student/data/repositories/profile_repository.dart';
import 'package:loca_student/ui/user_type/pages/user_type_page.dart';
import 'package:loca_student/ui/profile/widgets/republic_profile_widget.dart';
import 'package:loca_student/ui/profile/widgets/student_profile_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(profileRepository: ProfileRepository())..loadProfile(),
      child: Scaffold(
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
            final isLoading = state.status == ProfileStatus.loading;
            return Stack(
              children: [
                _buildProfileContent(context, state),
                if (isLoading)
                  Container(
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileState state) {
    if (state.status == ProfileStatus.failure) {
      return Center(child: Text('Erro: ${state.errorMessage}'));
    } else if (state.status == ProfileStatus.success) {
      final data = state.profileData!;
      final userType = data['userType'] ?? '';

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Nome: ${data['name'] ?? 'Não informado'}', style: const TextStyle(fontSize: 18)),
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
    } else {
      return const SizedBox();
    }
  }
}
