import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_cubit.dart';
import 'package:loca_student/utils/parse_configs.dart';
import 'package:loca_student/ui/republic-home/widgets/tenant_list_widget.dart';
import 'package:loca_student/ui/republic-home/widgets/interested_student_list_widget.dart';
import 'package:loca_student/ui/profile/pages/profile_page.dart';
import 'package:loca_student/ui/about/pages/about_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RepublicHomePage extends StatefulWidget {
  const RepublicHomePage({super.key});

  @override
  State<RepublicHomePage> createState() => _RepublicHomePageState();
}

class _RepublicHomePageState extends State<RepublicHomePage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  ParseUser? _currentUser;

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
      _isLoading = false;
    });
  }

  // 🔥 Aqui o método para trocar de aba e disparar o fetch
  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      // 👉 Quando for para a aba de locatários, recarrega a lista
      context.read<TenantListCubit>().loadTenants(_currentUser!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
          InterestStudentListWidget(currentUser: _currentUser!),
          TenantListWidget(currentUser: _currentUser!),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged, // 👈 aqui usamos o método novo
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Interessados'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Locatários'),
        ],
      ),
    );
  }
}
