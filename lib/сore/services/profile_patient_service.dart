// lib/сore/services/profile_patient_service.dart
import '../config/api_config.dart';
import 'api_client.dart';
import 'dart:io';

class ProfilePatientService {
  final ApiClient _apiClient = ApiClient();

  // ========================================
  // Get Current User Profile
  // ========================================
  Future<Map<String, dynamic>> getCurrentProfile() async {
    return await _apiClient.get(ApiConfig.currentUser, requiresAuth: true);
  }

  // ========================================
  // Update Profile
  // ========================================
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    List<String>? interests,
    String? registrationGoal,
  }) async {
    final body = <String, dynamic>{};

    if (fullName != null) body['fullName'] = fullName;
    if (phone != null) body['phone'] = phone;
    if (dateOfBirth != null) body['dateOfBirth'] = dateOfBirth;
    if (gender != null) body['gender'] = gender;
    if (interests != null) body['interests'] = interests;
    if (registrationGoal != null) body['registrationGoal'] = registrationGoal;

    return await _apiClient.put(
      ApiConfig.updateProfile,
      body,
      requiresAuth: true,
    );
  }

  // ========================================
  // Upload Avatar
  // ========================================
  Future<Map<String, dynamic>> uploadAvatar(File imageFile) async {
    return await _apiClient.uploadFile(
      ApiConfig.uploadAvatar,
      imageFile,
      'avatar',
    );
  }

  // ========================================
  // Change Password
  // ========================================
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await _apiClient.put(ApiConfig.changePassword, {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    }, requiresAuth: true);
  }

  // ========================================
  // Delete Account
  // ========================================
  Future<Map<String, dynamic>> deleteAccount() async {
    return await _apiClient.delete(ApiConfig.deleteAccount, requiresAuth: true);
  }

  // ========================================
  // Get User Statistics
  // ========================================
  Future<Map<String, dynamic>> getUserStatistics() async {
    return await _apiClient.get(ApiConfig.myStatistics, requiresAuth: true);
  }
}

// ========================================
// User Profile Model
// ========================================
class UserProfile {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final List<String>? interests;
  final String? registrationGoal;
  final String? avatarUrl;
  final String role;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.interests,
    this.registrationGoal,
    this.avatarUrl,
    required this.role,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['fullName'] ?? json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      dateOfBirth: json['dateOfBirth'] != null || json['date_of_birth'] != null
          ? DateTime.parse(json['dateOfBirth'] ?? json['date_of_birth'])
          : null,
      gender: json['gender'],
      interests: json['interests'] != null
          ? List<String>.from(json['interests'])
          : null,
      registrationGoal: json['registrationGoal'] ?? json['registration_goal'],
      avatarUrl: json['avatarUrl'] ?? json['avatar_url'],
      role: json['role'] ?? 'CLIENT',
      isEmailVerified:
          json['isEmailVerified'] ?? json['is_email_verified'] ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] ??
            json['created_at'] ??
            DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ??
            json['updated_at'] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'interests': interests,
      'registrationGoal': registrationGoal,
      'avatarUrl': avatarUrl,
      'role': role,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Вычисляемый возраст
  int? getAge() {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  // Форматированная дата рождения
  String getFormattedBirthDate() {
    if (dateOfBirth == null) return 'Не указана';
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];
    return '${dateOfBirth!.day} ${months[dateOfBirth!.month - 1]} ${dateOfBirth!.year}';
  }

  // Локализованный пол
  String getLocalizedGender() {
    switch (gender?.toUpperCase()) {
      case 'MALE':
        return 'Мужской';
      case 'FEMALE':
        return 'Женский';
      case 'OTHER':
        return 'Другой';
      default:
        return 'Не указан';
    }
  }
}

// ========================================
// User Statistics Model
// ========================================
class UserStatistics {
  final int totalSessions;
  final int completedSessions;
  final int upcomingSessions;
  final int articlesRead;
  final int daysActive;

  UserStatistics({
    required this.totalSessions,
    required this.completedSessions,
    required this.upcomingSessions,
    required this.articlesRead,
    required this.daysActive,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    return UserStatistics(
      totalSessions: json['totalSessions'] ?? json['total_sessions'] ?? 0,
      completedSessions:
          json['completedSessions'] ?? json['completed_sessions'] ?? 0,
      upcomingSessions:
          json['upcomingSessions'] ?? json['upcoming_sessions'] ?? 0,
      articlesRead: json['articlesRead'] ?? json['articles_read'] ?? 0,
      daysActive: json['daysActive'] ?? json['days_active'] ?? 0,
    );
  }

  // Форматированные данные для отображения
  String getWeeksActive() {
    return (daysActive / 7).floor().toString();
  }
}
