import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

/// Сервис для работы с авторизацией
class AuthServiceImpl {
  /// Вход в систему
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await ApiService.post('/auth/login', {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final token = data['data']['token'];
          final user = data['data']['user'];

          // Сохраняем токен
          ApiService.setToken(token);

          return {'success': true, 'token': token, 'user': user};
        }
      }

      // Обработка ошибки
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Ошибка входа',
      };
    } catch (e) {
      return {'success': false, 'message': 'Ошибка соединения с сервером: $e'};
    }
  }

  /// Регистрация клиента
  static Future<Map<String, dynamic>> registerClient(
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await ApiService.post('/auth/register/client', userData);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return {
            'success': true,
            'user': data['data'],
            'message': 'Регистрация прошла успешно',
          };
        }
      }

      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Ошибка регистрации',
      };
    } catch (e) {
      return {'success': false, 'message': 'Ошибка соединения с сервером: $e'};
    }
  }

  /// Отправить код верификации
  static Future<Map<String, dynamic>> sendVerificationCode(
    String email, {
    bool isParentEmail = false,
  }) async {
    try {
      final response = await ApiService.post('/auth/send-code', {
        'email': email,
        'isParentEmail': isParentEmail,
      });

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Код отправлен на email'};
      }

      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Ошибка отправки кода',
      };
    } catch (e) {
      return {'success': false, 'message': 'Ошибка соединения с сервером: $e'};
    }
  }

  /// Проверить код верификации
  static Future<Map<String, dynamic>> verifyCode(
    String email,
    String code, {
    bool isParentEmail = false,
  }) async {
    try {
      final response = await ApiService.post('/auth/verify-code', {
        'email': email,
        'code': code,
        'isParentEmail': isParentEmail,
      });

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Email подтвержден'};
      }

      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'message': errorData['message'] ?? 'Неверный код',
      };
    } catch (e) {
      return {'success': false, 'message': 'Ошибка соединения с сервером: $e'};
    }
  }

  /// Получить текущий профиль
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiService.get('/auth/me', includeAuth: true);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          return {'success': true, 'user': data['data']};
        }
      }

      return {'success': false, 'message': 'Не удалось загрузить профиль'};
    } catch (e) {
      return {'success': false, 'message': 'Ошибка соединения с сервером: $e'};
    }
  }

  /// Выход из системы
  static Future<void> logout() async {
    ApiService.clearToken();
  }
}
