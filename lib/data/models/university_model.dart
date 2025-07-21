import 'package:equatable/equatable.dart';

class UniversityModel extends Equatable {
  final String name;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String address;
  final String city;
  final String state;

  const UniversityModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.address,
    required this.city,
    required this.state,
  });

  @override
  List<Object> get props => [name, latitude, longitude, distanceKm, address, city, state];
}
