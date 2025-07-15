import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/republic/student_interested_list_state.dart';
import 'package:loca_student/data/repositories/home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentsCubit extends Cubit<InterestStudentsState> {
  final HomeRepository repository;

  InterestStudentsCubit(this.repository) : super(InterestStudentsState());

  Future<void> loadInterestStudents(ParseObject currentUser) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final interested = await repository.fetchInterestedStudents(currentUser);
      emit(state.copyWith(isLoading: false, interestedStudents: interested));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Atualiza a reserva e recarrega a lista
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

  /// Atualiza a reserva sem recarregar a lista
  Future<void> updateReservationWithoutReload(
    ParseObject student,
    ParseObject republic,
    String status,
  ) async {
    try {
      await repository.updateReservationStatus(student, republic, status);
      // não recarrega a lista
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Remove da lista local
  void removeInterested(ParseObject interested) {
    final updatedList = List<ParseObject>.from(state.interestedStudents);
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
      // Atualiza status na reserva
      await repository.updateReservationStatus(student, republic, 'aceito');

      // Atualiza status no interesse
      interested.set('status', 'aceito');
      final interestResponse = await interested.save();
      if (!interestResponse.success) {
        throw Exception(
          interestResponse.error?.message ?? 'Erro ao atualizar status do interessado',
        );
      }

      // Cria registro de locatário usando os dados do interessado
      await repository.addTenant(interested, republic);

      // ✅ Agora sim, decrementa a vaga
      await repository.updateVacancy(republic);

      // Recarrega a lista para refletir as mudanças
      await loadInterestStudents(currentUser);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
