import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_state.dart';
import 'package:loca_student/data/models/tenant_model.dart';
import 'package:loca_student/data/repositories/interfaces/i_republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TenantListCubit extends Cubit<TenantListState> {
  final IRepublicHomeRepository republicHomeRepository;

  TenantListCubit(this.republicHomeRepository) : super(TenantListState());

  Future<void> loadTenants(ParseUser currentUser) async {
    emit(state.copyWith(status: TenantListStatus.loading, error: null));
    try {
      final tenants = await republicHomeRepository.fetchTenants(currentUser);
      if (tenants.isEmpty) {
        emit(state.copyWith(status: TenantListStatus.empty, tenants: []));
      } else {
        emit(state.copyWith(status: TenantListStatus.success, tenants: tenants));
      }
    } catch (e) {
      emit(state.copyWith(status: TenantListStatus.empty, error: e.toString()));
    }
  }

  Future<void> removeTenant({required TenantModel tenant, required ParseUser currentUser}) async {
    try {
      await republicHomeRepository.updateTenantBelongs(tenant.objectId, false);
      await republicHomeRepository.updateReservationStatus(
        studentId: tenant.studentId,
        republicId: tenant.republicId,
        newStatus: 'cancelada',
      );
      await republicHomeRepository.updateInterestStatus(
        tenant.studentId,
        tenant.republicId,
        'recusado',
      );
      await republicHomeRepository.incrementVacancy(tenant.republicId);

      // recarrega lista
      await loadTenants(currentUser);
    } catch (e) {
      emit(state.copyWith(status: TenantListStatus.empty, error: e.toString()));
    }
  }
}
