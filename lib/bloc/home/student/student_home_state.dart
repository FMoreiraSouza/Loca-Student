import 'package:equatable/equatable.dart';

class StudentHomeState extends Equatable {
  final bool isLoading;
  final List<String> alojamentos; // Trocar por seu modelo real futuramente
  final String? error;

  const StudentHomeState({this.isLoading = false, this.alojamentos = const [], this.error});

  StudentHomeState copyWith({bool? isLoading, List<String>? alojamentos, String? error}) {
    return StudentHomeState(
      isLoading: isLoading ?? this.isLoading,
      alojamentos: alojamentos ?? this.alojamentos,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, alojamentos, error];
}
