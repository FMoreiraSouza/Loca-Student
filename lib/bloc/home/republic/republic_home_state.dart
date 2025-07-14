import 'package:equatable/equatable.dart';
import 'package:loca_student/data/models/university_model.dart';

abstract class RepublicState extends Equatable {
  const RepublicState();

  @override
  List<Object?> get props => [];
}

class RepublicInitial extends RepublicState {}

class RepublicLoading extends RepublicState {}

class RepublicLoaded extends RepublicState {
  final String address;
  final double latitude;
  final double longitude;
  final List<UniversityModel> nearbyUniversities;
  final List<Map<String, dynamic>> republics;

  const RepublicLoaded({
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.nearbyUniversities,
    this.republics = const [],
  });

  @override
  List<Object?> get props => [address, latitude, longitude, nearbyUniversities, republics];

  RepublicLoaded copyWith({
    String? address,
    double? latitude,
    double? longitude,
    List<UniversityModel>? nearbyUniversities,
    List<Map<String, dynamic>>? Republics,
  }) {
    return RepublicLoaded(
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      nearbyUniversities: nearbyUniversities ?? this.nearbyUniversities,
      republics: Republics ?? republics,
    );
  }
}

class RepublicError extends RepublicState {
  final String message;

  const RepublicError({required this.message});

  @override
  List<Object> get props => [message];
}
