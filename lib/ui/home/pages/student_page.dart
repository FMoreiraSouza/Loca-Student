import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/student/student_home_cubit.dart';
import 'package:loca_student/data/repositories/home_repository.dart';
import 'package:loca_student/ui/home/reservation-list.dart/pages/student_reservation_list_page.dart';
import 'package:loca_student/ui/profile/pages/profile_page.dart';
import 'package:loca_student/ui/home/widgets/student_home_widget.dart';

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
          BlocProvider(
            create: (_) => StudentHomeCubit(HomeRepository()),
            child: const StudentHomeWidget(),
          ),
          const StudentReservationListPage(), // <- Aqui está a tela anexada corretamente
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
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Repúblicas'),
          BottomNavigationBarItem(icon: Icon(Icons.add_home_work), label: 'Minhas reservas'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notificações'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
