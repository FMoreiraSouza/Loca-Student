import 'package:flutter/material.dart';
import 'package:loca_student/ui/pages/profile_page.dart';

class OwnerPage extends StatefulWidget {
  const OwnerPage({super.key});

  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Olá, Proprietário 👋'), automaticallyImplyLeading: false),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const Center(child: Text('Reservas')),
          const Center(child: Text('Notificações')),
          const Center(child: Text('Inquilinos')),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Notificações'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Inquilinos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
