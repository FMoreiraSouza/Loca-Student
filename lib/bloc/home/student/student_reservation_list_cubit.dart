import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/student/student_reservation_list_event.dart';
import 'package:loca_student/data/repositories/home_repository.dart';

class StudentReservationListCubit extends Cubit<StudentReservationListState> {
  final HomeRepository _repository;

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
}
