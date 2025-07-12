import 'package:flutter_bloc/flutter_bloc.dart';
import 'student_home_state.dart';

class StudentHomeCubit extends Cubit<StudentHomeState> {
  StudentHomeCubit() : super(const StudentHomeState());

  Future<void> loadAlojamentos() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simula requisição
      // Simule com strings, substitua depois com seu modelo real
      final mock = ['República Alpha', 'Apartamento Perto da UFSC', 'Quarto Individual Central'];
      emit(state.copyWith(isLoading: false, alojamentos: mock));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Erro ao carregar alojamentos'));
    }
  }
}
