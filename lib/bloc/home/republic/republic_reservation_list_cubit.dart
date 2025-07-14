import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/home/republic/republic_reservation_list_state.dart';
import 'package:loca_student/data/repositories/home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class InterestStudentsCubit extends Cubit<InterestStudentsState> {
  final HomeRepository _repository;

  InterestStudentsCubit(this._repository) : super(InterestStudentsState());

  Future<void> loadInterestStudents(ParseObject currentUser) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final interested = await _repository.fetchInterestedStudents(currentUser);
      emit(state.copyWith(isLoading: false, interestedStudents: interested));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
