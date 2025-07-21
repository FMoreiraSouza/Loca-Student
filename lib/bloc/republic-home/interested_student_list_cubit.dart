import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_state.dart';
import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/tenant_model.dart';
import 'package:loca_student/data/repositories/interfaces/i_republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestedStudentListCubit extends Cubit<InterestStudentListState> {
  final IRepublicHomeRepository republicHomeRepository;

  InterestedStudentListCubit(this.republicHomeRepository) : super(const InterestStudentListState());

  Future<void> loadInterestedStudents(ParseUser currentUser) async {
    emit(state.copyWith(status: InterestedStudentStatus.loading));
    try {
      final interested = await republicHomeRepository.fetchInterestedStudents(currentUser);
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
      await republicHomeRepository.updateInterestedStudentStatusAndReservation(
        interested: interested,
      );

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
      await republicHomeRepository.updateReservationStatus(
        studentId: interested.studentId,
        republicId: interested.republicId,
        newStatus: 'aceita',
      );

      await republicHomeRepository.acceptInterestStudent(interested);

      final existingTenant = await republicHomeRepository.getTenantByStudentAndRepublic(
        interested.studentId,
        interested.republicId,
      );

      if (existingTenant != null) {
        await republicHomeRepository.updateTenantBelongs(existingTenant.objectId, true);
      } else {
        final tenant = TenantModel(
          studentName: interested.studentName,
          studentEmail: interested.studentEmail,
          studentId: interested.studentId,
          republicId: interested.republicId,
          belongs: true,
        );
        await republicHomeRepository.createTenant(tenant);
      }

      await republicHomeRepository.updateVacancy(interested.republicId);

      await loadInterestedStudents(currentUser);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
