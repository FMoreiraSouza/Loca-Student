﻿import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_cubit.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_state.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// InterestStudentListWidget
class InterestStudentListWidget extends StatefulWidget {
  const InterestStudentListWidget({super.key, required this.currentUser});

  final ParseUser currentUser;

  @override
  State<InterestStudentListWidget> createState() => _InterestStudentListWidgetState();
}

class _InterestStudentListWidgetState extends State<InterestStudentListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<InterestStudentListCubit>().loadInterestStudents(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InterestStudentListCubit, InterestStudentListState>(
      builder: (context, state) {
        switch (state.status) {
          case InterestStudentStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case InterestStudentStatus.error:
            return Center(child: Text('Erro ao carregar interessados:\n${state.error}'));
          case InterestStudentStatus.empty:
            return const Center(child: Text('Nenhum estudante interessado encontrado'));
          case InterestStudentStatus.success:
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
                                    .read<InterestStudentListCubit>()
                                    .updateInterestStudentStatus(
                                      interestId: interested.objectId,
                                      studentId: interested.studentId,
                                      republicId: interested.republicId,
                                      currentUser: widget.currentUser,
                                    );
                              },
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Não'),
                            ),

                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                context.read<InterestStudentListCubit>().acceptInterestedStudent(
                                  interestId: interested.objectId,
                                  studentId: interested.studentId,
                                  republicId: interested.republicId,
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
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
