import 'package:flutter_bloc/flutter_bloc.dart';

enum UserType { estudante, proprietario }

class UserTypeCubit extends Cubit<UserType?> {
  UserTypeCubit() : super(null);

  void setUserType(UserType type) {
    if (state != type) {
      emit(type);
    }
  }
}
