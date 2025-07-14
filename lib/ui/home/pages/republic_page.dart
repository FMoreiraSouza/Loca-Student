import 'package:flutter/material.dart';
import 'package:loca_student/ui/profile/pages/profile_page.dart';

class RepublicPage extends StatefulWidget {
  const RepublicPage({super.key});

  @override
  State<RepublicPage> createState() => _RepublicPageState();
}

class _RepublicPageState extends State<RepublicPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Olá, Proprietário 👋'), automaticallyImplyLeading: false),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Center(child: Text('Reservas')),
          const Center(child: Text('Inquilinos')),
          const Center(child: Text('Notificações')),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Inquilinos'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificações'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
