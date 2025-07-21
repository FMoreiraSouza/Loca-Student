import 'package:loca_student/data/models/tenant_model.dart';

enum TenantListStatus { initial, loading, success, empty }

class TenantListState {
  final TenantListStatus status;
  final List<TenantModel> tenants;
  final String? error;

  TenantListState({this.status = TenantListStatus.initial, this.tenants = const [], this.error});

  TenantListState copyWith({TenantListStatus? status, List<TenantModel>? tenants, String? error}) {
    return TenantListState(
      status: status ?? this.status,
      tenants: tenants ?? this.tenants,
      error: error,
    );
  }
}
