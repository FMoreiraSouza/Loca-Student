import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/student-home/student_reservation_list_event.dart';
import 'package:loca_student/data/repositories/student_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentReservationListCubit extends Cubit<StudentReservationListState> {
  final StudentHomeRepository _repository;

  StudentReservationListCubit(this._repository) : super(StudentReservationListState());

  Future<void> fetchReservations() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final reservations = await _repository.fetchReservations();
      emit(state.copyWith(isLoading: false, reservations: reservations));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> cancelReservation(ParseObject reservation) async {
    try {
      await _repository.cancelReservation(reservation);
      await fetchReservations();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> reactivateReservation(ParseObject reservation) async {
    try {
      await _repository.reactivateReservation(reservation);
      await fetchReservations();
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
