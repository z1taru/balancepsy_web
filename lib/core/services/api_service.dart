import 'dart:convert';
import 'package:http/http.dart' as http;

/// Базовый сервис для работы с API
class ApiService {
  static const String baseUrl = 'https://api.balance-psy.kz';
  //static const String baseUrl = 'http://localhost:8080/api';

  static String? _authToken;

  /// Установить токен авторизации
  static void setToken(String token) {
    _authToken = token;
  }

  /// Получить токен
  static String? getToken() {
    return _authToken;
  }

  /// Очистить токен
  static void clearToken() {
    _authToken = null;
  }

  /// Проверить, авторизован ли пользователь
  static bool isAuthenticated() {
    return _authToken != null && _authToken!.isNotEmpty;
  }

  /// Получить заголовки для запроса
  static Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {'Content-Type': 'application/json'};

    if (includeAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  /// GET запрос
  static Future<http.Response> get(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url, headers: _getHeaders(includeAuth: includeAuth));
  }

  /// POST запрос
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = false,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: _getHeaders(includeAuth: includeAuth),
      body: jsonEncode(body),
    );
  }

  /// PUT запрос
  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.put(
      url,
      headers: _getHeaders(includeAuth: includeAuth),
      body: jsonEncode(body),
    );
  }

  /// DELETE запрос
  static Future<http.Response> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.delete(
      url,
      headers: _getHeaders(includeAuth: includeAuth),
    );
  }
}
