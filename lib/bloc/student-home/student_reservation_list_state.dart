import 'package:loca_student/data/models/reservation_model.dart';

enum ReservationListStatus { initial, loading, success, empty, error }

class StudentReservationListState {
  final ReservationListStatus status;
  final List<ReservationModel> reservations;
  final String? error;

  const StudentReservationListState({
    this.status = ReservationListStatus.initial,
    this.reservations = const [],
    this.error,
  });

  StudentReservationListState copyWith({
    ReservationListStatus? status,
    List<ReservationModel>? reservations,
    String? error,
  }) {
    return StudentReservationListState(
      status: status ?? this.status,
      reservations: reservations ?? this.reservations,
      error: error,
    );
  }
}
