import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/bloc/auth/user-register/republic_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/student_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_event.dart';
import 'package:loca_student/bloc/auth/user-register/user_register_state.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/models/student_model.dart';
import 'package:loca_student/data/repositories/interfaces/i_auth_repository.dart';
import 'package:loca_student/data/services/geocoding_service.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {
  final IAuthRepository authRepository;
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
    if (event.name.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty ||
        event.origin.isEmpty) {
      emit(UserRegisterFailure('Preencha todos os campos'));
      return;
    }
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(event.email)) {
      emit(UserRegisterFailure('Email inválido'));
      return;
    }
    if (event.password.length < 8) {
      emit(UserRegisterFailure('A senha deve ter mais do que 8 caracteres'));
      return;
    }

    emit(UserRegisterLoading());

    final result = await authRepository.registerStudent(
      username: event.name,
      emailAddress: event.email,
      password: event.password,
      student: StudentModel(
        age: event.age,
        origin: event.origin,
        phone: event.phone,
        username: event.name,
        email: event.email,
      ),
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
      emit(UserRegisterFailure('A senha deve ter mais do que 8 caracteres'));
      return;
    }

    emit(UserRegisterLoading());

    final coords = await geocodingService.fetchCoordinates(event.city);
    if (coords == null) {
      emit(UserRegisterFailure('Não foi possível obter coordenadas da cidade'));
      return;
    }

    final result = await authRepository.registerRepublic(
      username: event.name,
      emailAddress: event.email,
      password: event.password,
      republic: RepublicModel(
        value: event.value,
        address: event.address,
        city: event.city,
        state: event.state,
        latitude: coords['latitude']!,
        longitude: coords['longitude']!,
        vacancies: event.vacancies,
        phone: event.phone,
        username: event.name,
        email: event.email,
      ),
    );

    if (result.success) {
      emit(UserRegisterSuccess());
    } else {
      emit(UserRegisterFailure(result.message));
    }
  }
}
