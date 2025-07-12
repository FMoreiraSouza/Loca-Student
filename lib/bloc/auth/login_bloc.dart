import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login_event.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      final result = await authRepository.login(event.email, event.password);

      if (result.success) {
        emit(LoginSuccess());
      } else {
        emit(LoginFailure(result.message));
      }
    });
  }
}
