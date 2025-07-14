import 'package:flutter/material.dart';
import 'package:loca_student/ui/home/reservation-list.dart/widgets/republic_reservation_list_widget.dart';
import 'package:loca_student/ui/profile/pages/profile_page.dart';
import 'package:loca_student/ui/about/pages/about_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RepublicPage extends StatefulWidget {
  const RepublicPage({super.key});

  @override
  State<RepublicPage> createState() => _RepublicPageState();
}

class _RepublicPageState extends State<RepublicPage> {
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
        title: const Text('Olá, Proprietário 👋'),
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
          InterestStudentsWidget(currentUser: _currentUser!),
          const Center(child: Text('Inquilinos')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Inquilinos'),
        ],
      ),
    );
  }
}
