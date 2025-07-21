import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/student-home/student_reservation_list_state.dart';
import 'package:loca_student/data/repositories/interfaces/i_student_home_repository.dart';

class StudentReservationListCubit extends Cubit<StudentReservationListState> {
  final IStudentHomeRepository studentHomeRepository;

  StudentReservationListCubit(this.studentHomeRepository)
    : super(const StudentReservationListState());

  Future<void> fetchReservations() async {
    emit(state.copyWith(status: ReservationListStatus.loading));
    try {
      final results = await studentHomeRepository.fetchReservations();
      if (results.isEmpty) {
        emit(state.copyWith(status: ReservationListStatus.empty, reservations: []));
      } else {
        emit(state.copyWith(status: ReservationListStatus.success, reservations: results));
      }
    } catch (e) {
      emit(state.copyWith(status: ReservationListStatus.empty, error: e.toString()));
    }
  }

  Future<void> cancelReservation(String reservationId) async {
    try {
      await studentHomeRepository.cancelReservationByIdModular(reservationId);
      await fetchReservations();
    } catch (e) {
      emit(state.copyWith(status: ReservationListStatus.empty, error: e.toString()));
    }
  }

  Future<void> resendReserve(String reservationId) async {
    try {
      await studentHomeRepository.resendReservationByIdModular(reservationId);
      await fetchReservations();
    } catch (e) {
      emit(state.copyWith(status: ReservationListStatus.empty, error: e.toString()));
    }
  }
}
