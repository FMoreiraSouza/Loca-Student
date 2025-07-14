import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/student/student_home_cubit.dart';
import 'package:loca_student/bloc/home/student/student_reservation_list_cubit.dart';
import 'package:loca_student/data/repositories/home_repository.dart';
import 'package:loca_student/ui/home/reservation-list.dart/widgets/student_reservation_list_widget.dart';
import 'package:loca_student/ui/profile/pages/profile_page.dart';
import 'package:loca_student/ui/home/widgets/student_home_widget.dart';
import 'package:loca_student/ui/about/pages/about_page.dart'; // <- Certifique-se de criar/importar essa página

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
      appBar: AppBar(
        title: const Text('Olá, Estudante 👋'),
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
          BlocProvider(
            create: (_) => StudentHomeCubit(HomeRepository()),
            child: const StudentHomeWidget(),
          ),
          const StudentReservationListWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            context.read<StudentReservationListCubit>().fetchReservations();
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Repúblicas'),
          BottomNavigationBarItem(icon: Icon(Icons.add_home_work), label: 'Minhas reservas'),
        ],
      ),
    );
  }
}
