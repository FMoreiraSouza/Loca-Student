import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/models/student_model.dart';
import 'package:loca_student/data/repositories/interfaces/i_auth_repository.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthRepository implements IAuthRepository {
  @override
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

  @override
  Future<LoginResult> registerStudent({
    required String username,
    required String emailAddress,
    required String password,
    required StudentModel student,
  }) async {
    try {
      final user = ParseUser(username, password, emailAddress)..set('userType', 'estudante');

      final acl = ParseACL();
      acl.setPublicReadAccess(allowed: true);
      acl.setPublicWriteAccess(allowed: true);
      user.setACL(acl);

      final response = await user.signUp();
      if (!response.success || response.result == null) {
        return LoginResult(success: false, message: response.error?.message ?? 'Erro ao cadastrar');
      }

      final createdUser = response.result as ParseUser;

      final studentObj = student.toParse(user: createdUser);

      final extraResponse = await studentObj.save();
      if (!extraResponse.success) {
        return LoginResult(success: false, message: 'Erro ao salvar dados do estudante');
      }

      return LoginResult(success: true, userType: 'estudante');
    } catch (e) {
      return LoginResult(success: false, message: 'Erro: $e');
    }
  }

  @override
  Future<LoginResult> registerRepublic({
    required String username,
    required String emailAddress,
    required String password,
    required RepublicModel republic,
  }) async {
    try {
      final user = ParseUser(username, password, emailAddress)..set('userType', 'república');

      final acl = ParseACL();
      acl.setPublicReadAccess(allowed: true);
      acl.setPublicWriteAccess(allowed: true);
      user.setACL(acl);

      final response = await user.signUp();
      if (!response.success || response.result == null) {
        return LoginResult(success: false, message: response.error?.message ?? 'Erro ao cadastrar');
      }

      final createdUser = response.result as ParseUser;

      final republicObj = republic.toParse(user: createdUser);

      final extraResponse = await republicObj.save();
      if (!extraResponse.success) {
        return LoginResult(success: false, message: 'Erro ao salvar dados da república');
      }

      return LoginResult(success: true, userType: 'república');
    } catch (e) {
      return LoginResult(success: false, message: 'Erro: $e');
    }
  }

  @override
  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    await user?.logout();
  }

  @override
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
