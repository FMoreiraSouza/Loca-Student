class LoginResult {
  final bool success;
  final String message;
  final String? userType;

  LoginResult({required this.success, this.message = '', this.userType});
}
