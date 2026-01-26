// lib/сore/services/api_client.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/token_storage.dart';

class ApiClient {
  final TokenStorage _tokenStorage = TokenStorage();

  // ========================================
  // GET Request
  // ========================================
  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth);

      final response = await http
          .get(Uri.parse(endpoint), headers: headers)
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Нет подключения к интернету');
    } on HttpException {
      throw ApiException('Ошибка сети');
    } catch (e) {
      throw ApiException('Неизвестная ошибка: $e');
    }
  }

  // ========================================
  // POST Request
  // ========================================
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth);

      final response = await http
          .post(Uri.parse(endpoint), headers: headers, body: jsonEncode(body))
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Нет подключения к интернету');
    } on HttpException {
      throw ApiException('Ошибка сети');
    } catch (e) {
      throw ApiException('Неизвестная ошибка: $e');
    }
  }

  // ========================================
  // PUT Request
  // ========================================
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth);

      final response = await http
          .put(Uri.parse(endpoint), headers: headers, body: jsonEncode(body))
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Нет подключения к интернету');
    } on HttpException {
      throw ApiException('Ошибка сети');
    } catch (e) {
      throw ApiException('Неизвестная ошибка: $e');
    }
  }

  // ========================================
  // DELETE Request
  // ========================================
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth);

      final response = await http
          .delete(Uri.parse(endpoint), headers: headers)
          .timeout(ApiConfig.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Нет подключения к интернету');
    } on HttpException {
      throw ApiException('Ошибка сети');
    } catch (e) {
      throw ApiException('Неизвестная ошибка: $e');
    }
  }

  // ========================================
  // Multipart Request (для загрузки файлов)
  // ========================================
  Future<Map<String, dynamic>> uploadFile(
    String endpoint,
    File file,
    String fieldName, {
    Map<String, String>? additionalFields,
  }) async {
    try {
      final token = await _tokenStorage.getToken();

      var request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Добавляем токен
      if (token != null) {
        request.headers.addAll(ApiConfig.headersWithAuth(token));
      }

      // Добавляем файл
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );

      // Добавляем дополнительные поля
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
      );

      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw ApiException('Нет подключения к интернету');
    } on HttpException {
      throw ApiException('Ошибка сети');
    } catch (e) {
      throw ApiException('Неизвестная ошибка: $e');
    }
  }

  // ========================================
  // Private Helper Methods
  // ========================================

  Future<Map<String, String>> _getHeaders(bool requiresAuth) async {
    if (requiresAuth) {
      final token = await _tokenStorage.getToken();
      if (token == null) {
        throw ApiException('Требуется авторизация');
      }
      return ApiConfig.headersWithAuth(token);
    }
    return ApiConfig.headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    // Успешные ответы (200-299)
    if (statusCode >= 200 && statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      return decoded as Map<String, dynamic>;
    }

    // Ошибки клиента (400-499)
    if (statusCode >= 400 && statusCode < 500) {
      String errorMessage = 'Ошибка запроса';

      try {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        errorMessage = decoded['message'] ?? errorMessage;
      } catch (e) {
        // Если не удалось распарсить JSON
      }

      if (statusCode == 401) {
        throw AuthException('Требуется повторная авторизация');
      }

      if (statusCode == 403) {
        throw AuthException('Доступ запрещён');
      }

      if (statusCode == 404) {
        throw ApiException('Ресурс не найден');
      }

      throw ApiException(errorMessage);
    }

    // Ошибки сервера (500+)
    if (statusCode >= 500) {
      throw ApiException('Ошибка сервера. Попробуйте позже');
    }

    throw ApiException('Неизвестная ошибка: $statusCode');
  }
}

// ========================================
// Custom Exceptions
// ========================================

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
