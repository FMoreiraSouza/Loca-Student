import 'package:loca_student/bloc/user-type/user_type_cubit.dart';
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
        final rawMessage = response.error?.message ?? '';
        if (rawMessage.toLowerCase().contains('invalid')) {
          return LoginResult(success: false, message: 'Email ou senha inválidos');
        }
        return LoginResult(success: false, message: 'Erro ao fazer login. Tente novamente.');
      }
    } catch (e) {
      return LoginResult(success: false, message: 'Erro: $e');
    }
  }

  Future<LoginResult> registerStudent({
    required String username,
    required String emailAddress,
    required String password,
    required int age,
    required String degree,
    required String origin,
    required String sex,
  }) async {
    try {
      final user = ParseUser(username, password, emailAddress)
        ..set('userType', UserType.student.toString().split('.').last);

      final response = await user.signUp();
      if (!response.success || response.result == null) {
        return LoginResult(success: false, message: response.error?.message ?? 'Erro ao cadastrar');
      }

      final createdUser = response.result as ParseUser;
      final student = ParseObject('Student')
        ..set('age', age)
        ..set('degree', degree)
        ..set('origin', origin)
        ..set('sex', sex)
        ..set('user', createdUser);

      final extraResponse = await student.save();
      if (!extraResponse.success) {
        return LoginResult(success: false, message: 'Erro ao salvar dados do estudante');
      }

      return LoginResult(success: true, userType: UserType.student.toString().split('.').last);
    } catch (e) {
      return LoginResult(success: false, message: 'Erro: $e');
    }
  }

  Future<LoginResult> registerRepublic({
    required String username,
    required String emailAddress,
    required String password,
    required double value,
    required String address,
    required String city,
    required String state,
    required double latitude,
    required double longitude,
    required int vacancies,
    required String phone,
  }) async {
    try {
      final user = ParseUser(username, password, emailAddress)
        ..set('userType', UserType.republic.toString().split('.').last);

      // Configurar ACL para leitura e escrita públicas
      final acl = ParseACL();
      acl.setPublicReadAccess(allowed: true); // Permite leitura pública
      acl.setPublicWriteAccess(allowed: true); // Permite escrita pública
      user.setACL(acl);

      final response = await user.signUp();
      if (!response.success || response.result == null) {
        return LoginResult(success: false, message: response.error?.message ?? 'Erro ao cadastrar');
      }

      final createdUser = response.result as ParseUser;
      final republic = ParseObject('Republic')
        ..set('value', value)
        ..set('address', address)
        ..set('city', city)
        ..set('state', state)
        ..set('latitude', latitude)
        ..set('longitude', longitude)
        ..set('vacancies', vacancies)
        ..set('phone', phone)
        ..set('user', createdUser);

      final extraResponse = await republic.save();
      if (!extraResponse.success) {
        return LoginResult(success: false, message: 'Erro ao salvar dados do proprietário');
      }

      return LoginResult(success: true, userType: UserType.republic.toString().split('.').last);
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
