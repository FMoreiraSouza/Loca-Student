// import 'package:loca_student/data/services/parse_service.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// class AccommodationRepository {
//   final ParseService parseService;

//   AccommodationRepository({required this.parseService});

//   Future<List<ParseObject>> fetchAccommodations() async {
//     try {
//       return await parseService.queryObjects('Accommodation');
//     } catch (e) {
//       throw Exception('Erro ao buscar imóveis: $e');
//     }
//   }

//   Future<ParseObject> createAccommodation(Map<String, dynamic> data) async {
//     try {
//       final accommodation = parseService.createObject('Accommodation', data);
//       final response = await parseService.saveObject(accommodation);
//       if (response.success && response.result != null) {
//         return response.result as ParseObject;
//       } else {
//         throw Exception('Erro ao criar imóvel: ${response.error?.message}');
//       }
//     } catch (e) {
//       throw Exception('Erro ao criar imóvel: $e');
//     }
//   }

//   Future<ParseObject> updateAccommodation(String objectId, Map<String, dynamic> data) async {
//     try {
//       final accommodation = parseService.createObject('Accommodation', data)..objectId = objectId;
//       final response = await parseService.updateObject(accommodation);
//       if (response.success && response.result != null) {
//         return response.result as ParseObject;
//       } else {
//         throw Exception('Erro ao atualizar imóvel: ${response.error?.message}');
//       }
//     } catch (e) {
//       throw Exception('Erro ao atualizar imóvel: $e');
//     }
//   }
// }
