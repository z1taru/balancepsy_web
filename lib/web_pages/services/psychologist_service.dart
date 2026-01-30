// lib/services/psychologist_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/router/app_router.dart';
import '../../core/storage/token_storage.dart';
import '../../core/config/api_config.dart';

class PsychologistService {
  final TokenStorage _storage = TokenStorage();

  /// Получить список всех психологов
  Future<List<Map<String, dynamic>>> getAllPsychologists() async {
    try {
      print('🔍 Fetching psychologists from: ${ApiConfig.psychologists}');

      final response = await http
          .get(Uri.parse(ApiConfig.psychologists), headers: ApiConfig.headers)
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> psychologists = data['data'];
          print('✅ Loaded ${psychologists.length} psychologist(s)');

          return psychologists.cast<Map<String, dynamic>>();
        }
      }

      throw Exception('Failed to load psychologists');
    } catch (e) {
      print('❌ Error loading psychologists: $e');
      rethrow;
    }
  }

  /// Получить психолога по ID
  Future<Map<String, dynamic>> getPsychologistById(int id) async {
    try {
      final url = '${ApiConfig.psychologists}/$id';
      print('🔍 Fetching psychologist: $url');

      final response = await http
          .get(Uri.parse(url), headers: ApiConfig.headers)
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          print('✅ Loaded psychologist: ${data['data']['fullName']}');
          return data['data'];
        }
      }

      throw Exception('Psychologist not found');
    } catch (e) {
      print('❌ Error loading psychologist: $e');
      rethrow;
    }
  }

  /// Получить расписание психолога
  Future<List<Map<String, dynamic>>> getPsychologistSchedule(
    int psychologistId,
  ) async {
    try {
      final url = '${ApiConfig.psychologists}/$psychologistId/schedule';
      print('🔍 Fetching schedule: $url');

      final response = await http
          .get(Uri.parse(url), headers: ApiConfig.headers)
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> schedule = data['data'];
          print('✅ Loaded ${schedule.length} schedule slot(s)');

          return schedule.cast<Map<String, dynamic>>();
        }
      }

      return []; // Пустое расписание
    } catch (e) {
      print('❌ Error loading schedule: $e');
      return [];
    }
  }

  /// Создать запись на сессию
  Future<Map<String, dynamic>> createAppointment({
    required int psychologistId,
    required String appointmentDate,
    required String startTime,
    required String endTime,
    required String format,
    String? issueDescription,
  }) async {
    try {
      final token = await _storage.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      print('📝 Creating appointment with psychologist $psychologistId');

      final response = await http
          .post(
            Uri.parse(ApiConfig.appointments),
            headers: ApiConfig.headersWithAuth(token),
            body: json.encode({
              'psychologistId': psychologistId,
              'appointmentDate': appointmentDate,
              'startTime': startTime,
              'endTime': endTime,
              'format': format,
              'issueDescription': issueDescription,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true) {
          print('✅ Appointment created successfully');
          return data['data'];
        }
      }

      final error = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(error['message'] ?? 'Failed to create appointment');
    } catch (e) {
      print('❌ Error creating appointment: $e');
      rethrow;
    }
  }

  /// Получить мои записи (для клиента)
  Future<List<Map<String, dynamic>>> getMyAppointments() async {
    try {
      final token = await _storage.getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final url = '${ApiConfig.appointments}/me';
      print('🔍 Fetching my appointments: $url');

      final response = await http
          .get(Uri.parse(url), headers: ApiConfig.headersWithAuth(token))
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> appointments = data['data'];
          print('✅ Loaded ${appointments.length} appointment(s)');

          return appointments.cast<Map<String, dynamic>>();
        }
      }

      return [];
    } catch (e) {
      print('❌ Error loading appointments: $e');
      return [];
    }
  }
}
