import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class TenantListState {
  final bool isLoading;
  final String? error;
  final List<ParseObject> tenants;

  TenantListState({this.isLoading = false, this.error, this.tenants = const []});

  TenantListState copyWith({bool? isLoading, String? error, List<ParseObject>? tenants}) {
    return TenantListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      tenants: tenants ?? this.tenants,
    );
  }
}
