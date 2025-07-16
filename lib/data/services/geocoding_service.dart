// lib/services/geocoding_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:math';

class GeocodingService {
  /// Faz GET no Nominatim via HttpClient e retorna uma lat/lon aleatória dentro da bounding box.
  Future<Map<String, double>?> fetchCoordinates(String city) async {
    final client = HttpClient();
    try {
      // monta a URL
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': city,
        'format': 'json',
        'limit': '1',
      });

      // define UA no header
      final request = await client.getUrl(uri);
      request.headers.set('User-Agent', 'LocaStudent/1.0 (youremail@example.com)');

      final response = await request.close();
      if (response.statusCode != 200) return null;

      final body = await response.transform(utf8.decoder).join();
      final list = jsonDecode(body) as List<dynamic>;
      if (list.isEmpty) return null;

      final box = (list[0]['boundingbox'] as List<dynamic>).cast<String>();
      final minLat = double.parse(box[0]);
      final maxLat = double.parse(box[1]);
      final minLon = double.parse(box[2]);
      final maxLon = double.parse(box[3]);

      final rnd = Random();
      return {
        'latitude': minLat + (maxLat - minLat) * rnd.nextDouble(),
        'longitude': minLon + (maxLon - minLon) * rnd.nextDouble(),
      };
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
