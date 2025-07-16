import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/republic-home/republic_home_state.dart';
import 'package:loca_student/data/repositories/republic_home_repository.dart';

class RepublicHomeCubit extends Cubit<RepublicHomeState> {
  final RepublicHomeRepository repository;

  RepublicHomeCubit(this.repository) : super(const RepublicHomeState());

  Future<void> loadCurrentUser() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await repository.getCurrentUser();
      emit(state.copyWith(isLoading: false, currentUser: user));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
