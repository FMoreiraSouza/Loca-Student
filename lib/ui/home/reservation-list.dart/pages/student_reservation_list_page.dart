import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/student/student_reservation_list_cubit.dart';
import 'package:loca_student/bloc/home/student/student_reservation_list_event.dart';

class StudentReservationListPage extends StatefulWidget {
  const StudentReservationListPage({super.key});

  @override
  State<StudentReservationListPage> createState() => _StudentReservationListPageState();
}

class _StudentReservationListPageState extends State<StudentReservationListPage> {
  @override
  void initState() {
    super.initState();
    context.read<StudentReservationListCubit>().fetchReservations();
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
                leading: const Icon(Icons.assignment_turned_in_outlined),
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
                        color: status == 'pendente' ? Colors.orange : Colors.green,
                      ),
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
