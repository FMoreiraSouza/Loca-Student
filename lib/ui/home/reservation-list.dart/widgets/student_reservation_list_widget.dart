import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/student/student_reservation_list_cubit.dart';
import 'package:loca_student/bloc/home/student/student_reservation_list_event.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentReservationListWidget extends StatefulWidget {
  const StudentReservationListWidget({super.key});

  @override
  State<StudentReservationListWidget> createState() => _StudentReservationListWidgetState();
}

class _StudentReservationListWidgetState extends State<StudentReservationListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<StudentReservationListCubit>().fetchReservations();
  }

  Future<void> _confirmCancelReservation(ParseObject reservation) async {
    final username = reservation.get<String>('username') ?? 'essa república';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancelar reserva'),
        content: Text('Deseja mesmo cancelar a reserva em $username?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Não')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<StudentReservationListCubit>().cancelReservation(reservation);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Reserva cancelada com sucesso')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao cancelar reserva: $e')));
        }
      }
    }
  }

  Future<void> _confirmReactivateReservation(ParseObject reservation) async {
    final username = reservation.get<String>('username') ?? 'essa república';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reativar reserva'),
        content: Text('Deseja mesmo reativar a reserva em $username?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Não')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<StudentReservationListCubit>().reactivateReservation(reservation);
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Reserva reativada com sucesso')));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erro ao reativar reserva: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentReservationListCubit, StudentReservationListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null) {
          return Center(child: Text('Erro ao carregar reservas:\n${state.error}'));
        }

        if (state.reservations.isEmpty) {
          return const Center(child: Text('Nenhuma reserva encontrada'));
        }

        return ListView.builder(
          itemCount: state.reservations.length,
          itemBuilder: (context, index) {
            final res = state.reservations[index];
            final username = res.get<String>('username') ?? 'Desconhecido';
            final address = res.get<String>('address') ?? 'Sem endereço';
            final value = (res.get<num>('value') ?? 0).toDouble();
            final city = res.get<String>('city') ?? 'Cidade não informada';
            final stateStr = res.get<String>('state') ?? 'Estado não informado';
            final status = res.get<String>('status')?.toLowerCase() ?? 'pendente';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.home),
                title: Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(address),
                    Text('$city - $stateStr'),
                    Text('R\$ ${value.toStringAsFixed(2)}/mês'),
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${status[0].toUpperCase()}${status.substring(1)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: status == 'pendente'
                            ? Colors.orange
                            : status == 'cancelado'
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
                trailing: status == 'cancelado'
                    ? IconButton(
                        icon: const Icon(Icons.assignment_turned_in_outlined, color: Colors.green),
                        onPressed: () => _confirmReactivateReservation(res),
                      )
                    : IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _confirmCancelReservation(res),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
