import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:loca_student/data/models/tenant_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

abstract class IRepublicHomeRepository {
  Future<List<InterestedStudentModel>> fetchInterestedStudents(ParseUser currentUser);
  Future<List<TenantModel>> fetchTenants(ParseUser currentUser);
  Future<void> updateReservationStatus({
    required String studentId,
    required String republicId,
    required String newStatus,
  });
  Future<void> updateVacancy(String republicId);
  Future<void> acceptInterestStudent(InterestedStudentModel interested);
  Future<TenantModel?> getTenantByStudentAndRepublic(String studentId, String republicId);
  Future<void> createTenant(TenantModel tenant);
  Future<void> updateTenantBelongs(String tenantObjectId, bool belongs);
  Future<void> updateInterestedStudentStatusAndReservation({
    required InterestedStudentModel interested,
  });
  Future<void> updateInterestStatus(String studentId, String republicId, String newStatus);
  Future<void> incrementVacancy(String republicId);
}
