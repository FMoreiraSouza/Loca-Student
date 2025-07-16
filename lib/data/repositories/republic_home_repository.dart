import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/tenant_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RepublicHomeRepository {
  Future<ParseObject?> getCurrentUser() async {
    final user = await ParseUser.currentUser() as ParseObject?;
    if (user == null) return null;
    await user.fetch();
    return user;
  }

  Future<List<InterestedStudentModel>> fetchInterestedStudents(
    ParseObject currentUserRepublic,
  ) async {
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUserRepublic);
    final republicResponse = await republicQuery.query();
    if (republicResponse.results == null || republicResponse.results!.isEmpty) {
      throw Exception('Nenhuma república encontrada para o usuário atual');
    }
    final republic = republicResponse.results!.first;
    final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
      ..whereEqualTo('republic', republic)
      ..whereEqualTo('status', 'interessado')
      ..orderByDescending('createdAt');
    final interestResponse = await interestQuery.query();
    if (interestResponse.success && interestResponse.results != null) {
      return interestResponse.results!
          .map((e) => InterestedStudentModel.fromParse(e as ParseObject))
          .toList();
    } else {
      throw Exception(interestResponse.error?.message ?? 'Erro ao buscar interessados');
    }
  }

  Future<List<TenantModel>> fetchTenants(ParseObject currentUserRepublic) async {
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUserRepublic);

    final republicResponse = await republicQuery.query();
    if (republicResponse.results == null || republicResponse.results!.isEmpty) {
      throw Exception('Nenhuma república encontrada');
    }
    final republic = republicResponse.results!.first;
    final tenantsQuery = QueryBuilder<ParseObject>(ParseObject('Tenants'))
      ..whereEqualTo('republic', republic)
      ..orderByDescending('createdAt');
    final tenantsResponse = await tenantsQuery.query();
    if (tenantsResponse.success && tenantsResponse.results != null) {
      return tenantsResponse.results!.map((e) => TenantModel.fromParse(e as ParseObject)).toList();
    } else {
      throw Exception(tenantsResponse.error?.message ?? 'Erro ao buscar locatários');
    }
  }

  // Os demais métodos continuam iguais porque eles são ações (update, save)
  // e não retornam listas para o widget.
  Future<void> updateReservationStatus(
    ParseObject student,
    ParseObject republic,
    String newStatus,
  ) async {
    final reservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('student', student)
      ..whereEqualTo('republic', republic);
    final reservationResponse = await reservationQuery.query();
    if (reservationResponse.results != null && reservationResponse.results!.isNotEmpty) {
      final reservation = reservationResponse.results!.first as ParseObject;
      reservation.set('status', newStatus);
      final saveResponse = await reservation.save();
      if (!saveResponse.success) {
        throw Exception(saveResponse.error?.message ?? 'Erro ao atualizar status da reserva');
      }
    } else {
      throw Exception('Reserva não encontrada para este estudante e república.');
    }
  }

  Future<void> updateVacancy(ParseObject republic) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', republic.objectId);
    final response = await query.query();
    if (response.results == null || response.results!.isEmpty) {
      throw Exception('República não encontrada para decrementar vaga');
    }
    final republicObj = response.results!.first as ParseObject;
    final currentVacancies = republicObj.get<int>('vacancies') ?? 0;
    if (currentVacancies <= 0) {
      throw Exception('Sem vagas disponíveis para decrementar');
    }
    republicObj.set('vacancies', currentVacancies - 1);
    final saveResponse = await republicObj.save();
    if (!saveResponse.success) {
      throw Exception(saveResponse.error?.message ?? 'Erro ao decrementar vaga');
    }
  }

  Future<void> addTenant(ParseObject interested, ParseObject republic) async {
    final studentName = interested.get<String>('studentName') ?? 'Nome não informado';
    final studentEmail = interested.get<String>('studentEmail') ?? 'Email não informado';
    final student = interested.get<ParseObject>('student');
    final tenant = ParseObject('Tenants')
      ..set('student', student)
      ..set('republic', republic)
      ..set('studentName', studentName)
      ..set('studentEmail', studentEmail)
      ..set('createdAt', DateTime.now());
    final response = await tenant.save();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Erro ao salvar locatário');
    }
  }

  Future<void> updateInterestStudentStatus(String interestId, String newStatus) async {
    final interestObj = ParseObject('InterestStudents')..objectId = interestId;
    interestObj.set<String>('status', newStatus);
    final response = await interestObj.save();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Erro ao atualizar status do interessado');
    }
  }

  Future<void> acceptInterestedStudent({
    required String interestId,
    required String studentId,
    required String republicId,
  }) async {
    await updateReservationStatus(
      ParseObject('Student')..objectId = studentId,
      ParseObject('Republic')..objectId = republicId,
      'aceito',
    );
    final interestObj = ParseObject('InterestStudents')..objectId = interestId;
    interestObj.set<String>('status', 'aceito');
    final interestResp = await interestObj.save();
    if (!interestResp.success) {
      throw Exception(interestResp.error?.message ?? 'Erro ao atualizar interessado');
    }
    await addTenantFromInterest(interestId, republicId);
    await updateVacancy(ParseObject('Republic')..objectId = republicId);
  }

  Future<void> addTenantFromInterest(String interestId, String republicId) async {
    final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
      ..whereEqualTo('objectId', interestId)
      ..includeObject(['student']);
    final resp = await interestQuery.query();
    if (resp.results == null || resp.results!.isEmpty) {
      throw Exception('Interesse não encontrado');
    }
    final interested = resp.results!.first as ParseObject;
    final student = interested.get<ParseObject>('student');

    final tenant = ParseObject('Tenants')
      ..set('student', student)
      ..set('republic', ParseObject('Republic')..objectId = republicId)
      ..set('studentName', interested.get<String>('studentName') ?? 'Nome não informado')
      ..set('studentEmail', interested.get<String>('studentEmail') ?? 'Email não informado');

    final saveResp = await tenant.save();
    if (!saveResp.success) {
      throw Exception(saveResp.error?.message ?? 'Erro ao salvar locatário');
    }
  }
}
