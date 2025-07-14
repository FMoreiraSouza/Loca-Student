import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/republic/republic_home_cubit.dart';
import 'package:loca_student/bloc/home/republic/republic_home_state.dart';

class RepublicHomeWidget extends StatefulWidget {
  const RepublicHomeWidget({super.key});

  @override
  State<RepublicHomeWidget> createState() => _RepublicHomeWidgetState();
}

class _RepublicHomeWidgetState extends State<RepublicHomeWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<RepublicHomeCubit>().filterRepublics(_searchController.text);
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Pesquisar seus Republics',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<RepublicHomeCubit, RepublicState>(
            builder: (context, state) {
              if (state is RepublicLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is RepublicError) {
                return Center(child: Text(state.message));
              }

              if (state is RepublicLoaded && state.republics.isEmpty) {
                return const Center(child: Text('Nenhum alojamento encontrado'));
              }

              if (state is! RepublicLoaded) {
                return const Center(child: Text('Nenhum dado carregado'));
              }

              final republics = state.republics;
              return ListView.builder(
                itemCount: republics.length,
                itemBuilder: (context, index) {
                  final alojamento = republics[index];
                  final nearbyUniversities = alojamento['nearbyUniversities'] as List<dynamic>?;
                  final distance = nearbyUniversities != null && nearbyUniversities.isNotEmpty
                      ? '${(nearbyUniversities[0]['distanceKm'] as double?)?.toStringAsFixed(2) ?? 'N/A'} km'
                      : 'N/A';

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(alojamento['name'] ?? 'Alojamento sem nome'),
                      subtitle: Text(
                        'R\$${alojamento['value']?.toStringAsFixed(2) ?? '0.00'}/mês\n'
                        '${alojamento['address'] ?? 'N/A'}, ${alojamento['city'] ?? 'N/A'} - ${alojamento['state'] ?? 'N/A'}\n'
                        'Distância: $distance da universidade',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Implementar navegação para detalhes do alojamento
                      },
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
