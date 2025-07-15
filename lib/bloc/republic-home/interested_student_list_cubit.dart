import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/interested_student_list_state.dart';
import 'package:loca_student/data/repositories/republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentListCubit extends Cubit<InterestStudentListState> {
  final RepublicHomeRepository repository;

  InterestStudentListCubit(this.repository) : super(InterestStudentListState());

  Future<void> loadInterestStudents(ParseObject currentUser) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final interested = await repository.fetchInterestedStudents(currentUser);
      emit(state.copyWith(isLoading: false, interestedStudents: interested));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateReservation(
    ParseObject student,
    ParseObject republic,
    String status,
    ParseObject currentUser,
  ) async {
    try {
      await repository.updateReservationStatus(student, republic, status);
      await loadInterestStudents(currentUser);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> updateReservationWithoutReload(
    ParseObject student,
    ParseObject republic,
    String status,
  ) async {
    try {
      await repository.updateReservationStatus(student, republic, status);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void removeInterested(ParseObject interested) {
    final updatedList = List<ParseObject>.from(state.interesteds);
    updatedList.remove(interested);
    emit(state.copyWith(interestedStudents: updatedList));
  }

  Future<void> updateInterestStudentStatus(ParseObject interested, String newStatus) async {
    try {
      interested.set('status', newStatus);
      final response = await interested.save();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'Erro ao atualizar status do interessado');
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> acceptInterestedStudent(
    ParseObject interested,
    ParseObject student,
    ParseObject republic,
    ParseObject currentUser,
  ) async {
    try {
      await repository.updateReservationStatus(student, republic, 'aceito');

      interested.set('status', 'aceito');
      final interestResponse = await interested.save();
      if (!interestResponse.success) {
        throw Exception(
          interestResponse.error?.message ?? 'Erro ao atualizar status do interessado',
        );
      }

      await repository.addTenant(interested, republic);

      await repository.updateVacancy(republic);

      await loadInterestStudents(currentUser);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
