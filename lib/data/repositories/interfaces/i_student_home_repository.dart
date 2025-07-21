import 'package:loca_student/data/models/republic_model.dart';
import 'package:loca_student/data/models/reservation_model.dart';
import 'package:loca_student/data/models/interested_student_model.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

abstract class IStudentHomeRepository {
  Future<List<RepublicModel>> searchRepublicsByCity(String city);
  Future<ParseObject> getStudentForUser(ParseUser user);
  Future<List<ParseObject>> findExistingReservation(ParseObject student, ParseObject republic);
  Future<void> saveReservation(ReservationModel reservation);
  Future<void> updateReservationStatus(ParseObject reservationObj, String status);
  Future<List<ParseObject>> findInterest(ParseObject student, ParseObject republic);
  Future<void> saveInterest(ParseObject interestObj);
  Future<List<ReservationModel>> fetchReservations();
  Future<ParseObject?> getReservationById(String reservationId);
  Future<void> saveGeneric(ParseObject obj);
  Future<void> updateReservation(ParseObject reservation);
  Future<void> updateRepublicVacancies(String republicId, int increment);
  Future<List<ParseObject>> findTenant(ParseObject student, ParseObject republic);
  Future<void> updateTenant(ParseObject tenantObj);
  Future<ParseObject?> getReservationByIdWithRelations(String reservationId);
  Future<void> updateReservationStatusByObject(ParseObject reservationObj, String status);
  Future<void> updateInterestStatus(ParseObject student, ParseObject republic, String status);
  Future<void> incrementRepublicVacancies(ParseObject republic, int increment);
  Future<void> updateTenantBelongs(ParseObject student, ParseObject republic, bool belongs);
  Future<void> cancelReservationByIdModular(String reservationId);
  Future<void> updateInterestStatusIfExists(
    ParseObject student,
    ParseObject republic,
    String status,
  );
  Future<void> saveInterestModel(InterestedStudentModel model, RepublicModel republic);
  ParseObject getRepublicPointer(RepublicModel republic);
  Future<void> resendReservationByIdModular(String reservationId);
}
