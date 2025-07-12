import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user_register_event.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'user_register_state.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  final AuthRepository authRepository;

  UserRegisterBloc({required this.authRepository}) : super(UserRegisterInitial()) {
    on<UserRegisterSubmitted>((event, emit) async {
      emit(UserRegisterLoading());

      final userType = RepositoryProvider.of<UserTypeCubit>(event.context).state;
      final result = await authRepository.register(
        name: event.name,
        age: event.age,
        degree: event.degree,
        origin: event.origin,
        sex: event.sex,
        university: event.university,
        propertyType: event.propertyType,
        value: event.value,
        address: event.address,
        email: event.email,
        password: event.password,
        userType: userType,
      );

      if (result.success) {
        emit(UserRegisterSuccess());
      } else {
        emit(UserRegisterFailure(result.message));
      }
    });
  }
}
