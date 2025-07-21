import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login/login_event.dart';
import 'package:loca_student/bloc/auth/login/login_state.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'package:loca_student/bloc/user-type/user_type_cubit.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final UserTypeCubit userTypeCubit;

  LoginBloc({required this.authRepository, required this.userTypeCubit}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(LoginFailure('Preencha todos os campos'));
        return;
      }

      final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
      if (!emailRegex.hasMatch(event.email)) {
        emit(LoginFailure('Email inválido'));
        return;
      }

      if (event.password.length < 8) {
        emit(LoginFailure('A senha deve ter mais do que 8 caracteres'));
        return;
      }

      emit(LoginLoading());

      final result = await authRepository.login(event.email, event.password);

      if (!result.success) {
        emit(LoginFailure(result.message));
        return;
      }

      final userTypeStr = result.userType?.toLowerCase();
      UserType? userType;

      if (userTypeStr == 'estudante') {
        userType = UserType.student;
      } else if (userTypeStr == 'república') {
        userType = UserType.republic;
      }

      if (userType == null || userType != userTypeCubit.state) {
        emit(LoginFailure('Tipo de usuário inválido.'));
        return;
      }

      emit(LoginSuccess(userType));
    });
  }
}
