import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_cubit.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_state.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TenantListWidget extends StatefulWidget {
  const TenantListWidget({super.key, required this.currentUser});
  final ParseUser currentUser;

  @override
  State<TenantListWidget> createState() => _TenantListWidgetState();
}

class _TenantListWidgetState extends State<TenantListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<TenantListCubit>().loadTenants(widget.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TenantListCubit, TenantListState>(
      builder: (context, state) {
        switch (state.status) {
          case TenantListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case TenantListStatus.error:
            return Center(child: Text('Erro ao carregar locatários:\n${state.error}'));
          case TenantListStatus.empty:
            return const Center(child: Text('Nenhum locatário encontrado.'));
          case TenantListStatus.success:
            return ListView.builder(
              itemCount: state.tenants.length,
              itemBuilder: (context, index) {
                final tenant = state.tenants[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(tenant.studentName),
                    subtitle: Text(tenant.studentEmail),
                    trailing: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () async {
                        await context.read<TenantListCubit>().removeTenant(
                          tenant: tenant,
                          currentUser: widget.currentUser,
                        );
                      },
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
