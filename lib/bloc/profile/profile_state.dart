import 'package:equatable/equatable.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final Map<String, dynamic>? profileData;
  final String? errorMessage;

  const ProfileState({this.status = ProfileStatus.initial, this.profileData, this.errorMessage});

  ProfileState copyWith({
    ProfileStatus? status,
    Map<String, dynamic>? profileData,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profileData: profileData ?? this.profileData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profileData, errorMessage];
}
