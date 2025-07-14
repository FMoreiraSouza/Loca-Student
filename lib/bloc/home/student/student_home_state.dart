import 'package:equatable/equatable.dart';
import 'package:loca_student/data/models/republic_model.dart';

class StudentHomeState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<RepublicModel> republics;

  const StudentHomeState({this.isLoading = false, this.error, this.republics = const []});

  StudentHomeState copyWith({bool? isLoading, String? error, List<RepublicModel>? republics}) {
    return StudentHomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      republics: republics ?? this.republics,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, republics];
}
