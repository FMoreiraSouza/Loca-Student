﻿import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/student-home/student_reservation_list_cubit.dart';
import 'package:loca_student/ui/student-home/widgets/student_reservation_list_widget.dart';
import 'package:loca_student/ui/profile/pages/profile_page.dart';
import 'package:loca_student/ui/student-home/widgets/filtered_republic_list_widget.dart';
import 'package:loca_student/ui/about/pages/about_page.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      context.read<StudentReservationListCubit>().fetchReservations();
    }
  }

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
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Perfil',
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage())),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [FilteredRepublicListWidget(), StudentReservationListWidget()],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabChanged,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_work), label: 'Repúblicas'),
            BottomNavigationBarItem(icon: Icon(Icons.add_home_work), label: 'Minhas reservas'),
          ],
        ),
      ),
    );
  }
}
