import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для работы с API профиля
class ProfileApiService {
  static const String baseUrl =
      'YOUR_API_URL'; // TODO: Заменить на реальный URL

  /// Получить текущий профиль
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/api/profile/me'),
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

      print('❌ Failed to load profile: ${response.statusCode}');
      return null;
    } catch (e) {
      print('❌ Error loading profile: $e');
      return null;
    }
  }

  /// Обновить профиль
  Future<Map<String, dynamic>?> updateProfile({
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? gender,
    List<String>? interests,
    String? registrationGoal,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      final body = <String, dynamic>{};
      if (fullName != null) body['fullName'] = fullName;
      if (phone != null) body['phone'] = phone;
      if (dateOfBirth != null) body['dateOfBirth'] = dateOfBirth;
      if (gender != null) body['gender'] = gender;
      if (interests != null) body['interests'] = interests;
      if (registrationGoal != null) body['registrationGoal'] = registrationGoal;

      final response = await http.put(
        Uri.parse('$baseUrl/api/profile/me'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }

      print('❌ Failed to update profile: ${response.statusCode}');
      return null;
    } catch (e) {
      print('❌ Error updating profile: $e');
      return null;
    }
  }

  /// Загрузить аватар
  Future<String?> uploadAvatar(File imageFile) async {
    try {
      final token = await _getToken();
      if (token == null) return null;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/profile/me/avatar'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data['data']['avatarUrl'];
        }
      }

      print('❌ Failed to upload avatar: ${response.statusCode}');
      return null;
    } catch (e) {
      print('❌ Error uploading avatar: $e');
      return null;
    }
  }

  /// Удалить аватар
  Future<bool> deleteAvatar() async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('$baseUrl/api/profile/me/avatar'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      print('❌ Failed to delete avatar: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error deleting avatar: $e');
      return false;
    }
  }

  /// Изменить доступность (только для психологов)
  Future<bool> updateAvailability(bool isAvailable) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      final response = await http.put(
        Uri.parse('$baseUrl/api/profile/me/availability'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'isAvailable': isAvailable}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      }

      print('❌ Failed to update availability: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error updating availability: $e');
      return false;
    }
  }

  /// Получить токен из SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
