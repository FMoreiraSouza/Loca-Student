import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/student/student_home_cubit.dart';
import 'package:loca_student/bloc/home/student/student_home_state.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/utils/calculate_coordinates.dart';
import 'package:loca_student/utils/mock_universities.dart';

class StudentHomeWidget extends StatefulWidget {
  const StudentHomeWidget({super.key});

  @override
  State<StudentHomeWidget> createState() => _StudentHomeWidgetState();
}

class _StudentHomeWidgetState extends State<StudentHomeWidget> {
  final TextEditingController _searchController = TextEditingController();

  void _showRepublicDetailsDialog(RepublicModel rep) {
    final distanceMessages = getNearbyUniversitiesDistanceMessages(
      latitude: rep.latitude,
      longitude: rep.longitude,
      universities: mockUniversities,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(rep.username),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Endereço: ${rep.address}'),
                Text('Valor: R\$${rep.value.toStringAsFixed(2)}/mês'),
                const SizedBox(height: 8),
                Text('Vagas disponíveis: ${rep.vacancies}'),
                const SizedBox(height: 8),
                Text('Telefone: ${rep.phone}'),
                const SizedBox(height: 8),
                if (distanceMessages.isNotEmpty)
                  ...distanceMessages.map(
                    (msg) => Text(
                      msg,
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Fecha o diálogo
                await _reserveSpot(rep);
              },
              child: const Text('Fazer Reserva'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _reserveSpot(RepublicModel rep) async {
    final cubit = context.read<StudentHomeCubit>();

    try {
      await cubit.reserveSpot(rep);

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reserva realizada com sucesso')));

        // Atualiza a lista após reserva
        cubit.searchRepublicsByCity(rep.city);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao reservar: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      final texto = _searchController.text.trim();
      if (texto.isEmpty) {
        context.read<StudentHomeCubit>().clearRepublics();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String text) {
    final city = text.trim();
    if (city.isNotEmpty) {
      context.read<StudentHomeCubit>().searchRepublicsByCity(city);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            onSubmitted: _onSearchSubmitted,
            decoration: InputDecoration(
              hintText: 'Onde você procura?',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<StudentHomeCubit, StudentHomeState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.error != null) {
                return Center(child: Text(state.error!));
              }

              if (state.republics.isEmpty) {
                return const Center(child: Text('Nenhum alojamento encontrado'));
              }

              return ListView.builder(
                itemCount: state.republics.length,
                itemBuilder: (context, index) {
                  final rep = state.republics[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.home),
                      title: Text(rep.username),
                      subtitle: Text('${rep.address} • R\$${rep.value.toStringAsFixed(2)}/mês'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _showRepublicDetailsDialog(rep),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
