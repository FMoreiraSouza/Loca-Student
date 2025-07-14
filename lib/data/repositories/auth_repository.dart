import 'package:loca_student/bloc/user_type/user_type_cubit.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthRepository {
  Future<LoginResult> login(String email, String password) async {
    try {
      final user = ParseUser(email, password, null);
      final response = await user.login();

      if (response.success && response.result != null) {
        final currentUser = response.result as ParseUser;

        final userType = currentUser.get<String>('userType');
        if (userType == null || userType.isEmpty) {
          return LoginResult(success: false, message: 'Tipo de usuário não encontrado');
        }

        return LoginResult(success: true, userType: userType);
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
    required String username,
    required String emailAddress,
    required String password,
    required UserType? userType,
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
  }) async {
    try {
      // Cria usuário base
      final user = ParseUser(username, password, emailAddress)
        ..set('userType', userType.toString().split('.').last);

      final response = await user.signUp();
      if (!response.success || response.result == null) {
        return LoginResult(success: false, message: response.error?.message ?? 'Erro ao cadastrar');
      }

      final createdUser = response.result as ParseUser;
      ParseObject additionalData;

      if (userType == UserType.estudante) {
        additionalData = ParseObject('Student')
          ..set('age', age)
          ..set('degree', degree)
          ..set('origin', origin)
          ..set('sex', sex)
          ..set('university', university)
          ..set('user', createdUser);
      } else {
        additionalData = ParseObject('Owner')
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

      return LoginResult(success: true, userType: userType.toString().split('.').last);
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
  final String? userType;

  LoginResult({required this.success, this.message = '', this.userType});
}
