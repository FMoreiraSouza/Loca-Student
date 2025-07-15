import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_cubit.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_state.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TenantListPage extends StatefulWidget {
  const TenantListPage({super.key, required this.currentUser});
  final ParseObject currentUser;

  @override
  State<TenantListPage> createState() => _TenantListPageState();
}

class _TenantListPageState extends State<TenantListPage> {
  @override
  void initState() {
    super.initState();
    context.read<TenantListCubit>().loadTenants(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenantListCubit, TenantListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null) {
          return Center(child: Text('Erro ao carregar locatários:\n${state.error}'));
        }
        if (state.tenants.isEmpty) {
          return const Center(child: Text('Nenhum locatário encontrado.'));
        }

        return ListView.builder(
          itemCount: state.tenants.length,
          itemBuilder: (context, index) {
            final tenant = state.tenants[index];
            final name = tenant.get<String>('studentName') ?? 'Nome não informado';
            final email = tenant.get<String>('studentEmail') ?? 'Email não informado';
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(name),
                subtitle: Text(email),
              ),
            );
          },
        );
      },
    );
  }
}
