import 'dart:math';
import 'package:loca_student/data/models/university_model.dart';

class CalculateCoordinates {
  List<String> getNearbyUniversitiesDistanceMessages({
    required double latitude,
    required double longitude,
    required List<UniversityModel> universities,
    double maxDistanceKm = 50.0,
  }) {
    final nearby = universities
        .map((university) {
          final distance = calculateDistanceKm(
            latitude,
            longitude,
            university.latitude,
            university.longitude,
          );
          return {'university': university, 'distance': distance};
        })
        .where((entry) => (entry['distance'] as double) <= maxDistanceKm)
        .toList();

    nearby.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

    return nearby.map((entry) {
      final university = entry['university'] as UniversityModel;
      final distance = (entry['distance'] as double).toStringAsFixed(2);
      return 'A $distance km de ${university.name}';
    }).toList();
  }

  double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadius = 6371;

    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * pi / 180;
}
