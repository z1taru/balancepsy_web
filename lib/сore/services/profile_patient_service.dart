// lib/сore/services/profile_patient_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/token_storage.dart';

class ProfilePatientService {
  final TokenStorage _storage = TokenStorage();

  /// Получить текущий профиль пользователя
  Future<Map<String, dynamic>> getCurrentProfile() async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      print('📡 Getting profile from: ${ApiConfig.me}');

      final response = await http
          .get(
            Uri.parse(ApiConfig.me),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Profile response status: ${response.statusCode}');
      print('📡 Profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          return data;
        }
      }

      if (response.statusCode == 401) {
        print('⚠️ Session expired');
        await _storage.clearAll();
        throw Exception('Сессия истекла');
      }

      throw Exception('Не удалось загрузить профиль');
    } catch (e) {
      print('❌ Error in getCurrentProfile: $e');
      rethrow;
    }
  }

  /// Обновить профиль пользователя
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? registrationGoal,
  }) async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      final updates = <String, dynamic>{};
      if (fullName != null) updates['fullName'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (dateOfBirth != null) updates['dateOfBirth'] = dateOfBirth;
      if (gender != null) updates['gender'] = gender;
      if (registrationGoal != null)
        updates['registrationGoal'] = registrationGoal;

      print('📡 Updating profile: $updates');

      final response = await http
          .put(
            Uri.parse(ApiConfig.updateProfile),
            headers: ApiConfig.headersWithAuth(token),
            body: json.encode(updates),
          )
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Update response status: ${response.statusCode}');
      print('📡 Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true) {
          print('✅ Profile updated successfully');
          return data;
        }
      }

      final error = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(error['message'] ?? 'Ошибка обновления профиля');
    } catch (e) {
      print('❌ Error in updateProfile: $e');
      rethrow;
    }
  }

  /// Получить статистику пользователя
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      // Временно возвращаем моковые данные, пока не будет реализован бэкенд endpoint
      // TODO: Реализовать /api/users/me/statistics на бэкенде
      return {
        'success': true,
        'data': {
          'completedSessions': 0,
          'articlesRead': 0,
          'daysActive': 0,
          'moodEntriesCount': 0,
          'weeksSinceJoined': _getWeeksSinceJoined(),
        },
      };
    } catch (e) {
      print('❌ Error in getUserStatistics: $e');
      rethrow;
    }
  }

  int _getWeeksSinceJoined() {
    // Временная реализация
    return 1;
  }
}

/// Модель профиля пользователя
class UserProfile {
  final int userId;
  final String email;
  final String fullName;
  final String? phone;
  final String? dateOfBirth;
  final String? avatarUrl;
  final String role;
  final String? gender;
  final String? registrationGoal;
  final bool isActive;
  final bool emailVerified;

  UserProfile({
    required this.userId,
    required this.email,
    required this.fullName,
    this.phone,
    this.dateOfBirth,
    this.avatarUrl,
    required this.role,
    this.gender,
    this.registrationGoal,
    required this.isActive,
    required this.emailVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId'] as int,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String,
      gender: json['gender'] as String?,
      registrationGoal: json['registrationGoal'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      emailVerified: json['emailVerified'] as bool? ?? false,
    );
  }

  String getFormattedBirthDate() {
    if (dateOfBirth == null) return 'Не указана';

    try {
      final date = DateTime.parse(dateOfBirth!);
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    } catch (e) {
      return 'Не указана';
    }
  }

  String getLocalizedGender() {
    switch (gender?.toUpperCase()) {
      case 'MALE':
        return 'Мужской';
      case 'FEMALE':
        return 'Женский';
      default:
        return 'Не указан';
    }
  }
}

/// Модель статистики пользователя
class UserStatistics {
  final int completedSessions;
  final int articlesRead;
  final int daysActive;
  final int moodEntriesCount;
  final int weeksSinceJoined;

  UserStatistics({
    required this.completedSessions,
    required this.articlesRead,
    required this.daysActive,
    required this.moodEntriesCount,
    required this.weeksSinceJoined,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      completedSessions: json['completedSessions'] as int? ?? 0,
      articlesRead: json['articlesRead'] as int? ?? 0,
      daysActive: json['daysActive'] as int? ?? 0,
      moodEntriesCount: json['moodEntriesCount'] as int? ?? 0,
      weeksSinceJoined: json['weeksSinceJoined'] as int? ?? 0,
    );
  }

  String getWeeksActive() {
    if (weeksSinceJoined == 0) return '0 недель';
    if (weeksSinceJoined == 1) return '1 неделя';
    if (weeksSinceJoined < 5) return '$weeksSinceJoined недели';
    return '$weeksSinceJoined недель';
  }
}
