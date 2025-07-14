import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/republic/republic_reservation_list_cubit.dart';
import 'package:loca_student/bloc/home/republic/republic_reservation_list_state.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentsWidget extends StatefulWidget {
  const InterestStudentsWidget({super.key, required this.currentUser});

  final ParseObject currentUser;

  @override
  State<InterestStudentsWidget> createState() => _InterestStudentsWidgetState();
}

class _InterestStudentsWidgetState extends State<InterestStudentsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<InterestStudentsCubit>().loadInterestStudents(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterestStudentsCubit, InterestStudentsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('Erro ao carregar interessados:\n${state.error}'));
        }

        if (state.interestedStudents.isEmpty) {
          return const Center(child: Text('Nenhum estudante interessado encontrado'));
        }

        return ListView.builder(
          itemCount: state.interestedStudents.length,
          itemBuilder: (context, index) {
            final student = state.interestedStudents[index];
            final studentName = student.get<String>('studentName') ?? 'Nome não informado';
            final studentEmail = student.get<String>('studentEmail') ?? 'Email não informado';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(studentEmail),
              ),
            );
          },
        );
      },
    );
  }
}
