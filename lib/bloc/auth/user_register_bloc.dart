import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/owner_register_event.dart';
import 'package:loca_student/bloc/auth/student_register_event.dart';
import 'package:loca_student/bloc/auth/user_register_state.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  final AuthRepository authRepository;

  UserRegisterBloc({required this.authRepository}) : super(UserRegisterInitial()) {
    on<StudentRegisterSubmitted>((event, emit) async {
      emit(UserRegisterLoading());

      final result = await authRepository.register(
        username: event.name,
        age: event.age,
        degree: event.degree,
        origin: event.origin,
        sex: event.sex,
        university: event.university,
        emailAddress: event.email,
        password: event.password,
        userType: UserType.estudante,
      );

      if (result.success) {
        emit(UserRegisterSuccess());
      } else {
        emit(UserRegisterFailure(result.message));
      }
    });

    on<OwnerRegisterSubmitted>((event, emit) async {
      emit(UserRegisterLoading());

      final result = await authRepository.register(
        username: event.name,
        value: event.value,
        address: event.address,
        city: event.city,
        state: event.state,
        latitude: event.latitude,
        longitude: event.longitude,
        emailAddress: event.email,
        password: event.password,
        userType: UserType.proprietario,
      );

      if (result.success) {
        emit(UserRegisterSuccess());
      } else {
        emit(UserRegisterFailure(result.message));
      }
    });
  }
}
