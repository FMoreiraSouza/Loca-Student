import 'package:loca_student/data/models/interested_student_model.dart';

enum InterestStudentStatus { initial, loading, success, empty, error }

class InterestStudentListState {
  final InterestStudentStatus status;
  final String? error;
  final List<InterestedStudentModel> interestedStudentList;

  const InterestStudentListState({
    this.status = InterestStudentStatus.initial,
    this.error,
    this.interestedStudentList = const [],
  });

  InterestStudentListState copyWith({
    InterestStudentStatus? status,
    String? error,
    List<InterestedStudentModel>? interestedStudentList,
  }) {
    return InterestStudentListState(
      status: status ?? this.status,
      error: error,
      interestedStudentList: interestedStudentList ?? this.interestedStudentList,
    );
  }
}
