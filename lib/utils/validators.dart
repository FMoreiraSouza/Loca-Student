class Validators {
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrada obrigatória';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email inválido';
    }
    return null;
  }

  static String? phone(String? value) {
    final raw = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (raw.isEmpty) {
      return 'Telefone é obrigatório';
    }
    if (raw.length < 10 || raw.length > 11) {
      return 'Telefone inválido';
    }
    return null;
  }

  static String? age(String? value) {
    final val = value?.trim() ?? '';
    if (val.isEmpty) return 'Idade é obrigatório';
    final n = int.tryParse(val);
    if (n == null || n <= 0) return 'Idade inválida';
    return null;
  }

  static String? password(String? value, {String fieldName = 'Senha'}) {
    if (value == null || value.trim().isEmpty) {
      return 'Entrada obrigatória';
    }
    if (value.trim().length < 8) {
      return 'A $fieldName deve ter mais do que 8 caracteres';
    }
    return null;
  }
}
