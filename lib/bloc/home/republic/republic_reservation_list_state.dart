import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentsState {
  final bool isLoading;
  final String? error;
  final List<ParseObject> interestedStudents;

  InterestStudentsState({this.isLoading = false, this.error, this.interestedStudents = const []});

  InterestStudentsState copyWith({
    bool? isLoading,
    String? error,
    List<ParseObject>? interestedStudents,
  }) {
    return InterestStudentsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      interestedStudents: interestedStudents ?? this.interestedStudents,
    );
  }
}
