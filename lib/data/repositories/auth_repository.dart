import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:loca_student/bloc/user_type/user_type_cubit.dart';

class AuthRepository {
  Future<LoginResult> login(String email, String password) async {
    try {
      final user = ParseUser(email, password, null);
      final response = await user.login();
      if (response.success && response.result != null) {
        return LoginResult(success: true);
      } else {
        return LoginResult(
          success: false,
          message: response.error?.message ?? 'Erro ao fazer login',
        );
      }
    } catch (e) {
      return LoginResult(success: false, message: 'Erro: $e');
    }
  }

  Future<LoginResult> register({
    required String name,
    int? age,
    String? degree,
    String? origin,
    String? sex,
    String? university,
    String? propertyType,
    double? value,
    String? address,
    required String email,
    required String password,
    required UserType? userType,
  }) async {
    try {
      final user = ParseUser(email, password, email)
        ..set('name', name)
        ..set('userType', userType.toString().split('.').last);
      if (userType == UserType.estudante) {
        if (age != null) user.set('age', age);
        if (degree != null) user.set('degree', degree);
        if (origin != null) user.set('origin', origin);
        if (sex != null) user.set('sex', sex);
        if (university != null) user.set('university', university);
      } else if (userType == UserType.proprietario) {
        if (propertyType != null) user.set('propertyType', propertyType);
        if (value != null) user.set('value', value);
        if (address != null) user.set('address', address);
      }

      final response = await user.signUp();
      if (response.success && response.result != null) {
        return LoginResult(success: true);
      } else {
        return LoginResult(success: false, message: response.error?.message ?? 'Erro ao cadastrar');
      }
    } catch (e) {
      return LoginResult(success: false, message: 'Erro: $e');
    }
  }

  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    await user?.logout();
  }

  Future<bool> isLoggedIn() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    return user != null;
  }
}

class LoginResult {
  final bool success;
  final String message;

  LoginResult({required this.success, this.message = ''});
}
