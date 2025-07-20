import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/models/reservation_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentHomeRepository {
  // 🔹 Buscar repúblicas por cidade
  Future<List<RepublicModel>> searchRepublicsByCity(String city, ParseUser user) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('city', city)
      ..includeObject(['user']);

    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!
          .map((obj) => RepublicModel.fromParse(obj as ParseObject, user: user))
          .toList();
    } else {
      throw Exception(response.error?.message ?? 'Erro ao buscar repúblicas');
    }
  }

  // 🔹 Buscar objeto Student vinculado ao usuário atual
  Future<ParseObject> getStudentForUser(ParseUser user) async {
    final studentQuery = QueryBuilder<ParseObject>(ParseObject('Student'))
      ..whereEqualTo('user', user);

    final result = await studentQuery.query();
    if (result.results == null || result.results!.isEmpty) {
      throw Exception('Estudante não encontrado para o usuário atual');
    }
    return result.results!.first as ParseObject;
  }

  // 🔹 Buscar reservas existentes de um estudante em uma república
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

  // 🔹 Salvar uma reserva (nova ou atualizada)
  Future<void> saveReservation(ReservationModel reservation) async {
    final parseObj = reservation.toParse();
    final resp = await parseObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao salvar reserva');
    }
  }

  // 🔹 Atualizar status de uma reserva existente
  Future<void> updateReservationStatus(ParseObject reservationObj, String status) async {
    reservationObj.set('status', status);
    final resp = await reservationObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar reserva');
    }
  }

  // 🔹 Buscar interesse do estudante
  Future<List<ParseObject>> findInterest(ParseObject student, ParseObject republic) async {
    final query = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
      ..whereEqualTo('student', student)
      ..whereEqualTo('republic', republic);

    final resp = await query.query();
    return (resp.results ?? []).cast<ParseObject>();
  }

  // 🔹 Salvar ou atualizar objeto de interesse
  Future<void> saveInterest(ParseObject interestObj) async {
    final resp = await interestObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao salvar interesse');
    }
  }

  // 🔹 Buscar reservas do app
  Future<List<ReservationModel>> fetchReservations() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereContainedIn('status', ['pendente', 'aceita', 'recusada'])
      ..orderByDescending('createdAt');

    final response = await query.query();
    if (response.success && response.results != null) {
      return response.results!
          .map((obj) => ReservationModel.fromParse(obj as ParseObject))
          .toList();
    } else {
      throw Exception(response.error?.message ?? 'Erro ao buscar reservas');
    }
  }

  // 🔹 Cancelar reserva simples (sem regras extras)
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

  Future<void> saveGeneric(ParseObject obj) async {
    final resp = await obj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao salvar objeto genérico');
    }
  }

  Future<void> updateReservation(ParseObject reservation) async {
    final resp = await reservation.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar reserva');
    }
  }

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

  Future<List<ParseObject>> findTenant(ParseObject student, ParseObject republic) async {
    final tenantQuery = QueryBuilder<ParseObject>(ParseObject('Tenants'))
      ..whereEqualTo('student', student)
      ..whereEqualTo('republic', republic);
    final tenantResp = await tenantQuery.query();
    return (tenantResp.results ?? []).cast<ParseObject>();
  }

  Future<void> updateTenant(ParseObject tenantObj) async {
    final resp = await tenantObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar tenant');
    }
  }

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

  Future<void> updateReservationStatusByObject(ParseObject reservationObj, String status) async {
    reservationObj.set('status', status);
    final resp = await reservationObj.save();
    if (!resp.success) throw Exception(resp.error?.message ?? 'Erro ao atualizar reserva');
  }

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

  Future<void> incrementRepublicVacancies(ParseObject republic, int increment) async {
    final currentVacancies = republic.get<int>('vacancies') ?? 0;
    republic.set('vacancies', currentVacancies + increment);
    final resp = await republic.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar vagas da república');
    }
  }

  Future<void> updateTenantBelongs(ParseObject student, ParseObject republic, bool belongs) async {
    final tenants = await findTenant(student, republic);
    if (tenants.isNotEmpty) {
      final tenant = tenants.first;
      tenant.set('belongs', belongs);
      final resp = await tenant.save();
      if (!resp.success) throw Exception(resp.error?.message ?? 'Erro ao atualizar tenant');
    }
  }

  // Cancelar reserva modularizado
  Future<void> cancelReservationByIdModular(String reservationId) async {
    final reservation = await getReservationByIdWithRelations(reservationId);
    if (reservation == null) throw Exception('Reserva não encontrada');

    final currentStatus = reservation.get<String>('status');
    final student = reservation.get<ParseObject>('student');
    final republic = reservation.get<ParseObject>('republic');

    // Atualiza status da reserva para cancelada
    await updateReservationStatusByObject(reservation, 'cancelada');

    if (student != null && republic != null) {
      // Atualiza status do interesse para "desinteressado"
      await updateInterestStatus(student, republic, 'desinteressado');

      if (currentStatus == 'aceita') {
        // Atualiza vagas da república (incrementa 1)
        await incrementRepublicVacancies(republic, 1);

        // Atualiza tenant para 'belongs = false'
        await updateTenantBelongs(student, republic, false);
      }
    }
  }

  Future<void> updateInterestStatusIfExists(
    ParseObject student,
    ParseObject republic,
    String status,
  ) async {
    final interests = await findInterest(student, republic);
    if (interests.isNotEmpty) {
      final interestObj = interests.first;
      interestObj.set('status', status);
      await saveInterest(interestObj);
    }
  }

  Future<void> saveInterestModel(InterestedStudentModel model, RepublicModel republic) async {
    final parseObj = model.toParse(republic: getRepublicPointer(republic));
    await saveInterest(parseObj);
  }

  ParseObject getRepublicPointer(RepublicModel republic) {
    return ParseObject('Republic')..objectId = republic.objectId;
  }

  // --- Métodos modulares para Reenviar Reserva ---

  Future<void> resendReservationByIdModular(String reservationId) async {
    final reservation = await getReservationByIdWithRelations(reservationId);
    if (reservation == null) throw Exception('Reserva não encontrada');

    // Atualiza status da reserva para 'pendente'
    await updateReservationStatusByObject(reservation, 'pendente');

    final student = reservation.get<ParseObject>('student');
    final republic = reservation.get<ParseObject>('republic');
    if (student != null && republic != null) {
      // Atualiza interesse para 'interessado'
      await updateInterestStatus(student, republic, 'interessado');
    }
  }
}
