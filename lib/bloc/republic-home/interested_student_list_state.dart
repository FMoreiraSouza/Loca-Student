import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

enum InterestStudentStatus { initial, loading, success, empty, error }

class InterestStudentListState {
  final InterestStudentStatus status;
  final String? error;
  final List<ParseObject> interestedStudentList;

  const InterestStudentListState({
    this.status = InterestStudentStatus.initial,
    this.error,
    this.interestedStudentList = const [],
  });

  InterestStudentListState copyWith({
    InterestStudentStatus? status,
    String? error,
    List<ParseObject>? interestedStudentList,
  }) {
    return InterestStudentListState(
      status: status ?? this.status,
      error: error,
      interestedStudentList: interestedStudentList ?? this.interestedStudentList,
    );
  }
}
