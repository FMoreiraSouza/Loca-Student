import 'package:flutter/material.dart';
import 'package:loca_student/ui/republic-home/widgets/tenant_list_widget.dart';
import 'package:loca_student/ui/republic-home/widgets/republic_home_widget.dart';
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
  ParseObject? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await ParseUser.currentUser() as ParseObject?;
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _currentUser == null) {
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
          RepublicHomeWidget(currentUser: _currentUser!),
          TenantListPage(currentUser: _currentUser!),
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
  }
}
