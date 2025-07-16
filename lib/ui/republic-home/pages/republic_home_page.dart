import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/republic_home_cubit.dart';
import 'package:loca_student/bloc/republic-home/republic_home_state.dart';
import 'package:loca_student/ui/republic-home/widgets/tenant_list_widget.dart';
import 'package:loca_student/ui/republic-home/widgets/interested_student_list_widget.dart';
import 'package:loca_student/ui/profile/pages/profile_page.dart';
import 'package:loca_student/ui/about/pages/about_page.dart';

class RepublicHomePage extends StatefulWidget {
  const RepublicHomePage({super.key});

  @override
  State<RepublicHomePage> createState() => _RepublicHomePageState();
}

class _RepublicHomePageState extends State<RepublicHomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<RepublicHomeCubit>().loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RepublicHomeCubit, RepublicHomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state.error != null) {
          return Scaffold(
            appBar: AppBar(title: const Text('República')),
            body: Center(child: Text('Erro: ${state.error}')),
          );
        }
        if (state.currentUser == null) {
          return const Scaffold(body: Center(child: Text('Usuário não encontrado')));
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Olá, República 👋'),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'Sobre',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                tooltip: 'Perfil',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                },
              ),
            ],
          ),
          body: IndexedStack(
            index: _currentIndex,
            children: [
              InterestStudentListWidget(currentUser: state.currentUser!),
              TenantListWidget(currentUser: state.currentUser!),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Interessados'),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Locatários'),
            ],
          ),
        );
      },
    );
  }
}
