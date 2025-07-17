import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/tenant_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class RepublicHomeRepository {
  // 🔹 Lista de interessados
  Future<List<InterestedStudentModel>> fetchInterestedStudents(ParseUser currentUser) async {
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUser);

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

  // 🔹 Lista de inquilinos (somente quem ainda pertence)
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
      ..whereEqualTo('belongs', true) // ✅ só quem ainda mora lá
      ..orderByDescending('createdAt');

    final tenantsResponse = await tenantsQuery.query();
    if (tenantsResponse.success && tenantsResponse.results != null) {
      return tenantsResponse.results!.map((e) => TenantModel.fromParse(e as ParseObject)).toList();
    } else {
      throw Exception(tenantsResponse.error?.message ?? 'Erro ao buscar locatários');
    }
  }

  // 🔹 Atualiza status da reserva
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

  // 🔹 Atualiza vagas
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

  // 🔹 Adiciona um inquilino (com belongs=true)
  Future<void> addTenant(ParseObject interested, ParseObject republic) async {
    final studentName = interested.get<String>('studentName') ?? 'Nome não informado';
    final studentEmail = interested.get<String>('studentEmail') ?? 'Email não informado';
    final student = interested.get<ParseObject>('student');

    final tenant = ParseObject('Tenants')
      ..set('student', student)
      ..set('republic', republic)
      ..set('studentName', studentName)
      ..set('studentEmail', studentEmail)
      ..set<bool>('belongs', true)
      ..set<DateTime>('createdAt', DateTime.now());

    final response = await tenant.save();
    if (!response.success) {
      throw Exception(response.error?.message ?? 'Erro ao salvar locatário');
    }
  }

  // 🔹 Aceitar estudante interessado
  Future<void> acceptInterestedStudent({
    required String interestId,
    required String studentId,
    required String republicId,
  }) async {
    await updateReservationStatus(
      ParseObject('Student')..objectId = studentId,
      ParseObject('Republic')..objectId = republicId,
      'aceita',
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

  // 🔹 Cria Tenant a partir do interesse
  Future<void> addTenantFromInterest(String interestId, String republicId) async {
    // 🔎 Busca o interesse com o estudante
    final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
      ..whereEqualTo('objectId', interestId)
      ..includeObject(['student']);
    final resp = await interestQuery.query();
    if (resp.results == null || resp.results!.isEmpty) {
      throw Exception('Interesse não encontrado');
    }
    final interested = resp.results!.first as ParseObject;
    final student = interested.get<ParseObject>('student');

    // 🔎 Verifica se já existe um Tenant desse estudante nessa república
    final tenantQuery = QueryBuilder<ParseObject>(ParseObject('Tenants'))
      ..whereEqualTo('student', student)
      ..whereEqualTo('republic', ParseObject('Republic')..objectId = republicId);
    final tenantResp = await tenantQuery.query();

    if (tenantResp.success && tenantResp.results != null && tenantResp.results!.isNotEmpty) {
      // ✅ Já existe um registro, apenas atualiza belongs para true
      final existingTenant = tenantResp.results!.first as ParseObject;
      existingTenant.set<bool>('belongs', true);
      final saveResp = await existingTenant.save();
      if (!saveResp.success) {
        throw Exception(saveResp.error?.message ?? 'Erro ao atualizar tenant existente');
      }
    } else {
      // ✅ Não existe registro, cria um novo
      final tenant = ParseObject('Tenants')
        ..set('student', student)
        ..set('republic', ParseObject('Republic')..objectId = republicId)
        ..set('studentName', interested.get<String>('studentName') ?? 'Nome não informado')
        ..set('studentEmail', interested.get<String>('studentEmail') ?? 'Email não informado')
        ..set<bool>('belongs', true);

      final saveResp = await tenant.save();
      if (!saveResp.success) {
        throw Exception(saveResp.error?.message ?? 'Erro ao salvar novo tenant');
      }
    }
  }

  // 🔹 Recusar interessado
  Future<void> updateInterestStudentStatusAndReservation({
    required String interestId,
    required String studentId,
    required String republicId,
  }) async {
    final interestObj = ParseObject('InterestStudents')..objectId = interestId;
    interestObj.set<String>('status', 'recusado');
    final interestResp = await interestObj.save();
    if (!interestResp.success) {
      throw Exception(interestResp.error?.message ?? 'Erro ao atualizar status do interessado');
    }

    await updateReservationStatus(
      ParseObject('Student')..objectId = studentId,
      ParseObject('Republic')..objectId = republicId,
      'recusada',
    );
  }

  // 🔹 Remover inquilino (com todas as atualizações extras)
  Future<void> removeTenant(String tenantId) async {
    // 🔎 Busca o Tenant completo, com student e republic
    final tenantQuery = QueryBuilder<ParseObject>(ParseObject('Tenants'))
      ..whereEqualTo('objectId', tenantId)
      ..includeObject(['student', 'republic']);

    final tenantResp = await tenantQuery.query();
    if (tenantResp.results == null || tenantResp.results!.isEmpty) {
      throw Exception('Inquilino não encontrado');
    }

    final tenantObj = tenantResp.results!.first as ParseObject;
    final student = tenantObj.get<ParseObject>('student');
    final republic = tenantObj.get<ParseObject>('republic');

    if (student == null || republic == null) {
      throw Exception('Dados incompletos do inquilino');
    }

    // 1️⃣ Atualizar o tenant para belongs = false
    tenantObj.set<bool>('belongs', false);
    final saveTenant = await tenantObj.save();
    if (!saveTenant.success) {
      throw Exception(saveTenant.error?.message ?? 'Erro ao atualizar tenant');
    }

    // 2️⃣ Atualizar reserva do estudante nessa república para cancelado
    final reservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('student', student)
      ..whereEqualTo('republic', republic);
    final reservationResp = await reservationQuery.query();
    if (reservationResp.results != null && reservationResp.results!.isNotEmpty) {
      final reservation = reservationResp.results!.first as ParseObject;
      reservation.set<String>('status', 'cancelada');
      final saveRes = await reservation.save();
      if (!saveRes.success) {
        throw Exception(saveRes.error?.message ?? 'Erro ao atualizar reserva');
      }
    }

    // 3️⃣ Atualizar InterestStudents para recusado
    final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
      ..whereEqualTo('student', student)
      ..whereEqualTo('republic', republic);
    final interestResp = await interestQuery.query();
    if (interestResp.results != null && interestResp.results!.isNotEmpty) {
      final interest = interestResp.results!.first as ParseObject;
      interest.set<String>('status', 'recusado');
      final saveInterest = await interest.save();
      if (!saveInterest.success) {
        throw Exception(saveInterest.error?.message ?? 'Erro ao atualizar interesse');
      }
    }

    // 4️⃣ Incrementar 1 vaga na república
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', republic.objectId);
    final republicResp = await republicQuery.query();
    if (republicResp.results != null && republicResp.results!.isNotEmpty) {
      final republicObj = republicResp.results!.first as ParseObject;
      final currentVacancies = republicObj.get<int>('vacancies') ?? 0;
      republicObj.set<int>('vacancies', currentVacancies + 1);
      final saveRep = await republicObj.save();
      if (!saveRep.success) {
        throw Exception(saveRep.error?.message ?? 'Erro ao atualizar vagas');
      }
    }
  }
}
