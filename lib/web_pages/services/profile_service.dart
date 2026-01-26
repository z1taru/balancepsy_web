// lib/services/profile_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../сore/config/api_config.dart';
import '../services/storage_service.dart';

class ProfileService {
  final StorageService _storage = StorageService();

  // Получить данные текущего пользователя
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http
          .get(
            Uri.parse(ApiConfig.currentUser),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else if (response.statusCode == 401) {
        // Токен невалиден, очищаем его
        await _storage.clearToken();
        throw Exception('Сессия истекла. Войдите снова');
      } else {
        throw Exception('Ошибка загрузки профиля: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка в getCurrentUser: $e');
      rethrow;
    }
  }

  // Обновить профиль
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
    String? gender,
    String? therapyGoals,
  }) async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (birthDate != null) body['birthDate'] = birthDate;
      if (gender != null) body['gender'] = gender;
      if (therapyGoals != null) body['therapyGoals'] = therapyGoals;

      final response = await http
          .put(
            Uri.parse(ApiConfig.updateProfile),
            headers: ApiConfig.headersWithAuth(token),
            body: json.encode(body),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        throw Exception('Ошибка обновления профиля: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка в updateProfile: $e');
      rethrow;
    }
  }

  // Загрузить аватар
  Future<Map<String, dynamic>> uploadAvatar(String imagePath) async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.uploadAvatar),
      );

      request.headers.addAll(ApiConfig.multipartHeadersWithAuth(token));
      request.files.add(await http.MultipartFile.fromPath('avatar', imagePath));

      final streamedResponse = await request.send().timeout(
        ApiConfig.connectionTimeout,
      );
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else {
        throw Exception('Ошибка загрузки аватара: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка в uploadAvatar: $e');
      rethrow;
    }
  }

  // Изменить пароль
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http
          .put(
            Uri.parse(ApiConfig.changePassword),
            headers: ApiConfig.headersWithAuth(token),
            body: json.encode({
              'currentPassword': currentPassword,
              'newPassword': newPassword,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode != 200) {
        final error = json.decode(utf8.decode(response.bodyBytes));
        throw Exception(error['message'] ?? 'Ошибка смены пароля');
      }
    } catch (e) {
      print('Ошибка в changePassword: $e');
      rethrow;
    }
  }

  // Удалить аккаунт
  Future<void> deleteAccount() async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http
          .delete(
            Uri.parse(ApiConfig.deleteAccount),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        await _storage.clearAll();
      } else {
        throw Exception('Ошибка удаления аккаунта: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка в deleteAccount: $e');
      rethrow;
    }
  }
}
