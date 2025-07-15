import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentListState {
  final bool isLoading;
  final String? error;
  final List<ParseObject> interestedStudentList;

  InterestStudentListState({
    this.isLoading = false,
    this.error,
    this.interestedStudentList = const [],
  });

  InterestStudentListState copyWith({
    bool? isLoading,
    String? error,
    List<ParseObject>? interestedStudents,
  }) {
    return InterestStudentListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      interestedStudentList: interestedStudents ?? interestedStudentList,
    );
  }
}
