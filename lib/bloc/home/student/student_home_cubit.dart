import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'student_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  StudentHomeCubit() : super(const StudentHomeState());

  Future<void> searchRepublicsByCity(String cidade) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final query = QueryBuilder<ParseObject>(ParseObject('Owner'))..whereEqualTo('city', cidade);

      final response = await query.query();

      if (response.success && response.results != null) {
        final republics = response.results!
            .map((e) => e.get<String>('address') ?? 'Sem endereço')
            .toList();

        emit(state.copyWith(isLoading: false, Republics: republics));
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            Republics: [],
            error: response.error?.message ?? 'Erro desconhecido ao buscar Republics',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao carregar Republics: $e'));
    }
  }

  // Se quiser manter um carregamento inicial
  Future<void> loadRepublics() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final query = QueryBuilder<ParseObject>(ParseObject('Owner'));

      final response = await query.query();

      if (response.success && response.results != null) {
        final Republics = response.results!
            .map((e) => e.get<String>('address') ?? 'Sem endereço')
            .toList();

        emit(state.copyWith(isLoading: false, Republics: Republics));
      } else {
        emit(state.copyWith(isLoading: false, error: 'Nenhum alojamento encontrado'));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao carregar Republics'));
    }
  }

  void clearRepublics() {
    emit(state.copyWith(Republics: [], error: null, isLoading: false));
  }
}
