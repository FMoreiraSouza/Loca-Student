import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/repositories/student_home_repository.dart';

import 'filtered_republic_list_state.dart';

class FilteredRepublicListCubit extends Cubit<FilteredRepublicListState> {
  final StudentHomeRepository _repository;

  FilteredRepublicListCubit(this._repository) : super(const FilteredRepublicListState());

  Future<void> searchRepublicsByCity(String city) async {
    emit(state.copyWith(status: FilteredRepublicListStatus.loading, error: null));
    try {
      final republics = await _repository.searchRepublicsByCity(city);

      if (republics.isEmpty) {
        emit(state.copyWith(status: FilteredRepublicListStatus.empty, republics: []));
      } else {
        emit(state.copyWith(status: FilteredRepublicListStatus.success, republics: republics));
      }
    } catch (e) {
      emit(state.copyWith(status: FilteredRepublicListStatus.error, error: e.toString()));
    }
  }

  Future<void> reserveSpot(RepublicModel rep) async {
    await _repository.reserveSpot(objectId: rep.objectId, currentVacancies: rep.vacancies);
  }

  void clearRepublics() {
    emit(state.copyWith(status: FilteredRepublicListStatus.initial, republics: [], error: null));
  }
}
