import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class HomeRepository {
  Future<List<ParseObject>> searchRepublicsByCity(String city) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('city', city)
      ..includeObject(['user']);

    final response = await query.query();
    if (response.success && response.results != null) {
      return response.results!.cast<ParseObject>();
    } else {
      throw Exception(response.error?.message ?? 'Erro ao buscar repúblicas');
    }
  }

  Future<void> reserveSpot({required String objectId, required int currentVacancies}) async {
    if (currentVacancies <= 0) throw Exception('Sem vagas disponíveis');

    // 1. Usuário atual
    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) throw Exception('Usuário não autenticado');

    // 2. Busca o objeto Student associado ao usuário atual
    final studentQuery = QueryBuilder<ParseObject>(ParseObject('Student'))
      ..whereEqualTo('user', currentUser);

    final studentResult = await studentQuery.query();

    if (!studentResult.success || studentResult.results == null || studentResult.results!.isEmpty) {
      throw Exception('Estudante não encontrado para o usuário atual');
    }

    final student = studentResult.results!.first as ParseObject;

    // 👇 Pega nome e email do estudante (ajuste aqui para seus campos)
    final studentName =
        student.get<String>('name') ?? currentUser.get<String>('username') ?? 'Nome não informado';
    final studentEmail =
        student.get<String>('email') ?? currentUser.get<String>('email') ?? 'Email não informado';

    final republicPointer = ParseObject('Republic')..objectId = objectId;

    // 3. Verifica se já existe uma reserva para essa república e estudante
    final existingReservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('republic', republicPointer)
      ..whereEqualTo('student', student);

    final existingReservationResponse = await existingReservationQuery.query();

    if (existingReservationResponse.success &&
        existingReservationResponse.results != null &&
        existingReservationResponse.results!.isNotEmpty) {
      throw Exception('Você já fez uma reserva para essa república.');
    }

    // 4. Busca dados da república para salvar na reserva
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', objectId)
      ..includeObject(['user']);

    final result = await republicQuery.query();

    if (!result.success || result.results == null || result.results!.isEmpty) {
      throw Exception('Erro ao buscar dados da república para reserva');
    }

    final republic = result.results!.first as ParseObject;
    final user = republic.get<ParseObject>('user');

    // 6. Cria reserva na tabela Reservations
    final reservation = ParseObject('Reservations')
      ..set('username', user?['username'] ?? 'Desconhecido')
      ..set('address', republic['address'] ?? '')
      ..set('city', republic['city'] ?? '')
      ..set('state', republic['state'] ?? '')
      ..set('value', (republic['value'] as num?)?.toDouble() ?? 0.0)
      ..set('status', 'pendente')
      ..set('republic', republic)
      ..set('student', student);

    final createReservation = await reservation.save();

    if (!createReservation.success) {
      throw Exception(createReservation.error?.message ?? 'Erro ao salvar reserva');
    }

    // 7. Cria registro na tabela InterestStudents com nome e email já preenchidos
    final interestStudent = ParseObject('InterestStudents')
      ..set('student', student)
      ..set('republic', republic)
      ..set('status', 'interessado')
      ..set('studentName', studentName) // ✅ salva o nome direto
      ..set('studentEmail', studentEmail) // ✅ salva o email direto
      ..set('createdAt', DateTime.now());

    final interestSave = await interestStudent.save();

    if (!interestSave.success) {
      throw Exception(interestSave.error?.message ?? 'Erro ao salvar interesse do estudante');
    }
  }

  Future<List<ParseObject>> fetchReservations() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..orderByDescending('createdAt');

    final response = await query.query();

    if (response.success && response.results != null) {
      return response.results!.cast<ParseObject>();
    } else {
      throw Exception(response.error?.message ?? 'Erro ao buscar reservas');
    }
  }

  Future<void> cancelReservation(ParseObject reservation) async {
    reservation.set('status', 'cancelado');
    final response = await reservation.save();

    if (!response.success) {
      throw Exception(response.error?.message ?? 'Erro ao cancelar reserva');
    }
  }

  Future<void> reactivateReservation(ParseObject reservation) async {
    reservation.set('status', 'pendente');
    final response = await reservation.save();

    if (!response.success) {
      throw Exception(response.error?.message ?? 'Erro ao reativar reserva');
    }
  }

  Future<List<ParseObject>> fetchRepublicReservations(ParseObject currentUser) async {
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUser);

    final republicResponse = await republicQuery.query();

    if (!republicResponse.success ||
        republicResponse.results == null ||
        republicResponse.results!.isEmpty) {
      throw Exception('Nenhuma república encontrada para o usuário atual');
    }

    final republic = republicResponse.results!.first;

    final reservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('republic', republic)
      ..orderByDescending('createdAt');

    final reservationResponse = await reservationQuery.query();

    if (reservationResponse.success && reservationResponse.results != null) {
      return reservationResponse.results!.cast<ParseObject>();
    } else {
      throw Exception(reservationResponse.error?.message ?? 'Erro ao buscar reservas');
    }
  }

  Future<ParseUser?> getCurrentUser() async {
    return await ParseUser.currentUser() as ParseUser?;
  }

  Future<List<ParseObject>> fetchInterestedStudents(ParseObject currentUserRepublic) async {
    // Primeiro busca a república do usuário atual
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUserRepublic);

    final republicResponse = await republicQuery.query();

    if (!republicResponse.success ||
        republicResponse.results == null ||
        republicResponse.results!.isEmpty) {
      throw Exception('Nenhuma república encontrada para o usuário atual');
    }

    final republic = republicResponse.results!.first;

    // 🔥 Aqui filtramos apenas interessados com status = "pendente"
    final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
      ..whereEqualTo('republic', republic)
      ..whereEqualTo('status', 'interessado') // 👈 FILTRO AQUI
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

    if (reservationResponse.success &&
        reservationResponse.results != null &&
        reservationResponse.results!.isNotEmpty) {
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
    if (!republicResponse.success ||
        republicResponse.results == null ||
        republicResponse.results!.isEmpty) {
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

  Future<void> updateVacancy(ParseObject republic) async {
    // busca o republic atualizado
    final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', republic.objectId);

    final response = await query.query();

    if (!response.success || response.results == null || response.results!.isEmpty) {
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
}
