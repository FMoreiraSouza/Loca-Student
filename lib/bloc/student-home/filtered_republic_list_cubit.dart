import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/models/reservation_model.dart';
import 'package:loca_student/data/models/student_model.dart';
import 'package:loca_student/data/repositories/student_home_repository.dart';
import 'package:loca_student/data/services/api_service.dart';

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
      emit(state.copyWith(status: FilteredRepublicListStatus.empty, error: e.toString()));
    }
  }

  Future<void> reserveSpot(RepublicModel rep) async {
    emit(state.copyWith(status: FilteredRepublicListStatus.loading));
    try {
      final currentUser = await APIService.getCurrentUser();

      final studentParse = await _repository.getStudentForUser(currentUser);
      final republicPtr = _repository.getRepublicPointer(rep);

      final existing = await _repository.findExistingReservation(studentParse, republicPtr);
      if (existing.isNotEmpty) {
        final existingRes = existing.first;
        final status = existingRes.get<String>('status');
        if (status != null && status != 'cancelada') {
          throw Exception('Você já fez uma reserva para essa república');
        } else {
          await _repository.updateReservationStatus(existingRes, 'pendente');

          await _repository.updateInterestStatusIfExists(studentParse, republicPtr, 'interessado');

          emit(state.copyWith(status: FilteredRepublicListStatus.success));
          return;
        }
      }

      final reservation = ReservationModel(
        id: '',
        address: rep.address,
        city: rep.city,
        state: rep.state,
        value: rep.value,
        status: 'pendente',
        studentPointer: studentParse,
        republicPointer: republicPtr,
      );

      await _repository.saveReservation(reservation);

      final studentModel = StudentModel.fromParse(studentParse);

      final newInterested = InterestedStudentModel(
        objectId: '',
        studentName: currentUser.username ?? "",
        studentEmail: currentUser.emailAddress ?? "",
        studentId: studentModel.objectId,
        republicId: rep.objectId,
        student: studentModel,
      );

      final existingInterests = await _repository.findInterest(studentParse, republicPtr);
      if (existingInterests.isNotEmpty) {
        await _repository.updateInterestStatusIfExists(studentParse, republicPtr, 'interessado');
      } else {
        await _repository.saveInterestModel(newInterested, rep);
      }

      emit(state.copyWith(status: FilteredRepublicListStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FilteredRepublicListStatus.empty, error: e.toString()));
      rethrow;
    }
  }

  void clearRepublics() {
    emit(state.copyWith(status: FilteredRepublicListStatus.initial, republics: [], error: null));
  }
}
