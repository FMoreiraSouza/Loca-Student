import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loca_student/data/services/shared_preferences_service.dart';

enum UserType { estudante, proprietario }

class UserTypeCubit extends Cubit<UserType?> {
  UserTypeCubit() : super(null);

  Future<void> setUserType(UserType type) async {
    if (state != type) {
      await SharedPreferencesService().saveString('user_type', type.name);
      emit(type);
    }
  }
}
