import 'package:flutter/material.dart';
import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/utils/calculate_coordinates.dart';
import 'package:loca_student/utils/mock_universities.dart';

class RepublicProfileWidget extends StatelessWidget {
  final RepublicModel republic;

  const RepublicProfileWidget({super.key, required this.republic});

  @override
  Widget build(BuildContext context) {
    final latitude = republic.latitude;
    final longitude = republic.longitude;

    List<String> distanceMessages = [];

    if (latitude != 0 && longitude != 0) {
      distanceMessages = CalculateCoordinates().getNearbyUniversitiesDistanceMessages(
        latitude: latitude,
        longitude: longitude,
        universities: MockData().mockUniversities,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Valor: R\$${republic.value.toStringAsFixed(2)}'),
        Text('Endereço: ${republic.address.isNotEmpty ? republic.address : 'Não informado'}'),
        Text('Cidade: ${republic.city.isNotEmpty ? republic.city : 'Não informado'}'),
        Text('Estado: ${republic.state.isNotEmpty ? republic.state : 'Não informado'}'),
        if (distanceMessages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: distanceMessages.map((msg) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    msg,
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.justify,
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
