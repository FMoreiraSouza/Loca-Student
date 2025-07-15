class StudentModel {
  final String objectId;
  final String name;
  final String email;

  StudentModel({required this.objectId, required this.name, required this.email});

  /// Cria a partir de um ParseObject (objeto vindo do Parse Server)
  factory StudentModel.fromParseObject(dynamic parseObject) {
    return StudentModel(
      objectId: parseObject.objectId ?? '',
      name: parseObject.get<String>('name') ?? 'Nome não informado',
      email: parseObject.get<String>('email') ?? 'Email não informado',
    );
  }

  /// Para enviar de volta ao Parse, se necessário
  Map<String, dynamic> toMap() {
    return {'objectId': objectId, 'name': name, 'email': email};
  }
}
