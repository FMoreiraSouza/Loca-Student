import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/login_event.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());

      final result = await authRepository.login(event.email, event.password);

      if (result.success) {
        final userTypeStr = result.userType?.toLowerCase();
        UserType? userType;

        if (userTypeStr == 'estudante') {
          userType = UserType.student;
        } else if (userTypeStr == 'proprietario') {
          userType = UserType.republic;
        }

        if (userType != null) {
          emit(LoginSuccess(userType));
        } else {
          emit(LoginFailure('Tipo de usuário inválido.'));
        }
      } else {
        emit(LoginFailure(result.message));
      }
    });
  }
}
