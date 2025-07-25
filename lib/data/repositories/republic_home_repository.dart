﻿import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/tenant_model.dart';
import 'package:loca_student/data/repositories/interfaces/i_republic_home_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RepublicHomeRepository implements IRepublicHomeRepository {
  @override
  Future<List<InterestedStudentModel>> fetchInterestedStudents(ParseUser currentUser) async {
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUser);

    final republicResponse = await republicQuery.query();
    if (republicResponse.results == null || republicResponse.results!.isEmpty) {
      throw Exception('Nenhuma república encontrada para o usuário atual');
    }

    final republic = republicResponse.results!.first;
    final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestedStudents'))
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

  @override
  Future<List<TenantModel>> fetchTenants(ParseUser currentUser) async {
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUser);

    final republicResponse = await republicQuery.query();
    if (republicResponse.results == null || republicResponse.results!.isEmpty) {
      throw Exception('Nenhuma república encontrada');
    }
    final republic = republicResponse.results!.first;
    final tenantsQuery = QueryBuilder<ParseObject>(ParseObject('Tenants'))
      ..whereEqualTo('republic', republic)
      ..whereEqualTo('belongs', true)
      ..orderByDescending('createdAt');

    final tenantsResponse = await tenantsQuery.query();
    if (tenantsResponse.success && tenantsResponse.results != null) {
      return tenantsResponse.results!.map((e) => TenantModel.fromParse(e as ParseObject)).toList();
    } else {
      throw Exception(tenantsResponse.error?.message ?? 'Erro ao buscar locatários');
    }
  }

  @override
  Future<void> updateReservationStatus({
    required String studentId,
    required String republicId,
    required String newStatus,
  }) async {
    final reservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('student', (ParseObject('Student')..objectId = studentId))
      ..whereEqualTo('republic', (ParseObject('Republic')..objectId = republicId));

    final reservationResponse = await reservationQuery.query();
    if (reservationResponse.results != null && reservationResponse.results!.isNotEmpty) {
      final reservationObj = ParseObject('Reservations')
        ..objectId = (reservationResponse.results!.first as ParseObject).objectId
        ..set('status', newStatus);

      final saveResponse = await reservationObj.save();
      if (!saveResponse.success) {
        throw Exception(saveResponse.error?.message ?? 'Erro ao atualizar status da reserva');
      }
    } else {
      throw Exception('Reserva não encontrada para este estudante e república.');
    }
  }

  @override
  Future<void> updateVacancy(String republicId) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', republicId);
    final response = await query.query();
    if (response.results == null || response.results!.isEmpty) {
      throw Exception('República não encontrada para decrementar vaga');
    }
    final republicObj = response.results!.first as ParseObject;
    final currentVacancies = republicObj.get<int>('vacancies') ?? 0;

    final updatedObj = ParseObject('Republic')
      ..objectId = republicObj.objectId
      ..set('vacancies', currentVacancies - 1);

    final saveResponse = await updatedObj.save();
    if (!saveResponse.success) {
      throw Exception(saveResponse.error?.message ?? 'Erro ao decrementar vaga');
    }
  }

  @override
  Future<void> acceptInterestStudent(InterestedStudentModel interested) async {
    final interestObj = interested.toParse(
      republic: ParseObject('Republic')..objectId = interested.republicId,
    )..set('status', 'aceito');

    final resp = await interestObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar interessado');
    }
  }

  @override
  Future<TenantModel?> getTenantByStudentAndRepublic(String studentId, String republicId) async {
    final tenantQuery = QueryBuilder<ParseObject>(ParseObject('Tenants'))
      ..whereEqualTo('student', (ParseObject('Student')..objectId = studentId))
      ..whereEqualTo('republic', (ParseObject('Republic')..objectId = republicId));

    final response = await tenantQuery.query();
    if (response.success && response.results != null && response.results!.isNotEmpty) {
      return TenantModel.fromParse(response.results!.first as ParseObject);
    }
    return null;
  }

  @override
  Future<void> createTenant(TenantModel tenant) async {
    final resp = await tenant.toParse().save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao criar tenant');
    }
  }

  @override
  Future<void> updateTenantBelongs(String tenantObjectId, bool belongs) async {
    final tenantObj = ParseObject('Tenants')
      ..objectId = tenantObjectId
      ..set('belongs', belongs);

    final resp = await tenantObj.save();
    if (!resp.success) {
      throw Exception(resp.error?.message ?? 'Erro ao atualizar tenant');
    }
  }

  @override
  Future<void> updateInterestedStudentStatusAndReservation({
    required InterestedStudentModel interested,
  }) async {
    final updatedInterest = interested.toParse(
      republic: ParseObject('Republic')..objectId = interested.republicId,
    )..set('status', 'recusado');

    final interestResp = await updatedInterest.save();
    if (!interestResp.success) {
      throw Exception(interestResp.error?.message ?? 'Erro ao atualizar status do interessado');
    }

    await updateReservationStatus(
      studentId: interested.studentId,
      republicId: interested.republicId,
      newStatus: 'recusada',
    );
  }

  @override
  Future<void> updateInterestStatus(String studentId, String republicId, String newStatus) async {
    final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestedStudents'))
      ..whereEqualTo('student', ParseObject('Student')..objectId = studentId)
      ..whereEqualTo('republic', ParseObject('Republic')..objectId = republicId);

    final interestResp = await interestQuery.query();
    if (interestResp.results != null && interestResp.results!.isNotEmpty) {
      final interestObj = ParseObject('InterestedStudents')
        ..objectId = (interestResp.results!.first as ParseObject).objectId
        ..set('status', newStatus);
      final saveResp = await interestObj.save();
      if (!saveResp.success) {
        throw Exception(saveResp.error?.message ?? 'Erro ao atualizar interesse');
      }
    }
  }

  @override
  Future<void> incrementVacancy(String republicId) async {
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', republicId);
    final republicResp = await republicQuery.query();
    if (republicResp.results != null && republicResp.results!.isNotEmpty) {
      final republicObj = republicResp.results!.first as ParseObject;
      final currentVacancies = republicObj.get<int>('vacancies') ?? 0;
      final updateRep = ParseObject('Republic')
        ..objectId = republicObj.objectId
        ..set('vacancies', currentVacancies + 1);
      final saveResp = await updateRep.save();
      if (!saveResp.success) {
        throw Exception(saveResp.error?.message ?? 'Erro ao incrementar vaga');
      }
    }
  }
}
