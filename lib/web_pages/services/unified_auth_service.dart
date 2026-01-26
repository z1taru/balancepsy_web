// lib/services/unified_auth_service.dart
// ✅ ЕДИНЫЙ сервис авторизации для Flutter Web
// Использует существующий backend без изменений

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../сore/config/api_config.dart';
import '../../сore/storage/token_storage.dart';

class UnifiedAuthService {
  final TokenStorage _storage = TokenStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.login),
            headers: ApiConfig.headers,
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          final token = data['data']['token'];
          final user = data['data']['user'];
          final role = user['role']; // CLIENT, PSYCHOLOGIST, ADMIN

          // ✅ Сохраняем токен и роль
          await _storage.saveAuthData(
            token: token,
            role: role,
            email: user['email'],
          );

          return {
            'success': true,
            'user': user,
            'token': token,
            'role': role, // ✅ Возвращаем роль для роутинга
          };
        }
      }

      final error = json.decode(utf8.decode(response.bodyBytes));
      return {
        'success': false,
        'message': error['message'] ?? 'Ошибка входа'
      };
    } catch (e) {
      return {'success': false, 'message': 'Ошибка соединения: $e'};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      // ✅ Используем существующий endpoint
      final response = await http
          .get(
            Uri.parse(ApiConfig.me), // /api/auth/me
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          final profile = data['data'];
          
          // ✅ Обновляем роль в storage если получили новую
          if (profile['role'] != null) {
            final currentRole = await _storage.getUserRole();
            if (currentRole != profile['role']) {
              await _storage.saveUserInfo(
                role: profile['role'],
                email: profile['email'],
              );
            }
          }

          return {'success': true, 'profile': profile};
        }
      }

      if (response.statusCode == 401) {
        await _storage.clearAll();
        throw Exception('Сессия истекла');
      }

      throw Exception('Не удалось загрузить профиль');
    } catch (e) {
      print('❌ Error in getProfile: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile(
      Map<String, dynamic> updates) async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http
          .put(
            Uri.parse(ApiConfig.updateProfile), // /api/users/me
            headers: ApiConfig.headersWithAuth(token),
            body: json.encode(updates),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true) {
          return {'success': true, 'profile': data['data']};
        }
      }

      final error = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(error['message'] ?? 'Ошибка обновления профиля');
    } catch (e) {
      print('❌ Error in updateProfile: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.clearAll();
  }

 
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }


  Future<String?> getUserRole() async {
    return await _storage.getUserRole();
  }
}