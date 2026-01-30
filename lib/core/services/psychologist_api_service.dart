// lib/services/api/psychologist_api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для работы с API психолога
class PsychologistApiService {
  static const String baseUrl =
      'YOUR_API_URL'; // TODO: Заменить на реальный URL

  /// Получить предстоящие сессии психолога
  Future<List<Map<String, dynamic>>> getUpcomingSessions() async {
    try {
      final token = await _getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/appointments/psychologist/me?status=CONFIRMED&status=PENDING',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      print('❌ Failed to load sessions: ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ Error loading sessions: $e');
      return [];
    }
  }

  /// Получить новые заявки на консультации
  Future<List<Map<String, dynamic>>> getNewRequests() async {
    try {
      final token = await _getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse('$baseUrl/api/appointments/psychologist/me?status=PENDING'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      print('❌ Failed to load requests: ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ Error loading requests: $e');
      return [];
    }
  }

  /// Получить статистику психолога
  Future<Map<String, dynamic>?> getStatistics() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/api/psychologists/me/statistics'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }

      print('❌ Failed to load statistics: ${response.statusCode}');
      return null;
    } catch (e) {
      print('❌ Error loading statistics: $e');
      return null;
    }
  }

  /// Подтвердить запись
  Future<bool> confirmAppointment(int appointmentId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/api/appointments/$appointmentId/confirm'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      print('❌ Failed to confirm appointment: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error confirming appointment: $e');
      return false;
    }
  }

  /// Отклонить запись
  Future<bool> rejectAppointment(int appointmentId, String? reason) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/api/appointments/$appointmentId/reject'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'reason': reason}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      print('❌ Failed to reject appointment: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error rejecting appointment: $e');
      return false;
    }
  }

  /// Начать сессию
  Future<bool> startSession(int appointmentId) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/api/appointments/$appointmentId/start'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      print('❌ Failed to start session: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error starting session: $e');
      return false;
    }
  }

  /// Завершить сессию
  Future<bool> completeSession(int appointmentId, {String? notes}) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/api/appointments/$appointmentId/complete'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'notes': notes}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      print('❌ Failed to complete session: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error completing session: $e');
      return false;
    }
  }

  /// Получить непрочитанные сообщения
  Future<List<Map<String, dynamic>>> getUnreadMessages() async {
    try {
      final token = await _getToken();
      if (token == null) return [];

      // TODO: Заменить на реальный эндпоинт для сообщений
      final response = await http.get(
        Uri.parse('$baseUrl/api/messages/unread'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      print('❌ Failed to load unread messages: ${response.statusCode}');
      return [];
    } catch (e) {
      print('❌ Error loading unread messages: $e');
      return [];
    }
  }

  /// Получить токен из SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
