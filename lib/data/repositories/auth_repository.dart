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
    double? value,
    String? address,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
    required String email,
    required String password,
    required UserType? userType,
  }) async {
    try {
      // 1. Cria usuário base
      final user = ParseUser(email, password, email)
        ..set('userType', userType.toString().split('.').last);

      final response = await user.signUp();
      if (!response.success || response.result == null) {
        return LoginResult(success: false, message: response.error?.message ?? 'Erro ao cadastrar');
      }

      // 2. Cria objeto adicional com dados do tipo
      final createdUser = response.result as ParseUser;

      ParseObject additionalData;

      if (userType == UserType.estudante) {
        additionalData = ParseObject('Student')
          ..set('name', name)
          ..set('age', age)
          ..set('degree', degree)
          ..set('origin', origin)
          ..set('sex', sex)
          ..set('university', university)
          ..set('user', createdUser);
      } else {
        additionalData = ParseObject('Owner')
          ..set('name', name)
          ..set('value', value)
          ..set('address', address)
          ..set('city', city)
          ..set('state', state)
          ..set('latitude', latitude)
          ..set('longitude', longitude)
          ..set('user', createdUser);
      }

      final extraResponse = await additionalData.save();
      if (!extraResponse.success) {
        return LoginResult(success: false, message: 'Erro ao salvar dados adicionais');
      }

      return LoginResult(success: true);
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
