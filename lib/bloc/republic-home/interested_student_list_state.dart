import 'package:loca_student/data/models/interested_student_model.dart';

enum InterestedStudentStatus { initial, loading, success, empty }

class InterestStudentListState {
  final InterestedStudentStatus status;
  final String? error;
  final List<InterestedStudentModel> interestedStudentList;

  const InterestStudentListState({
    this.status = InterestedStudentStatus.initial,
    this.error,
    this.interestedStudentList = const [],
  });

  InterestStudentListState copyWith({
    InterestedStudentStatus? status,
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
