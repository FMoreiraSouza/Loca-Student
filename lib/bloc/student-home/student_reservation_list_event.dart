import 'package:equatable/equatable.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentReservationListState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<ParseObject> reservations;

  const StudentReservationListState({
    this.isLoading = false,
    this.error,
    this.reservations = const [],
  });

  StudentReservationListState copyWith({
    bool? isLoading,
    String? error,
    List<ParseObject>? reservations,
  }) {
    return StudentReservationListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      reservations: reservations ?? this.reservations,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, reservations];
}
