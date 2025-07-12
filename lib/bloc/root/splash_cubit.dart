import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';

enum SplashState { initial, navigateToUserType, navigateToHome }

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository authRepository;

  SplashCubit({required this.authRepository}) : super(SplashState.initial) {
    startSplashTimer();
  }

  Future<void> startSplashTimer() async {
    await Future.delayed(const Duration(seconds: 3));

    // Verificar se o usuário está logado
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      emit(SplashState.navigateToHome);
    } else {
      emit(SplashState.navigateToUserType);
    }
  }
}
