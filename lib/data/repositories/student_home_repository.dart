import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/models/reservation_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class StudentHomeRepository {
  Future<List<RepublicModel>> searchRepublicsByCity(String city) async {
    final query = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('city', city)
      ..includeObject(['user']);

    final response = await query.query();
    if (response.success && response.results != null) {
      // Aqui você já transforma para RepublicModel
      return response.results!.map((obj) {
        final user = obj.get<ParseObject>('user');
        return RepublicModel(
          objectId: obj.objectId ?? '',
          username: user?['username'] ?? 'Desconhecido',
          email: obj['email'] ?? '',
          phone: obj['phone'] ?? '',
          address: obj['address'] ?? '',
          city: obj['city'] ?? '',
          state: obj['state'] ?? '',
          value: (obj['value'] as num?)?.toDouble() ?? 0.0,
          vacancies: (obj['vacancies'] as num?)?.toInt() ?? 0,
          latitude: (obj['latitude'] as num?)?.toDouble() ?? 0.0,
          longitude: (obj['longitude'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
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

    final existingReservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('republic', republicPointer)
      ..whereEqualTo('student', student)
      ..whereNotEqualTo('status', 'cancelado');

    final existingReservationResponse = await existingReservationQuery.query();
    if (existingReservationResponse.results != null &&
        existingReservationResponse.results!.isNotEmpty) {
      throw Exception('Você já fez uma reserva para essa república.');
    }

    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', objectId)
      ..includeObject(['user']);

    final result = await republicQuery.query();
    if (result.results == null || result.results!.isEmpty) {
      throw Exception('Erro ao buscar dados da república para reserva');
    }

    final republic = result.results!.first as ParseObject;
    final user = republic.get<ParseObject>('user');

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

  Future<List<ReservationModel>> fetchReservations() async {
    final query = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereContainedIn('status', ['pendente', 'aceito'])
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

  Future<void> cancelReservation(String reservationId) async {
    final reservation = ParseObject('Reservations')..objectId = reservationId;
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
