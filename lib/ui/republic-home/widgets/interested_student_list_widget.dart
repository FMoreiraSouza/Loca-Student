import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_cubit.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_state.dart';
import 'package:loca_student/utils/states/empty_state_widget.dart';
import 'package:loca_student/utils/states/initial_state_widget.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestedStudentListWidget extends StatefulWidget {
  const InterestedStudentListWidget({super.key, required this.currentUser});
  final ParseUser currentUser;

  @override
  State<InterestedStudentListWidget> createState() => _InterestedStudentListWidgetState();
}

class _InterestedStudentListWidgetState extends State<InterestedStudentListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<InterestedStudentListCubit>().loadInterestedStudents(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterestedStudentListCubit, InterestStudentListState>(
      builder: (context, state) {
        switch (state.status) {
          case InterestedStudentStatus.initial:
            return const InitialStateWidget(message: 'Carregando estudantes interessados');
          case InterestedStudentStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case InterestedStudentStatus.empty:
            return const EmptyStateWidget(message: 'Nenhum estudante interessado encontrado');
          case InterestedStudentStatus.success:
            return ListView.builder(
              itemCount: state.interestedStudentList.length,
              itemBuilder: (context, index) {
                final interested = state.interestedStudentList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'O estudante ${interested.studentName} solicitou entrada na república. Aceitar?',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                context
                                    .read<InterestedStudentListCubit>()
                                    .updateInterestedStudentStatus(
                                      interested: interested,
                                      currentUser: widget.currentUser,
                                    );
                              },
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Não'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                context.read<InterestedStudentListCubit>().acceptInterestedStudent(
                                  interested: interested,
                                  currentUser: widget.currentUser,
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
        }
      },
    );
  }
}
