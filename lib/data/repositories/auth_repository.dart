// lib/repositories/auth_repository.dart

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class AuthRepository {
  Future<LoginResult> login(String email, String password) async {
    final user = ParseUser(email, password, null);
    final response = await user.login();

    if (response.success && response.result != null) {
      return LoginResult(success: true);
    } else {
      return LoginResult(success: false, message: response.error?.message ?? 'Erro ao fazer login');
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
