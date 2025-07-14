// Função auxiliar para converter String? em UserType?
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';

UserType? stringToUserType(String? userTypeString) {
  if (userTypeString == null) return null;
  switch (userTypeString) {
    case 'estudante':
      return UserType.estudante;
    case 'proprietario':
      return UserType.proprietario;
    default:
      return null;
  }
}
