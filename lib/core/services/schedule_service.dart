// lib/core/services/schedule_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/token_storage.dart';
import '../../models/schedule_slot.dart';

class ScheduleService {
  final TokenStorage _storage = TokenStorage();

  /// Получить свое расписание (психолог)
  Future<List<ScheduleSlot>> getMySchedule() async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final response = await http
        .get(
          Uri.parse(ApiConfig.mySchedule),
          headers: ApiConfig.headersWithAuth(token),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((e) => ScheduleSlot.fromJson(e))
            .toList();
      }
    }

    return [];
  }

  /// Получить расписание психолога (публичное)
  Future<List<ScheduleSlot>> getPsychologistSchedule(int psychologistId) async {
    final response = await http
        .get(
          Uri.parse(ApiConfig.psychologistSchedule(psychologistId)),
          headers: ApiConfig.headers,
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((e) => ScheduleSlot.fromJson(e))
            .toList();
      }
    }

    return [];
  }

  /// Создать слот (психолог)
  Future<ScheduleSlot> createScheduleSlot({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
  }) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final response = await http
        .post(
          Uri.parse(ApiConfig.mySchedule),
          headers: ApiConfig.headersWithAuth(token),
          body: json.encode({
            'dayOfWeek': dayOfWeek,
            'startTime': startTime,
            'endTime': endTime,
          }),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data['success'] == true) {
        return ScheduleSlot.fromJson(data['data']);
      }
    }

    throw Exception('Не удалось создать слот');
  }

  /// Удалить слот (психолог)
  Future<void> deleteScheduleSlot(int slotId) async {
    final token = await _storage.getToken();
    if (token == null) throw Exception('Не авторизован');

    final response = await http
        .delete(
          Uri.parse(ApiConfig.deleteScheduleSlot(slotId)),
          headers: ApiConfig.headersWithAuth(token),
        )
        .timeout(ApiConfig.connectionTimeout);

    if (response.statusCode != 200) {
      throw Exception('Не удалось удалить слот');
    }
  }
}
