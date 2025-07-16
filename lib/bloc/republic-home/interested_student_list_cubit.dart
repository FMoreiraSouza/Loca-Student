import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_state.dart';
import 'package:loca_student/data/repositories/republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentListCubit extends Cubit<InterestStudentListState> {
  final RepublicHomeRepository repository;
  InterestStudentListCubit(this.repository) : super(InterestStudentListState());

  Future<void> loadInterestStudents(ParseObject currentUser) async {
    emit(state.copyWith(status: InterestStudentStatus.loading));
    try {
      final interested = await repository.fetchInterestedStudents(currentUser);
      if (interested.isEmpty) {
        emit(state.copyWith(status: InterestStudentStatus.empty));
      } else {
        emit(
          state.copyWith(status: InterestStudentStatus.success, interestedStudentList: interested),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: InterestStudentStatus.error, error: e.toString()));
    }
  }

  Future<void> updateInterestStudentStatus(String interestId, String newStatus) async {
    try {
      await repository.updateInterestStudentStatus(interestId, newStatus);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> acceptInterestedStudent({
    required String interestId,
    required String studentId,
    required String republicId,
    required ParseObject currentUser,
  }) async {
    try {
      await repository.acceptInterestedStudent(
        interestId: interestId,
        studentId: studentId,
        republicId: republicId,
      );
      await loadInterestStudents(currentUser);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
