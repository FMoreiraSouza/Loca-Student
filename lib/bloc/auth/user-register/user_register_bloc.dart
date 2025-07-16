import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/republic_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/student_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_state.dart';
import 'package:loca_student/data/repositories/auth_repository.dart';
import 'package:loca_student/data/services/geocoding_service.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  final AuthRepository authRepository;
  final GeocodingService geocodingService;

  UserRegisterBloc({required this.authRepository, required this.geocodingService})
    : super(UserRegisterInitial()) {
    on<StudentRegisterSubmitted>(_onStudentRegister);
    on<RepublicRegisterSubmitted>(_onRepublicRegister);
  }

  Future<void> _onStudentRegister(
    StudentRegisterSubmitted event,
    Emitter<UserRegisterState> emit,
  ) async {
    // validações básicas...
    if (event.name.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty ||
        event.degree.isEmpty ||
        event.origin.isEmpty ||
        event.sex.isEmpty) {
      emit(UserRegisterFailure('Preencha todos os campos'));
      return;
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(event.email)) {
      emit(UserRegisterFailure('Email inválido'));
      return;
    }
    if (event.password.length < 8) {
      emit(UserRegisterFailure('A senha deve ter no mínimo 8 caracteres'));
      return;
    }

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
  }

  Future<void> _onRepublicRegister(
    RepublicRegisterSubmitted event,
    Emitter<UserRegisterState> emit,
  ) async {
    // validações básicas...
    if (event.name.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty ||
        event.address.isEmpty ||
        event.city.isEmpty ||
        event.state.isEmpty ||
        event.phone.isEmpty) {
      emit(UserRegisterFailure('Preencha todos os campos'));
      return;
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(event.email)) {
      emit(UserRegisterFailure('Email inválido'));
      return;
    }
    if (event.password.length < 8) {
      emit(UserRegisterFailure('A senha deve ter no mínimo 8 caracteres'));
      return;
    }

    emit(UserRegisterLoading());

    // 1) usar serviço de geocoding
    final coords = await geocodingService.fetchCoordinates(event.city);
    if (coords == null) {
      emit(UserRegisterFailure('Não foi possível obter coordenadas da cidade'));
      return;
    }

    // 2) chamar repositório com lat/lon
    final result = await authRepository.registerRepublic(
      username: event.name,
      value: event.value,
      address: event.address,
      city: event.city,
      state: event.state,
      latitude: coords['latitude']!,
      longitude: coords['longitude']!,
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
  }
}
