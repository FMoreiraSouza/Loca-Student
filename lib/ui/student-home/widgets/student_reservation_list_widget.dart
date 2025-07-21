import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/student-home/student_reservation_list_cubit.dart';
import 'package:loca_student/bloc/student-home/student_reservation_list_state.dart';
import 'package:loca_student/utils/states/empty_state_widget.dart';
import 'package:loca_student/utils/states/initial_state_widget.dart';

class StudentReservationListWidget extends StatelessWidget {
  const StudentReservationListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentReservationListCubit, StudentReservationListState>(
      builder: (context, state) {
        switch (state.status) {
          case ReservationListStatus.initial:
            return const InitialStateWidget(message: 'Digite uma cidade para buscar reservas');
          case ReservationListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case ReservationListStatus.empty:
            return const EmptyStateWidget(message: 'Nenhuma reserva encontrada');
          case ReservationListStatus.success:
            return ListView.builder(
              itemCount: state.reservations.length,
              itemBuilder: (context, index) {
                final reservation = state.reservations[index];
                final republicValue = reservation.value;
                final status = reservation.status;
                final city = reservation.city;
                final stateStr = reservation.state;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      reservation.republicUsername.isNotEmpty
                          ? reservation.republicUsername
                          : 'República sem nome',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${reservation.address} • $city - $stateStr'),
                        Text('R\$ ${republicValue.toStringAsFixed(2)}/mês'),
                        const SizedBox(height: 4),
                        Text(
                          'Status: ${status[0].toUpperCase()}${status.substring(1)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: status == 'pendente'
                                ? Colors.orange
                                : status == 'recusada'
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (status == 'recusada') ...[
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            tooltip: 'Cancelar reserva',
                            onPressed: () {
                              context.read<StudentReservationListCubit>().cancelReservation(
                                reservation.id,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.blue),
                            tooltip: 'Reenviar solicitação',
                            onPressed: () {
                              context.read<StudentReservationListCubit>().resendReserve(
                                reservation.id,
                              );
                            },
                          ),
                        ] else ...[
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            tooltip: 'Cancelar reserva',
                            onPressed: () {
                              context.read<StudentReservationListCubit>().cancelReservation(
                                reservation.id,
                              );
                            },
                          ),
                        ],
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
