import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RepublicHomeState {
  final bool isLoading;
  final String? error;
  final ParseObject? currentUser;

  const RepublicHomeState({this.isLoading = false, this.error, this.currentUser});

  RepublicHomeState copyWith({bool? isLoading, String? error, ParseObject? currentUser}) {
    return RepublicHomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
