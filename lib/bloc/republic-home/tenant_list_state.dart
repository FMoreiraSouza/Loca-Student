import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

enum TenantListStatus { initial, loading, success, empty, error }

class TenantListState {
  final TenantListStatus status;
  final List<ParseObject> tenants;
  final String? error;

  TenantListState({this.status = TenantListStatus.initial, this.tenants = const [], this.error});

  TenantListState copyWith({TenantListStatus? status, List<ParseObject>? tenants, String? error}) {
    return TenantListState(
      status: status ?? this.status,
      tenants: tenants ?? this.tenants,
      error: error,
    );
  }
}
