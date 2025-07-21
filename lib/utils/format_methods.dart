import 'package:loca_student/bloc/user-type/user_type_cubit.dart';

class FormatMethods {
  UserType? stringToUserType(String? userTypeString) {
    if (userTypeString == null) return null;
    switch (userTypeString) {
      case 'estudante':
        return UserType.student;
      case 'república':
        return UserType.republic;
      default:
        return null;
    }
  }

  String applyPhoneMask(String input) {
    String digits = input.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    String result = '';
    for (int i = 0; i < digits.length; i++) {
      if (i == 0) result += '(';
      if (i == 2) result += ') ';
      if (i == 7) result += '-';
      result += digits[i];
    }

    return result;
  }
}
