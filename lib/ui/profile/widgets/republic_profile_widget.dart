import 'package:flutter/material.dart';
import 'package:loca_student/utils/calculate_coordinates.dart';
import 'package:loca_student/utils/mock_universities.dart';

class RepublicProfileWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const RepublicProfileWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final latitude = data['latitude'] as double?;
    final longitude = data['longitude'] as double?;

    List<String> distanceMessages = [];

    if (latitude != null && longitude != null) {
      distanceMessages = getNearbyUniversitiesDistanceMessages(
        latitude: latitude,
        longitude: longitude,
        universities: mockUniversities,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Valor: R\$${data['value']?.toStringAsFixed(2) ?? 'Não informado'}'),
        Text('Endereço: ${data['address'] ?? 'Não informado'}'),
        Text('Cidade: ${data['city'] ?? 'Não informado'}'),
        Text('Estado: ${data['state'] ?? 'Não informado'}'),
        if (distanceMessages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: distanceMessages
                  .map(
                    (msg) => Text(
                      msg,
                      style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}
