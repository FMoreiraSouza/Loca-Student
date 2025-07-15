import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RepublicHomeRepository {
  Future<List<ParseObject>> fetchInterestedStudents(ParseObject currentUserRepublic) async {
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
      return interestResponse.results!.cast<ParseObject>();
    } else {
      throw Exception(interestResponse.error?.message ?? 'Erro ao buscar interessados');
    }
  }

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

  Future<List<ParseObject>> fetchTenants(ParseObject currentUserRepublic) async {
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
      return tenantsResponse.results!.cast<ParseObject>();
    } else {
      throw Exception(tenantsResponse.error?.message ?? 'Erro ao buscar locatários');
    }
  }
}
