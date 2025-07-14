import 'package:loca_student/data/models/republic.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'student_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  StudentHomeCubit() : super(const StudentHomeState());

  Future<void> searchRepublicsByCity(String cidade) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final query = QueryBuilder<ParseObject>(ParseObject('Owner'))
        ..whereEqualTo('city', cidade)
        ..includeObject(['user']); // Garante acesso ao user.username

      final response = await query.query();

      if (response.success && response.results != null) {
        final republics = response.results!.map((e) {
          final user = e['user'] as ParseObject?;
          final username = user?['username'] as String? ?? 'Desconhecido';
          final address = e['address'] as String? ?? 'Sem endereço';
          final value = (e['value'] as num?)?.toDouble() ?? 0.0;
          final latitude = (e['latitude'] as num?)?.toDouble() ?? 0.0;
          final longitude = (e['longitude'] as num?)?.toDouble() ?? 0.0;

          return RepublicModel(
            username: username,
            value: value,
            address: address,
            latitude: latitude,
            longitude: longitude,
          );
        }).toList();

        emit(state.copyWith(isLoading: false, republics: republics));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            republics: [],
            error: response.error?.message ?? 'Erro desconhecido ao buscar repúblicas.',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao buscar repúblicas: $e'));
    }
  }

  void clearRepublics() {
    emit(state.copyWith(republics: [], error: null, isLoading: false));
  }
}
