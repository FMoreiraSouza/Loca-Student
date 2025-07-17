import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/student-home/student_reservation_list_cubit.dart';
import 'package:loca_student/bloc/student-home/student_reservation_list_state.dart';

class StudentReservationListWidget extends StatelessWidget {
  const StudentReservationListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentReservationListCubit, StudentReservationListState>(
      builder: (context, state) {
        if (state.status == ReservationListStatus.initial ||
            state.status == ReservationListStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ReservationListStatus.error) {
          return Center(child: Text('Erro ao carregar reservas:\n${state.error}'));
        }
        if (state.status == ReservationListStatus.empty) {
          return const Center(child: Text('Nenhuma reserva encontrada'));
        }
        if (state.status == ReservationListStatus.success) {
          return ListView.builder(
            itemCount: state.reservations.length,
            itemBuilder: (context, index) {
              final reservation = state.reservations[index];
              final republicAddress = reservation.address;
              final republicValue = reservation.value;
              final status = reservation.status;
              final city = reservation.city;
              final stateStr = reservation.state;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(republicAddress, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(republicAddress),
                      Text('$city - $stateStr'),
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
                  trailing: IconButton(
                    icon: Icon(
                      status == 'recusada' ? Icons.refresh : Icons.cancel, // 👈 troca de ícone
                      color: status == 'recusada' ? Colors.blue : Colors.red,
                    ),
                    tooltip: status == 'recusada' ? 'Reenviar solicitação' : 'Cancelar reserva',
                    onPressed: () {
                      if (status == 'recusada') {
                        // 👇 chama método para reenviar reserva
                        context.read<StudentReservationListCubit>().resendReserve(reservation.id);
                      } else {
                        // 👇 método atual de cancelar
                        context.read<StudentReservationListCubit>().cancelReservation(
                          reservation.id,
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
