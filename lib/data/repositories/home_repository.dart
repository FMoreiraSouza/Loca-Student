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

    // 4. Atualiza a vaga na república
    final republicObject = ParseObject('Republic')..objectId = objectId;
    republicObject.set('vacancies', currentVacancies - 1);
    final saveResponse = await republicObject.save();

    if (!saveResponse.success) {
      throw Exception(saveResponse.error?.message ?? 'Erro ao atualizar vagas');
    }

    // 5. Busca dados da república para salvar na reserva
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

    // 7. Cria registro na tabela InterestStudents
    final interestStudent = ParseObject('InterestStudents')
      ..set('student', student)
      ..set('republic', republic)
      ..set('status', 'interested')
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
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('user', currentUserRepublic);

    final republicResponse = await republicQuery.query();

    if (!republicResponse.success ||
        republicResponse.results == null ||
        republicResponse.results!.isEmpty) {
      throw Exception('Nenhuma república encontrada para o usuário atual');
    }

    final republic = republicResponse.results!.first;

    final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
      ..whereEqualTo('republic', republic)
      ..orderByDescending('createdAt');

    final interestResponse = await interestQuery.query();

    if (interestResponse.success && interestResponse.results != null) {
      return interestResponse.results!.cast<ParseObject>();
    } else {
      throw Exception(interestResponse.error?.message ?? 'Erro ao buscar interessados');
    }
  }
}
