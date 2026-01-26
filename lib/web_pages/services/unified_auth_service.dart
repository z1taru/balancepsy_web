// lib/services/unified_auth_service.dart
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
      final url = ApiConfig.login;
      print('🔐 Logging in to: $url');
      print('📧 Email: $email');

      final response = await http
          .post(
            Uri.parse(url),
            headers: ApiConfig.headers,
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(ApiConfig.connectionTimeout);

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response headers: ${response.headers}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['success'] == true && data['data'] != null) {
          final responseData = data['data'];
          final token = responseData['token'];
          final user = responseData['user'];
          final role = user['role'];

          print('✅ Login successful - Role: $role');

          // ✅ Сохраняем токен и роль
          await _storage.saveAuthData(
            token: token,
            role: role,
            email: user['email'],
          );

          return {'success': true, 'user': user, 'token': token, 'role': role};
        }
      }

      final error = json.decode(utf8.decode(response.bodyBytes));
      print('❌ Login failed: ${error['message']}');

      return {'success': false, 'message': error['message'] ?? 'Ошибка входа'};
    } catch (e) {
      print('❌ Login exception: $e');
      return {'success': false, 'message': 'Ошибка соединения: $e'};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      print('📡 Getting profile with token: ${token.substring(0, 20)}...');

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
          final profile = data['data'];

          print('✅ Profile loaded - Role: ${profile['role']}');

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
        print('⚠️ Session expired');
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
    Map<String, dynamic> updates,
  ) async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

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
    print('🚪 Logging out...');
    await _storage.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  Future<String?> getUserRole() async {
    return await _storage.getUserRole();
  }
}
