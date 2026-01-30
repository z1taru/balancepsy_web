// lib/сore/services/chat_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../storage/token_storage.dart';

class ChatService {
  final TokenStorage _tokenStorage = TokenStorage();

  /// Получить все чаты пользователя
  Future<List<Map<String, dynamic>>> getUserChats() async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null) throw Exception('Токен не найден');

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/chats'),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      return [];
    } catch (e) {
      print('❌ Error loading chats: $e');
      return [];
    }
  }

  /// Получить сообщения чата
  Future<List<Map<String, dynamic>>> getChatMessages(int chatRoomId) async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null) throw Exception('Токен не найден');

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/chats/$chatRoomId/messages'),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['success'] == true && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }

      return [];
    } catch (e) {
      print('❌ Error loading messages: $e');
      return [];
    }
  }

  /// Отправить сообщение
  Future<Map<String, dynamic>> sendMessage({
    required int chatRoomId,
    required String text,
    String messageType = 'text',
  }) async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null) throw Exception('Токен не найден');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/chats/messages'),
            headers: ApiConfig.headersWithAuth(token),
            body: json.encode({
              'chatRoomId': chatRoomId,
              'text': text,
              'messageType': messageType,
            }),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        }
      }

      throw Exception('Не удалось отправить сообщение');
    } catch (e) {
      print('❌ Error sending message: $e');
      rethrow;
    }
  }

  /// Отметить сообщения как прочитанные
  Future<void> markMessagesAsRead(int chatRoomId) async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null) return;

      await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}/chats/$chatRoomId/read'),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);
    } catch (e) {
      print('❌ Error marking messages as read: $e');
    }
  }

  /// Получить ссылку на видеосессию Zvonda
  Future<String> getZvondaUrl(int chatRoomId) async {
    try {
      final token = await _tokenStorage.getToken();
      if (token == null) throw Exception('Токен не найден');

      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/chats/$chatRoomId/zvonda-url'),
            headers: ApiConfig.headersWithAuth(token),
          )
          .timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['success'] == true && data['data'] != null) {
          return data['data']['zvondaUrl'];
        }
      }

      throw Exception('Не удалось получить ссылку');
    } catch (e) {
      print('❌ Error getting Zvonda URL: $e');
      rethrow;
    }
  }
}
