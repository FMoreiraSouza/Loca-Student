import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/republic/student_interested_list_cubit.dart';
import 'package:loca_student/bloc/home/republic/student_interested_list_state.dart';
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
            final interested = state.interestedStudents[index];
            final studentName = interested.get<String>('studentName') ?? 'Nome não informado';
            final student = interested.get<ParseObject>('student');
            final republic = interested.get<ParseObject>('republic');

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'O estudante $studentName solicitou entrada na república. Aceitar?',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final cubit = context.read<InterestStudentsCubit>();

                            final studentObj = student!;
                            final republicObj = republic!;

                            // Atualiza status na tabela Reservations
                            await cubit.updateReservationWithoutReload(
                              studentObj,
                              republicObj,
                              'recusado',
                            );

                            // Atualiza status na tabela InterestStudents
                            await cubit.updateInterestStudentStatus(interested, 'recusado');

                            // Remove da lista local
                            cubit.removeInterested(interested);
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                          child: const Text('Não'),
                        ),

                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () async {
                            final cubit = context.read<InterestStudentsCubit>();
                            await cubit.acceptInterestedStudent(
                              interested,
                              student!,
                              republic!,
                              widget.currentUser,
                            );
                          },
                          style: TextButton.styleFrom(foregroundColor: Colors.green),
                          child: const Text('Sim'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
