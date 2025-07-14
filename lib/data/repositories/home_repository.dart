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

    final republicObject = ParseObject('Republic')..objectId = objectId;
    republicObject.set('vacancies', currentVacancies - 1);
    final saveResponse = await republicObject.save();

    if (!saveResponse.success) {
      throw Exception(saveResponse.error?.message ?? 'Erro ao atualizar vagas');
    }

    final republicQuery = QueryBuilder<ParseObject>(ParseObject('Republic'))
      ..whereEqualTo('objectId', objectId)
      ..includeObject(['user']);

    final result = await republicQuery.query();

    if (!result.success || result.results == null || result.results!.isEmpty) {
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
      ..set('republic', republic);

    final createReservation = await reservation.save();

    if (!createReservation.success) {
      throw Exception(createReservation.error?.message ?? 'Erro ao salvar reserva');
    }
  }

  // Novo método para buscar reservas usando Parse SDK
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
}
