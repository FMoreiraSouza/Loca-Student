import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(const ProfileState());

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final data = await _profileRepository.getUserProfileData();
      if (data != null) {
        emit(state.copyWith(status: ProfileStatus.success, profileData: data));
      } else {
        emit(state.copyWith(status: ProfileStatus.failure, errorMessage: 'Usuário não encontrado'));
      }
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _profileRepository.logout();
      // Pode emitir um estado específico para logout feito
      emit(const ProfileState(status: ProfileStatus.initial));
      // Ou você pode adicionar uma lógica para redirecionar o usuário (ex: emit LogoutSuccess)
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure, errorMessage: e.toString()));
    }
  }
}
