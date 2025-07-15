import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentHomeRepository {
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

    final currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) throw Exception('Usuário não autenticado');

    // Busca o objeto Student associado ao usuário atual
    final studentQuery = QueryBuilder<ParseObject>(ParseObject('Student'))
      ..whereEqualTo('user', currentUser);

    final studentResult = await studentQuery.query();
    if (studentResult.results == null || studentResult.results!.isEmpty) {
      throw Exception('Estudante não encontrado para o usuário atual');
    }

    final student = studentResult.results!.first as ParseObject;

    final studentName =
        student.get<String>('name') ?? currentUser.get<String>('username') ?? 'Nome não informado';
    final studentEmail =
        student.get<String>('email') ?? currentUser.get<String>('email') ?? 'Email não informado';

    final republicPointer = ParseObject('Republic')..objectId = objectId;

    // Verifica se já existe uma reserva
    final existingReservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('republic', republicPointer)
      ..whereEqualTo('student', student);

    final existingReservationResponse = await existingReservationQuery.query();
    if (existingReservationResponse.results != null &&
        existingReservationResponse.results!.isNotEmpty) {
      throw Exception('Você já fez uma reserva para essa república.');
    }

    // Busca dados da república
    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', objectId)
      ..includeObject(['user']);

    final result = await republicQuery.query();
    if (result.results == null || result.results!.isEmpty) {
      throw Exception('Erro ao buscar dados da república para reserva');
    }

    final republic = result.results!.first as ParseObject;
    final user = republic.get<ParseObject>('user');

    // Cria reserva
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

    // Cria registro de interesse
    final interestStudent = ParseObject('InterestStudents')
      ..set('student', student)
      ..set('republic', republic)
      ..set('status', 'interessado')
      ..set('studentName', studentName)
      ..set('studentEmail', studentEmail)
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
}
