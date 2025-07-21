import 'package:flutter_test/flutter_test.dart';
import 'package:loca_student/utils/calculate_coordinates.dart';

void main() {
  group('calculateDistanceKm', () {
    test('retorna 0 quando coordenadas são iguais', () {
      expect(CalculateCoordinates().calculateDistanceKm(0, 0, 0, 0), 0);
    });

    test('retorna distância aproximada entre SP e RJ', () {
      final distance = CalculateCoordinates().calculateDistanceKm(
        -23.5505,
        -46.6333,
        -22.9068,
        -43.1729,
      );
      expect(distance, closeTo(357, 10));
    });
  });
}
