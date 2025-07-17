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

    // 🔎 Busca o objeto Student associado ao usuário atual
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

    // 🔍 Buscar qualquer reserva existente para este estudante nesta república (independente do status)
    final existingReservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('republic', republicPointer)
      ..whereEqualTo('student', student);

    final existingReservationResponse = await existingReservationQuery.query();

    if (existingReservationResponse.results != null &&
        existingReservationResponse.results!.isNotEmpty) {
      final existingReservation = existingReservationResponse.results!.first as ParseObject;
      final status = existingReservation.get<String>('status');

      if (status != null && status != 'cancelado') {
        // Já existe uma reserva ativa (pendente ou aceita)
        throw Exception('Você já fez uma reserva para essa república.');
      } else {
        // Existe, mas está cancelada → atualizar em vez de criar
        existingReservation.set('status', 'pendente');
        final updateResponse = await existingReservation.save();
        if (!updateResponse.success) {
          throw Exception(updateResponse.error?.message ?? 'Erro ao atualizar reserva existente');
        }

        // ✅ Atualiza também o status já existente na tabela InterestStudents
        final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
          ..whereEqualTo('student', student)
          ..whereEqualTo('republic', republicPointer);

        final interestResult = await interestQuery.query();
        if (interestResult.success &&
            interestResult.results != null &&
            interestResult.results!.isNotEmpty) {
          final interestObj = interestResult.results!.first as ParseObject;
          interestObj.set('status', 'interessado');
          final updateInterest = await interestObj.save();
          if (!updateInterest.success) {
            throw Exception(
              updateInterest.error?.message ?? 'Erro ao atualizar interesse do estudante',
            );
          }
        }
        // 👉 Se não encontrar nenhum InterestStudents, não cria, apenas segue.
        return;
      }
    }

    // 🔹 Caso não exista nenhuma reserva ainda, cria normalmente
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

  Future<void> cancelReservation(String reservationId) async {
    // 🔹 Busca a reserva para obter o student e a republic
    final reservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('objectId', reservationId)
      ..includeObject(['student', 'republic']);

    final reservationResult = await reservationQuery.query();
    if (reservationResult.success &&
        reservationResult.results != null &&
        reservationResult.results!.isNotEmpty) {
      final reservation = reservationResult.results!.first as ParseObject;

      // ✅ Atualiza status da reserva
      reservation.set('status', 'cancelado');
      final response = await reservation.save();
      if (!response.success) {
        throw Exception(response.error?.message ?? 'Erro ao cancelar reserva');
      }

      // ✅ Atualiza status do InterestStudents
      final student = reservation.get<ParseObject>('student');
      final republic = reservation.get<ParseObject>('republic');

      if (student != null && republic != null) {
        final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
          ..whereEqualTo('student', student)
          ..whereEqualTo('republic', republic);

        final interestResult = await interestQuery.query();
        if (interestResult.success &&
            interestResult.results != null &&
            interestResult.results!.isNotEmpty) {
          final interestObj = interestResult.results!.first as ParseObject;
          interestObj.set('status', 'desinteressado');
          final updateInterest = await interestObj.save();
          if (!updateInterest.success) {
            throw Exception(
              updateInterest.error?.message ?? 'Erro ao atualizar interesse do estudante',
            );
          }
        }
      }
    } else {
      throw Exception('Reserva não encontrada');
    }
  }

  Future<void> resendReserve(String reservationId) async {
    // Busca a reserva
    final reservationQuery = QueryBuilder<ParseObject>(ParseObject('Reservations'))
      ..whereEqualTo('objectId', reservationId)
      ..includeObject(['student', 'republic']);

    final reservationResult = await reservationQuery.query();
    if (reservationResult.success &&
        reservationResult.results != null &&
        reservationResult.results!.isNotEmpty) {
      final reservation = reservationResult.results!.first as ParseObject;

      // ✅ Atualiza a reserva para pendente
      reservation.set('status', 'pendente');
      final saveResp = await reservation.save();
      if (!saveResp.success) {
        throw Exception(saveResp.error?.message ?? 'Erro ao reenviar reserva');
      }

      // ✅ Atualiza também na InterestStudents
      final student = reservation.get<ParseObject>('student');
      final republic = reservation.get<ParseObject>('republic');

      if (student != null && republic != null) {
        final interestQuery = QueryBuilder<ParseObject>(ParseObject('InterestStudents'))
          ..whereEqualTo('student', student)
          ..whereEqualTo('republic', republic);

        final interestResp = await interestQuery.query();
        if (interestResp.success &&
            interestResp.results != null &&
            interestResp.results!.isNotEmpty) {
          final interestObj = interestResp.results!.first as ParseObject;
          interestObj.set('status', 'interessado');
          final updateInterest = await interestObj.save();
          if (!updateInterest.success) {
            throw Exception(
              updateInterest.error?.message ?? 'Erro ao atualizar interesse do estudante',
            );
          }
        }
      }
    } else {
      throw Exception('Reserva não encontrada para reenviar');
    }
  }
}
