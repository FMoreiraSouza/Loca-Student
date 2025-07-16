import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/student-home/filtered_republic_list_cubit.dart';
import 'package:loca_student/bloc/student-home/filtered_republic_list_state.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/utils/calculate_coordinates.dart';
import 'package:loca_student/utils/mock_universities.dart';

class FilteredRepublicListWidget extends StatefulWidget {
  const FilteredRepublicListWidget({super.key});

  @override
  State<FilteredRepublicListWidget> createState() => _FilteredRepublicListWidgetState();
}

class _FilteredRepublicListWidgetState extends State<FilteredRepublicListWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      final texto = _searchController.text.trim();
      if (texto.isEmpty) {
        context.read<FilteredRepublicListCubit>().clearRepublics();
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
      context.read<FilteredRepublicListCubit>().searchRepublicsByCity(city);
    }
  }

  Future<void> _reserveSpot(RepublicModel rep) async {
    final cubit = context.read<FilteredRepublicListCubit>();
    try {
      await cubit.reserveSpot(rep);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Reserva realizada com sucesso')));
      cubit.searchRepublicsByCity(rep.city);
    } catch (e) {
      if (!mounted) return;
      final errorMsg = e.toString();
      final isDuplicate = errorMsg.contains('já fez uma reserva');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isDuplicate ? 'Você já fez essa reserva!' : 'Erro ao reservar: $errorMsg'),
        ),
      );
    }
  }

  void _showRepublicDetailsDialog(RepublicModel rep) {
    final distanceMessages = getNearbyUniversitiesDistanceMessages(
      latitude: rep.latitude,
      longitude: rep.longitude,
      universities: mockUniversities,
    );
    final hasNoVacancies = rep.vacancies == 0;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(rep.username),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Endereço: ${rep.address}'),
              Text('Valor: R\$${rep.value.toStringAsFixed(2)}/mês'),
              const SizedBox(height: 8),
              if (hasNoVacancies)
                const Text(
                  'Não há mais vagas nessa república',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )
              else
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
          if (!hasNoVacancies)
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _reserveSpot(rep);
              },
              child: const Text('Fazer Reserva'),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(FilteredRepublicListState state) {
    switch (state.status) {
      case FilteredRepublicListStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case FilteredRepublicListStatus.error:
        return Center(child: Text(state.error ?? 'Erro desconhecido'));
      case FilteredRepublicListStatus.empty:
        return const Center(child: Text('Nenhum alojamento encontrado'));
      case FilteredRepublicListStatus.success:
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
      default:
        return const SizedBox.shrink();
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
          child: BlocBuilder<FilteredRepublicListCubit, FilteredRepublicListState>(
            builder: (context, state) => _buildContent(state),
          ),
        ),
      ],
    );
  }
}
