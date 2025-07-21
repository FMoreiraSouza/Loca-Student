import 'package:loca_student/data/models/university_model.dart';

class MockData {
  final mockUniversities = [
    UniversityModel(
      name: 'Instituto Jaguar',
      latitude: -4.9392,
      longitude: -37.9758,
      distanceKm: 2.4,
      address: 'Av. Gov. Raul Barbosa, s/n - Catumbela, Russas - CE',
      city: 'Russas',
      state: 'Ceará',
    ),
    UniversityModel(
      name: 'Universidade Russana',
      latitude: -4.9357,
      longitude: -37.9720,
      distanceKm: 1.7,
      address: 'Rua Dr. José Ribeiro, 1440 - Centro, Russas - CE',
      city: 'Russas',
      state: 'Ceará',
    ),
    UniversityModel(
      name: 'Universidade São Carlense',
      latitude: -22.0051,
      longitude: -47.8968,
      distanceKm: 3.5,
      address: 'Av. Trabalhador Sãocarlense, 400 - Parque Arnold Schimidt',
      city: 'São Carlos',
      state: 'São Paulo',
    ),
    UniversityModel(
      name: 'Instituto Paulistano',
      latitude: -22.0082,
      longitude: -47.8976,
      distanceKm: 4.1,
      address: 'Rua 15 de Novembro, 1234, Vila Celina',
      city: 'São Carlos',
      state: 'São Paulo',
    ),
  ];
}
