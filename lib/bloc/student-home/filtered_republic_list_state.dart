import 'package:loca_student/data/models/republic_model.dart';

enum FilteredRepublicListStatus { initial, loading, success, empty }

class FilteredRepublicListState {
  final FilteredRepublicListStatus status;
  final List<RepublicModel> republics;
  final String? error;

  const FilteredRepublicListState({
    this.status = FilteredRepublicListStatus.initial,
    this.republics = const [],
    this.error,
  });

  FilteredRepublicListState copyWith({
    FilteredRepublicListStatus? status,
    List<RepublicModel>? republics,
    String? error,
  }) {
    return FilteredRepublicListState(
      status: status ?? this.status,
      republics: republics ?? this.republics,
      error: error,
    );
  }
}
