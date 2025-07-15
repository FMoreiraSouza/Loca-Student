// Função auxiliar para converter String? em UserType?
import 'package:loca_student/bloc/user-type/user_type_cubit.dart';

UserType? stringToUserType(String? userTypeString) {
  if (userTypeString == null) return null;
  switch (userTypeString) {
    case 'estudante':
      return UserType.student;
    case 'proprietario':
      return UserType.republic;
    default:
      return null;
  }
}
