import 'package:equatable/equatable.dart';
import 'package:loca_student/data/models/republic_model.dart';

class FilteredRepublicListState extends Equatable {
  final bool isLoading;
  final String? error;
  final List<RepublicModel> republics;

  const FilteredRepublicListState({this.isLoading = false, this.error, this.republics = const []});

  FilteredRepublicListState copyWith({
    bool? isLoading,
    String? error,
    List<RepublicModel>? republics,
  }) {
    return FilteredRepublicListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      republics: republics ?? this.republics,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, republics];
}
