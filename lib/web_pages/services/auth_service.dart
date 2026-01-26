// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../сore/config/api_config.dart';
import '../services/storage_service.dart';

class AuthService {
  final StorageService _storage = StorageService();

  // Вход в систему
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

        // Сохраняем токен
        final token = data['token'];
        if (token != null) {
          await _storage.saveToken(token);
        }

        return data;
      } else {
        final error = json.decode(utf8.decode(response.bodyBytes));
        throw Exception(error['message'] ?? 'Ошибка входа');
      }
    } catch (e) {
      print('Ошибка в login: $e');
      rethrow;
    }
  }

  // Регистрация клиента
  Future<Map<String, dynamic>> registerClient({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.registerClient),
            headers: ApiConfig.headers,
            body: json.encode({
              'name': name,
              'email': email,
              'password': password,
              if (phone != null) 'phone': phone,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        // Сохраняем токен
        final token = data['token'];
        if (token != null) {
          await _storage.saveToken(token);
        }

        return data;
      } else {
        final error = json.decode(utf8.decode(response.bodyBytes));
        throw Exception(error['message'] ?? 'Ошибка регистрации');
      }
    } catch (e) {
      print('Ошибка в registerClient: $e');
      rethrow;
    }
  }

  // Регистрация психолога
  Future<Map<String, dynamic>> registerPsychologist({
    required String name,
    required String email,
    required String password,
    required String specialization,
    String? phone,
    String? education,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.registerPsychologist),
            headers: ApiConfig.headers,
            body: json.encode({
              'name': name,
              'email': email,
              'password': password,
              'specialization': specialization,
              if (phone != null) 'phone': phone,
              if (education != null) 'education': education,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        // Сохраняем токен
        final token = data['token'];
        if (token != null) {
          await _storage.saveToken(token);
        }

        return data;
      } else {
        final error = json.decode(utf8.decode(response.bodyBytes));
        throw Exception(error['message'] ?? 'Ошибка регистрации');
      }
    } catch (e) {
      print('Ошибка в registerPsychologist: $e');
      rethrow;
    }
  }

  // Получить текущего пользователя
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final token = await _storage.getToken();

      if (token == null) {
        throw Exception('Токен не найден');
      }

      final response = await http
          .get(
            Uri.parse(ApiConfig.me),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data;
      } else if (response.statusCode == 401) {
        await _storage.clearToken();
        throw Exception('Сессия истекла');
      } else {
        throw Exception('Ошибка получения данных пользователя');
      }
    } catch (e) {
      print('Ошибка в getCurrentUser: $e');
      rethrow;
    }
  }

  // Выход из системы
  Future<void> logout() async {
    await _storage.clearToken();
  }

  // Проверка авторизации
  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null;
  }
}
