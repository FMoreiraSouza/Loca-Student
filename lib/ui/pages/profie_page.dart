import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/profile/profile_cubit.dart';
import 'package:loca_student/bloc/profile/profile_state.dart';
import 'package:loca_student/data/repositories/profile_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileRepository())..loadProfile(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.initial) {
              // Exemplo: após logout, volta para a primeira tela
              Navigator.of(context).popUntil((route) => route.isFirst);
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
            const SizedBox(height: 8),
            Text(
              'Tipo: ${data['userType'] ?? 'Não informado'}',
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 32),
            if (data['userType'] == 'estudante') ...[
              Text('Idade: ${data['age'] ?? 'Não informado'}'),
              Text('Curso: ${data['degree'] ?? 'Não informado'}'),
              Text('Origem: ${data['origin'] ?? 'Não informado'}'),
              Text('Sexo: ${data['sex'] ?? 'Não informado'}'),
              Text('Universidade: ${data['university'] ?? 'Não informado'}'),
            ] else if (data['userType'] == 'proprietario') ...[
              Text('Tipo de imóvel: ${data['propertyType'] ?? 'Não informado'}'),
              Text('Valor: R\$${data['value']?.toStringAsFixed(2) ?? 'Não informado'}'),
              Text('Endereço: ${data['address'] ?? 'Não informado'}'),
            ],
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                context.read<ProfileCubit>().logout();
              },
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
