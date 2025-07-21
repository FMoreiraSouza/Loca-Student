import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_state.dart';
import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/tenant_model.dart';
import 'package:loca_student/data/repositories/republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestedStudentListCubit extends Cubit<InterestStudentListState> {
  final RepublicHomeRepository repository;

  InterestedStudentListCubit(this.repository) : super(const InterestStudentListState());

  Future<void> loadInterestedStudents(ParseUser currentUser) async {
    emit(state.copyWith(status: InterestedStudentStatus.loading));
    try {
      final interested = await repository.fetchInterestedStudents(currentUser);
      if (interested.isEmpty) {
        emit(state.copyWith(status: InterestedStudentStatus.empty));
      } else {
        emit(
          state.copyWith(
            status: InterestedStudentStatus.success,
            interestedStudentList: interested,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: InterestedStudentStatus.empty, error: e.toString()));
    }
  }

  Future<void> updateInterestedStudentStatus({
    required InterestedStudentModel interested,
    required ParseUser currentUser,
  }) async {
    try {
      await repository.updateInterestedStudentStatusAndReservation(interested: interested);

      final updatedList = state.interestedStudentList
          .where((e) => e.objectId != interested.objectId)
          .toList();

      emit(
        state.copyWith(
          interestedStudentList: updatedList,
          status: updatedList.isEmpty
              ? InterestedStudentStatus.empty
              : InterestedStudentStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> acceptInterestedStudent({
    required InterestedStudentModel interested,
    required ParseUser currentUser,
  }) async {
    try {
      await repository.updateReservationStatus(
        studentId: interested.studentId,
        republicId: interested.republicId,
        newStatus: 'aceita',
      );

      await repository.acceptInterestStudent(interested);

      final existingTenant = await repository.getTenantByStudentAndRepublic(
        interested.studentId,
        interested.republicId,
      );

      if (existingTenant != null) {
        await repository.updateTenantBelongs(existingTenant.objectId, true);
      } else {
        final tenant = TenantModel(
          studentName: interested.studentName,
          studentEmail: interested.studentEmail,
          studentId: interested.studentId,
          republicId: interested.republicId,
          belongs: true,
        );
        await repository.createTenant(tenant);
      }

      await repository.updateVacancy(interested.republicId);

      await loadInterestedStudents(currentUser);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
