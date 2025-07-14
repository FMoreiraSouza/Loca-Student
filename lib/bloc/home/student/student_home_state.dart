import 'package:equatable/equatable.dart';

class StudentHomeState extends Equatable {
  final bool isLoading;
  final List<dynamic> Republics; // Trocar por seu modelo real futuramente
  final String? error;

  const StudentHomeState({this.isLoading = false, this.Republics = const [], this.error});

  StudentHomeState copyWith({bool? isLoading, List<dynamic>? Republics, String? error}) {
    return StudentHomeState(
      isLoading: isLoading ?? this.isLoading,
      Republics: Republics ?? this.Republics,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, Republics, error];
}
