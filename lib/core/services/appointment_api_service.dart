// lib/core/services/appointment_api_service.dart
//
// Единый сервис записей.  Используйте его вместо PsychologistApiService
// для всех операций с appointments.
//   • Клиент:      getMyAppointments(), createAppointment()
//   • Психолог:    getPsychologistAppointments(), createAppointmentManual()
//   • Статусы:     confirm / reject / start / complete / noShow / cancel

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/token_storage.dart';

class AppointmentApiService {
  final TokenStorage _storage = TokenStorage();

  // ──────────────────────────────────────────
  // КЛИЕНТ  →  получить свои записи
  // ──────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getMyAppointments() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final response = await http
        .get(
          Uri.parse(ApiConfig.myAppointments),
          headers: ApiConfig.headersWithAuth(token),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  // ──────────────────────────────────────────
  // КЛИЕНТ  →  создать запись (через booking-page)
  // ──────────────────────────────────────────
  Future<Map<String, dynamic>> createAppointment({
    required int psychologistId,
    required String appointmentDate, // "2025-02-10"
    required String startTime, // "09:00"
    required String endTime, // "10:00"
    required String format, // VIDEO | CHAT | AUDIO
    String? issueDescription,
  }) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final body = <String, dynamic>{
      'psychologistId': psychologistId,
      'appointmentDate': appointmentDate,
      'startTime': startTime,
      'endTime': endTime,
      'format': format,
    };
    if (issueDescription != null && issueDescription.isNotEmpty) {
      body['issueDescription'] = issueDescription;
    }

    final response = await http
        .post(
          Uri.parse(ApiConfig.appointments),
          headers: ApiConfig.headersWithAuth(token),
          body: json.encode(body),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true) return data['data'];
    }

    final error = json.decode(utf8.decode(response.bodyBytes));
    throw Exception(error['message'] ?? 'Ошибка создания записи');
  }

  // ──────────────────────────────────────────
  // ПСИХОЛОГ  →  получить все записи
  // ──────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getPsychologistAppointments() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final response = await http
        .get(
          Uri.parse(ApiConfig.psychologistAppointments),
          headers: ApiConfig.headersWithAuth(token),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  // ──────────────────────────────────────────
  // ПСИХОЛОГ  →  ручное создание записи
  //   clientId  — ID существующего клиента (обязательно)
  //   clientName / clientPhone — если клиент новый (без ID)
  //   status по умолчанию на бэкенде — PENDING
  // ──────────────────────────────────────────
  Future<Map<String, dynamic>> createAppointmentManual({
    required int psychologistId,
    required String appointmentDate,
    required String startTime,
    required String endTime,
    required String format,
    int? clientId,
    String? clientName,
    String? clientPhone,
    String? issueDescription,
  }) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final body = <String, dynamic>{
      'psychologistId': psychologistId,
      'appointmentDate': appointmentDate,
      'startTime': startTime,
      'endTime': endTime,
      'format': format,
    };
    if (clientId != null) body['clientId'] = clientId;
    if (clientName != null) body['clientName'] = clientName;
    if (clientPhone != null) body['clientPhone'] = clientPhone;
    if (issueDescription != null) body['issueDescription'] = issueDescription;

    final response = await http
        .post(
          Uri.parse(ApiConfig.appointments),
          headers: ApiConfig.headersWithAuth(token),
          body: json.encode(body),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true) return data['data'];
    }

    final error = json.decode(utf8.decode(response.bodyBytes));
    throw Exception(error['message'] ?? 'Ошибка создания записи');
  }

  // ──────────────────────────────────────────
  // Поиск клиентов (для ручного создания)
  // GET /api/users/search?query=...  (только для PSYCHOLOGIST)
  // ──────────────────────────────────────────
  Future<List<Map<String, dynamic>>> searchClients(String query) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final response = await http
        .get(
          Uri.parse('${ApiConfig.searchUsers}?query=$query'),
          headers: ApiConfig.headersWithAuth(token),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true && data['data'] is List) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
    }
    return [];
  }

  // ──────────────────────────────────────────
  // Управление статусами (только PSYCHOLOGIST,
  //   кроме cancel — может любой из пары)
  // ──────────────────────────────────────────
  Future<bool> confirmAppointment(int id) async =>
      await _putStatus(ApiConfig.confirmAppointment(id));

  Future<bool> rejectAppointment(int id, {String? reason}) async =>
      await _putStatus(
        ApiConfig.rejectAppointment(id),
        body: {'reason': reason ?? 'Отклонён психологом'},
      );

  Future<bool> startAppointment(int id) async =>
      await _putStatus(ApiConfig.startAppointment(id));

  Future<bool> completeAppointment(int id) async =>
      await _putStatus(ApiConfig.completeAppointment(id));

  Future<bool> markNoShow(int id) async =>
      await _putStatus(ApiConfig.noShowAppointment(id));

  Future<bool> cancelAppointment(int id, {String? reason}) async =>
      await _putStatus(
        ApiConfig.cancelAppointment(id),
        body: {'reason': reason ?? 'Отменена'},
      );

  // ──────────────────────────────────────────
  // helper
  // ──────────────────────────────────────────
  Future<bool> _putStatus(String url, {Map<String, dynamic>? body}) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final response = await http
        .put(
          Uri.parse(url),
          headers: ApiConfig.headersWithAuth(token),
          body: body != null ? json.encode(body) : json.encode({}),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return data['success'] == true;
    }

    final error = json.decode(utf8.decode(response.bodyBytes));
    throw Exception(error['message'] ?? 'Ошибка запроса');
  }
}
