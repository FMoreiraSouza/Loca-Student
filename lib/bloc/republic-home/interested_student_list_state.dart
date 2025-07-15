import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentListState {
  final bool isLoading;
  final String? error;
  final List<ParseObject> interesteds;

  InterestStudentListState({this.isLoading = false, this.error, this.interesteds = const []});

  InterestStudentListState copyWith({
    bool? isLoading,
    String? error,
    List<ParseObject>? interestedStudents,
  }) {
    return InterestStudentListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      interesteds: interestedStudents ?? this.interesteds,
    );
  }
}
