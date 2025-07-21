import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/models/reservation_model.dart';
import 'package:loca_student/data/repositories/interfaces/i_student_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentHomeRepository implements IStudentHomeRepository {
  @override
  Future<List<RepublicModel>> searchRepublicsByCity(String city) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('city', city)
      ..includeObject(['user']);
    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.map((obj) => RepublicModel.fromParse(obj as ParseObject)).toList();
    } else {
      throw Exception(response.error?.message ?? 'Erro ao buscar repúblicas');
    }
  }

  @override
  Future<ParseObject> getStudentForUser(ParseUser user) async {
    final studentQuery = QueryBuilder<ParseObject>(ParseObject('Student'))
      ..whereEqualTo('user', user);

    final result = await studentQuery.query();
    if (result.results == null || result.results!.isEmpty) {
      throw Exception('Estudante não encontrado para o usuário atual');
    }
    return result.results!.first as ParseObject;
  }

  @override
  Future<List<ParseObject>> findExistingReservation(
    ParseObject student,
    ParseObject republic,
  ) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('republic', republic)
      ..whereEqualTo('student', student);

    final response = await query.query();
    return (response.results ?? []).cast<ParseObject>();
  }

  @override
  Future<void> saveReservation(ReservationModel reservation) async {
    final parseObj = reservation.toParse();
    final resp = await parseObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao salvar reserva');
    }
  }

  @override
  Future<void> updateReservationStatus(ParseObject reservationObj, String status) async {
    reservationObj.set('status', status);
    final resp = await reservationObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar reserva');
    }
  }

  @override
  Future<List<ParseObject>> findInterest(ParseObject student, ParseObject republic) async {
    final query = QueryBuilder<ParseObject>(ParseObject('InterestedStudents'))
      ..whereEqualTo('student', student)
      ..whereEqualTo('republic', republic);

    final resp = await query.query();
    return (resp.results ?? []).cast<ParseObject>();
  }

  @override
  Future<void> saveInterest(ParseObject interestObj) async {
    final resp = await interestObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao salvar interesse');
    }
  }

  @override
  Future<List<ReservationModel>> fetchReservations(ParseUser user) async {
    final studentPtr = await getStudentForUser(user);

    final query = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('student', studentPtr)
      ..whereContainedIn('status', ['pendente', 'aceita', 'recusada'])
      ..includeObject(['republic', 'republic.user', 'student'])
      ..orderByDescending('createdAt');

    final response = await query.query();
    if (response.success && response.results != null) {
      return response.results!
          .map((obj) => ReservationModel.fromParse(obj as ParseObject))
          .toList();
    } else {
      throw Exception(response.error?.message ?? 'Erro ao buscar reservas do usuário atual');
    }
  }

  @override
  Future<ParseObject?> getReservationById(String reservationId) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('objectId', reservationId)
      ..includeObject(['student', 'republic']);

    final result = await query.query();
    if (result.success && result.results != null && result.results!.isNotEmpty) {
      return result.results!.first as ParseObject;
    }
    return null;
  }

  @override
  Future<void> saveGeneric(ParseObject obj) async {
    final resp = await obj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao salvar objeto genérico');
    }
  }

  @override
  Future<void> updateReservation(ParseObject reservation) async {
    final resp = await reservation.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar reserva');
    }
  }

  @override
  Future<void> updateRepublicVacancies(String republicId, int increment) async {
    final republicObj = ParseObject('Republic')..objectId = republicId;
    await republicObj.fetch();
    final currentVacancies = republicObj.get<int>('vacancies') ?? 0;
    republicObj.set('vacancies', currentVacancies + increment);
    final resp = await republicObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar vagas da república');
    }
  }

  @override
  Future<List<ParseObject>> findTenant(ParseObject student, ParseObject republic) async {
    final tenantQuery = QueryBuilder<ParseObject>(ParseObject('Tenants'))
      ..whereEqualTo('student', student)
      ..whereEqualTo('republic', republic);
    final tenantResp = await tenantQuery.query();
    return (tenantResp.results ?? []).cast<ParseObject>();
  }

  @override
  Future<void> updateTenant(ParseObject tenantObj) async {
    final resp = await tenantObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar tenant');
    }
  }

  @override
  Future<ParseObject?> getReservationByIdWithRelations(String reservationId) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('objectId', reservationId)
      ..includeObject(['student', 'republic']);

    final result = await query.query();
    if (result.success && result.results != null && result.results!.isNotEmpty) {
      return result.results!.first as ParseObject;
    }
    return null;
  }

  @override
  Future<void> updateReservationStatusByObject(ParseObject reservationObj, String status) async {
    reservationObj.set('status', status);
    final resp = await reservationObj.save();
    if (!resp.success) throw Exception(resp.error?.message ?? 'Erro ao atualizar reserva');
  }

  @override
  Future<void> updateInterestStatus(
    ParseObject student,
    ParseObject republic,
    String status,
  ) async {
    final interests = await findInterest(student, republic);
    if (interests.isNotEmpty) {
      final interestObj = interests.first;
      interestObj.set('status', status);
      final resp = await interestObj.save();
      if (!resp.success) throw Exception(resp.error?.message ?? 'Erro ao atualizar interesse');
    }
  }

  @override
  Future<void> incrementRepublicVacancies(ParseObject republic, int increment) async {
    final currentVacancies = republic.get<int>('vacancies') ?? 0;
    republic.set('vacancies', currentVacancies + increment);
    final resp = await republic.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar vagas da república');
    }
  }

  @override
  Future<void> updateTenantBelongs(ParseObject student, ParseObject republic, bool belongs) async {
    final tenants = await findTenant(student, republic);
    if (tenants.isNotEmpty) {
      final tenant = tenants.first;
      tenant.set('belongs', belongs);
      final resp = await tenant.save();
      if (!resp.success) throw Exception(resp.error?.message ?? 'Erro ao atualizar tenant');
    }
  }

  @override
  Future<void> cancelReservationByIdModular(String reservationId) async {
    final reservation = await getReservationByIdWithRelations(reservationId);
    if (reservation == null) throw Exception('Reserva não encontrada');

    final currentStatus = reservation.get<String>('status');
    final student = reservation.get<ParseObject>('student');
    final republic = reservation.get<ParseObject>('republic');

    await updateReservationStatusByObject(reservation, 'cancelada');

    if (student != null && republic != null) {
      await updateInterestStatus(student, republic, 'desinteressado');

      if (currentStatus == 'aceita') {
        await incrementRepublicVacancies(republic, 1);

        await updateTenantBelongs(student, republic, false);
      }
    }
  }

  @override
  Future<void> updateInterestStatusIfExists(
    ParseObject student,
    ParseObject republic,
    String status,
  ) async {
    final interestedList = await findInterest(student, republic);
    if (interestedList.isNotEmpty) {
      final interestObj = interestedList.first;
      interestObj.set('status', status);
      await saveInterest(interestObj);
    }
  }

  @override
  Future<void> saveInterestModel(InterestedStudentModel model, RepublicModel republic) async {
    final parseObj = model.toParse(republic: getRepublicPointer(republic));
    await saveInterest(parseObj);
  }

  @override
  ParseObject getRepublicPointer(RepublicModel republic) {
    return ParseObject('Republic')..objectId = republic.objectId;
  }

  @override
  Future<void> resendReservationByIdModular(String reservationId) async {
    final reservation = await getReservationByIdWithRelations(reservationId);
    if (reservation == null) throw Exception('Reserva não encontrada');

    await updateReservationStatusByObject(reservation, 'pendente');

    final student = reservation.get<ParseObject>('student');
    final republic = reservation.get<ParseObject>('republic');
    if (student != null && republic != null) {
      await updateInterestStatus(student, republic, 'interessado');
    }
  }
}
