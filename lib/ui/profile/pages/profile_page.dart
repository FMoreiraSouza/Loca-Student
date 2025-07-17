import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/profile/profile_cubit.dart';
import 'package:loca_student/bloc/profile/profile_state.dart';
import 'package:loca_student/ui/user_type/pages/user_type_page.dart';
import 'package:loca_student/ui/profile/widgets/republic_profile_widget.dart';
import 'package:loca_student/ui/profile/widgets/student_profile_widget.dart';
import 'package:loca_student/utils/parse_configs.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ParseUser _currentUser;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await ParseConfigs.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _currentUser = user;
      _isLoadingUser = false;
    });
    context.read<ProfileCubit>().loadProfile(user);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ProfileCubit>().logout(_currentUser);
        },
        tooltip: 'Sair',
        child: const Icon(Icons.exit_to_app),
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
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
