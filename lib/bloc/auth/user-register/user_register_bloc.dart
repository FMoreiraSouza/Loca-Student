import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/republic_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/student_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_state.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  final AuthRepository authRepository;

  UserRegisterBloc({required this.authRepository}) : super(UserRegisterInitial()) {
    on<StudentRegisterSubmitted>((event, emit) async {
      emit(UserRegisterLoading());

      final result = await authRepository.registerStudent(
        username: event.name,
        age: event.age,
        degree: event.degree,
        origin: event.origin,
        sex: event.sex,
        emailAddress: event.email,
        password: event.password,
      );

      if (result.success) {
        emit(UserRegisterSuccess());
      } else {
        emit(UserRegisterFailure(result.message));
      }
    });

    on<RepublicRegisterSubmitted>((event, emit) async {
      emit(UserRegisterLoading());

      final result = await authRepository.registerRepublic(
        username: event.name,
        value: event.value,
        address: event.address,
        city: event.city,
        state: event.state,
        latitude: event.latitude,
        longitude: event.longitude,
        emailAddress: event.email,
        password: event.password,
        phone: event.phone,
        vacancies: event.vacancies,
      );

      if (result.success) {
        emit(UserRegisterSuccess());
      } else {
        emit(UserRegisterFailure(result.message));
      }
    });
  }
}
