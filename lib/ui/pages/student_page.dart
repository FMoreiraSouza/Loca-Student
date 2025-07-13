import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/student/student_home_cubit.dart';
import 'package:loca_student/ui/pages/profile_page.dart';
import 'package:loca_student/ui/pages/student_body.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Olá, Estudante 👋'), automaticallyImplyLeading: false),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Só provê o Cubit na aba de Início
          BlocProvider(
            create: (_) => StudentHomeCubit()..loadAlojamentos(),
            child: const StudentHomeBody(),
          ),
          const Center(child: Text('Notificações')),
          const Center(child: Text('Minhas reservas')),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Repúblicas'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Notificações'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Minhas reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
