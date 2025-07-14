import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/student/student_home_cubit.dart';
import 'package:loca_student/bloc/home/student/student_home_state.dart';

class StudentHomeBody extends StatefulWidget {
  const StudentHomeBody({super.key});

  @override
  State<StudentHomeBody> createState() => _StudentHomeBodyState();
}

class _StudentHomeBodyState extends State<StudentHomeBody> {
  final TextEditingController _searchController = TextEditingController();

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

  void _onSearchSubmitted(String texto) {
    final cidade = texto.trim();
    if (cidade.isNotEmpty) {
      context.read<StudentHomeCubit>().searchRepublicsByCity(cidade);
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

              if (state.Republics.isEmpty) {
                return const Center(child: Text('Nenhum alojamento encontrado'));
              }

              return ListView.builder(
                itemCount: state.Republics.length,
                itemBuilder: (context, index) {
                  final item = state.Republics[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(item),
                      subtitle: const Text('R\$500/mês • 1km da universidade'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // abrir detalhes
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
