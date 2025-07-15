import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/tenant_list_state.dart';
import 'package:loca_student/data/repositories/republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TenantListCubit extends Cubit<TenantListState> {
  final RepublicHomeRepository repository;
  TenantListCubit(this.repository) : super(TenantListState());

  Future<void> loadTenants(ParseObject currentUser) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final tenants = await repository.fetchTenants(currentUser);
      emit(state.copyWith(isLoading: false, tenants: tenants));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
