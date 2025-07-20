import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/models/reservation_model.dart';
import 'package:loca_student/data/models/student_model.dart';
import 'package:loca_student/data/repositories/student_home_repository.dart';
import 'package:loca_student/utils/parse_configs.dart';

import 'filtered_republic_list_state.dart';

class FilteredRepublicListCubit extends Cubit<FilteredRepublicListState> {
  final StudentHomeRepository _repository;

  FilteredRepublicListCubit(this._repository) : super(const FilteredRepublicListState());

  Future<void> searchRepublicsByCity(String city) async {
    emit(state.copyWith(status: FilteredRepublicListStatus.loading, error: null));
    try {
      final currentUser = await ParseConfigs.getCurrentUser();

      final republics = await _repository.searchRepublicsByCity(city, currentUser);

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
    emit(state.copyWith(status: FilteredRepublicListStatus.loading));
    try {
      final currentUser = await ParseConfigs.getCurrentUser();

      // Obtém o ParseObject do Student (repo continua cuidando de conexão)
      final studentParse = await _repository.getStudentForUser(currentUser);
      final republicPtr = _repository.getRepublicPointer(rep);

      // Verifica se já existe reserva
      final existing = await _repository.findExistingReservation(studentParse, republicPtr);
      if (existing.isNotEmpty) {
        final existingRes = existing.first;
        final status = existingRes.get<String>('status');
        if (status != null && status != 'cancelada') {
          throw Exception('Você já fez uma reserva para essa república');
        } else {
          await _repository.updateReservationStatus(existingRes, 'pendente');

          // Atualiza status de interesse se já existir
          await _repository.updateInterestStatusIfExists(studentParse, republicPtr, 'interessado');

          emit(state.copyWith(status: FilteredRepublicListStatus.success));
          return;
        }
      }

      // Criar nova reserva
      final reservation = ReservationModel(
        id: '',
        address: rep.address,
        city: rep.city,
        state: rep.state,
        value: rep.value,
        status: 'pendente',
        studentPointer: studentParse,
        republicPointer: republicPtr,
        username: currentUser.get<String>('username') ?? 'Desconhecido',
      );

      await _repository.saveReservation(reservation);

      // Monta o StudentModel puro a partir do ParseObject
      final studentModel = StudentModel.fromParse(studentParse);

      // Monta o modelo puro de interesse
      final newInterestModel = InterestedStudentModel(
        objectId: '',
        studentName: currentUser.username ?? "",
        studentEmail: currentUser.emailAddress ?? "",
        studentId: studentModel.objectId,
        republicId: rep.objectId,
        student: studentModel,
      );

      // Primeiro verifica se já existe interesse para atualizar, senão cria novo
      final existingInterests = await _repository.findInterest(studentParse, republicPtr);
      if (existingInterests.isNotEmpty) {
        await _repository.updateInterestStatusIfExists(studentParse, republicPtr, 'interessado');
      } else {
        await _repository.saveInterestModel(newInterestModel, rep);
      }

      emit(state.copyWith(status: FilteredRepublicListStatus.success));
    } catch (e) {
      emit(state.copyWith(status: FilteredRepublicListStatus.error, error: e.toString()));
    }
  }

  void clearRepublics() {
    emit(state.copyWith(status: FilteredRepublicListStatus.initial, republics: [], error: null));
  }
}
