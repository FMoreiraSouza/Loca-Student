import 'package:equatable/equatable.dart';
import 'package:loca_student/data/models/university.dart';

abstract class OwnerState extends Equatable {
  const OwnerState();

  @override
  List<Object?> get props => [];
}

class OwnerInitial extends OwnerState {}

class OwnerLoading extends OwnerState {}

class OwnerLoaded extends OwnerState {
  final String address;
  final double latitude;
  final double longitude;
  final List<University> nearbyUniversities;
  final List<Map<String, dynamic>> alojamentos;

  const OwnerLoaded({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.nearbyUniversities,
    this.alojamentos = const [],
  });

  @override
  List<Object?> get props => [address, latitude, longitude, nearbyUniversities, alojamentos];

  OwnerLoaded copyWith({
    String? address,
    double? latitude,
    double? longitude,
    List<University>? nearbyUniversities,
    List<Map<String, dynamic>>? alojamentos,
  }) {
    return OwnerLoaded(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      nearbyUniversities: nearbyUniversities ?? this.nearbyUniversities,
      alojamentos: alojamentos ?? this.alojamentos,
    );
  }
}

class OwnerError extends OwnerState {
  final String message;

  const OwnerError({required this.message});

  @override
  List<Object> get props => [message];
}
