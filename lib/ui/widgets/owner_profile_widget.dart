import 'package:flutter/material.dart';

class OwnerProfileWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const OwnerProfileWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Valor: R\$${data['value']?.toStringAsFixed(2) ?? 'Não informado'}'),
        Text('Endereço: ${data['address'] ?? 'Não informado'}'),
        Text('Cidade: ${data['city'] ?? 'Não informado'}'),
        Text('Estado: ${data['state'] ?? 'Não informado'}'),
      ],
    );
  }
}
