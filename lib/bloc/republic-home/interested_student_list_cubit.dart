import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_state.dart';
import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/tenant_model.dart';
import 'package:loca_student/data/repositories/republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentListCubit extends Cubit<InterestStudentListState> {
  final RepublicHomeRepository repository;

  InterestStudentListCubit(this.repository) : super(const InterestStudentListState());

  Future<void> loadInterestStudents(ParseUser currentUser) async {
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

  Future<void> updateInterestStudentStatus({
    required InterestedStudentModel interested,
    required ParseUser currentUser,
  }) async {
    try {
      await repository.updateInterestStudentStatusAndReservation(interested: interested);

      final updatedList = state.interestedStudentList
          .where((e) => e.objectId != interested.objectId)
          .toList();

      emit(
        state.copyWith(
          interestedStudentList: updatedList,
          status: updatedList.isEmpty ? InterestStudentStatus.empty : InterestStudentStatus.success,
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
      // 👉 atualiza reserva e interesse (mantém como está)
      await repository.updateReservationStatus(
        studentId: interested.studentId,
        republicId: interested.republicId,
        newStatus: 'aceita',
      );

      await repository.updateInterestStatusAceito(interested);

      // 👉 Lógica de tenants fica aqui no cubit
      final existingTenant = await repository.getTenantByStudentAndRepublic(
        interested.studentId,
        interested.republicId,
      );

      if (existingTenant != null) {
        // já existe → só atualizar belongs
        await repository.updateTenantBelongs(existingTenant.objectId, true);
      } else {
        // não existe → criar novo
        final tenant = TenantModel(
          studentName: interested.studentName,
          studentEmail: interested.studentEmail,
          studentId: interested.studentId,
          republicId: interested.republicId,
          belongs: true,
        );
        await repository.createTenant(tenant);
      }

      // 👉 atualiza vagas
      await repository.updateVacancy(interested.republicId);

      // 👉 recarrega lista
      await loadInterestStudents(currentUser);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
