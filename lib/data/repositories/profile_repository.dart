import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class ProfileRepository {
  /// Retorna o usuário logado atual como ParseUser ou null se não estiver logado
  Future<ParseUser?> getCurrentUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user == null) return null;

    try {
      await user.fetch();
      return user;
    } catch (e) {
      // Se der erro ao atualizar, retorna null ou o usuário sem atualizar
      return null;
    }
  }

  /// Retorna um Map com os dados principais do usuário para exibir no perfil
  Future<Map<String, dynamic>?> getUserProfileData() async {
    final user = await getCurrentUser();
    if (user == null) return null;

    // Campos básicos (você pode adicionar os que quiser)
    return {
      'email': user.emailAddress ?? '',
      'name': user.get<String>('name') ?? '',
      'userType': user.get<String>('userType') ?? '',
      'age': user.get<int>('age'),
      'degree': user.get<String>('degree'),
      'origin': user.get<String>('origin'),
      'sex': user.get<String>('sex'),
      'university': user.get<String>('university'),
      'propertyType': user.get<String>('propertyType'),
      'value': user.get<double>('value'),
      'address': user.get<String>('address'),
    };
  }

  /// Método para logout (opcional)
  Future<void> logout() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    await user?.logout();
  }
}
