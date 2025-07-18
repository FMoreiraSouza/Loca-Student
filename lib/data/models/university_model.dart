﻿import 'package:equatable/equatable.dart';

class UniversityModel extends Equatable {
  final String name;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final String city;
  final String address;

  const UniversityModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.city,
    required this.address,
  });

  @override
  List<Object> get props => [name, latitude, longitude, distanceKm, city, address];
}
