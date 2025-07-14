import 'package:flutter/material.dart';
import 'package:loca_student/data/models/university.dart';
import 'package:loca_student/utils/calculate_coordinates.dart';
import 'package:loca_student/utils/mock_universities.dart';

class OwnerProfileWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const OwnerProfileWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final latitude = data['latitude'] as double?;
    final longitude = data['longitude'] as double?;

    List<String> distanceMessages = [];

    if (latitude != null && longitude != null) {
      final nearby = mockUniversities
          .map((university) {
            final distance = calculateDistanceKm(
              latitude,
              longitude,
              university.latitude,
              university.longitude,
            );
            return {'university': university, 'distance': distance};
          })
          .where((entry) => (entry['distance'] as double) <= 20.0)
          .toList();

      if (nearby.isNotEmpty) {
        nearby.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));

        for (final entry in nearby) {
          final university = entry['university'] as University;
          final distance = (entry['distance'] as double).toStringAsFixed(2);
          distanceMessages.add('A $distance km da universidade ${university.name}');
        }
      }
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
