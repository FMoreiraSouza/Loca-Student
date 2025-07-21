import 'package:flutter_test/flutter_test.dart';
import 'package:loca_student/utils/calculate_coordinates.dart';
import 'package:loca_student/utils/mock_universities.dart';

void main() {
  final mockData = MockData();

  group('getNearbyUniversitiesDistanceMessages', () {
    test('retorna lista vazia quando nenhuma universidade está próxima', () {
      final longe = mockData.mockUniversities[2];

      final messages = CalculateCoordinates().getNearbyUniversitiesDistanceMessages(
        latitude: 0,
        longitude: 0,
        universities: [longe],
      );
      expect(messages, isEmpty);
    });

    test('retorna mensagem formatada para universidades próximas', () {
      final messages = CalculateCoordinates().getNearbyUniversitiesDistanceMessages(
        latitude: -4.9380,
        longitude: -37.9740,
        universities: [mockData.mockUniversities[0], mockData.mockUniversities[1]],
        maxDistanceKm: 5.0,
      );

      expect(messages, isNotEmpty);
      expect(messages.first, contains('km'));
      expect(messages.first, contains(mockData.mockUniversities[0].name));
    });
  });
}
