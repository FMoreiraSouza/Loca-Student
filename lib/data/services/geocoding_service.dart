import 'dart:convert';
import 'dart:io';
import 'dart:math';

class GeocodingService {
  Future<Map<String, double>?> fetchCoordinates(String city, {double maxDistanceKm = 5.0}) async {
    final client = HttpClient();
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': city,
        'format': 'json',
        'limit': '1',
      });

      final request = await client.getUrl(uri);
      request.headers.set('User-Agent', 'LocaStudent/1.0 (fmoreirasouza701@gmail.com)');

      final response = await request.close();
      if (response.statusCode != 200) return null;

      final body = await response.transform(utf8.decoder).join();
      final list = jsonDecode(body) as List<dynamic>;
      if (list.isEmpty) return null;

      final latCenter = double.parse(list[0]['lat']);
      final lonCenter = double.parse(list[0]['lon']);

      final random = Random();
      final radiusKm = maxDistanceKm * sqrt(random.nextDouble());
      final angle = 2 * pi * random.nextDouble();

      final deltaLat = (radiusKm / 111.0) * cos(angle);
      final deltaLon = (radiusKm / (111.0 * cos(latCenter * pi / 180))) * sin(angle);

      final newLat = latCenter + deltaLat;
      final newLon = lonCenter + deltaLon;

      return {'latitude': newLat, 'longitude': newLon};
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
