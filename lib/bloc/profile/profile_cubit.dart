﻿import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/data/repositories/profile_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;

  ProfileCubit({required this.profileRepository}) : super(const ProfileState());

  Future<void> loadProfile(ParseUser currentUser) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final data = await profileRepository.getUserProfileData(currentUser);
      if (data != null) {
        emit(state.copyWith(status: ProfileStatus.success, profileData: data));
      } else {
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: 'Usuário não encontrado'));
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> logout(ParseUser currentUser) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await profileRepository.logout(currentUser);
      emit(const ProfileState(status: ProfileStatus.initial));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }
}
