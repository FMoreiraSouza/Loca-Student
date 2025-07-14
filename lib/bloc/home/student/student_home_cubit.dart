import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/repositories/home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'student_home_state.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  final HomeRepository _repository;

  StudentHomeCubit(this._repository) : super(const StudentHomeState());

  Future<void> searchRepublicsByCity(String city) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final results = await _repository.searchRepublicsByCity(city);

      final republics = results.map((parseObject) {
        final user = parseObject.get<ParseObject>('user');
        return RepublicModel(
          objectId: parseObject.objectId ?? '',
          username: user?['username'] ?? 'Desconhecido',
          email: parseObject['email'] ?? '',
          phone: parseObject['phone'] ?? '',
          address: parseObject['address'] ?? '',
          city: parseObject['city'] ?? '',
          state: parseObject['state'] ?? '',
          value: (parseObject['value'] as num?)?.toDouble() ?? 0.0,
          vacancies: (parseObject['vacancies'] as num?)?.toInt() ?? 0,
          latitude: (parseObject['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (parseObject['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();

      emit(state.copyWith(isLoading: false, republics: republics));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> reserveSpot(RepublicModel rep) async {
    await _repository.reserveSpot(objectId: rep.objectId, currentVacancies: rep.vacancies);
  }

  void clearRepublics() {
    emit(state.copyWith(republics: [], error: null, isLoading: false));
  }
}
