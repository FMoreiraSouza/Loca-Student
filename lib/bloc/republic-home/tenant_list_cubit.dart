import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_state.dart';
import 'package:loca_student/data/repositories/republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TenantListCubit extends Cubit<TenantListState> {
  final RepublicHomeRepository repository;

  TenantListCubit(this.repository) : super(TenantListState());

  // 🔹 Carregar inquilinos
  Future<void> loadTenants(ParseObject currentUser) async {
    emit(state.copyWith(status: TenantListStatus.loading, error: null));
    try {
      final tenants = await repository.fetchTenants(currentUser);
      if (tenants.isEmpty) {
        emit(state.copyWith(status: TenantListStatus.empty, tenants: []));
      } else {
        emit(state.copyWith(status: TenantListStatus.success, tenants: tenants));
      }
    } catch (e) {
      emit(state.copyWith(status: TenantListStatus.error, error: e.toString()));
    }
  }

  // 🔹 Remover inquilino
  Future<void> removeTenant({required String tenantId, required ParseObject currentUser}) async {
    try {
      // Aqui poderia ter um estado intermediário de carregamento se quiser
      await repository.removeTenant(tenantId);
      // Depois de remover, recarrega a lista atualizada
      await loadTenants(currentUser);
    } catch (e) {
      emit(state.copyWith(status: TenantListStatus.error, error: e.toString()));
    }
  }
}
