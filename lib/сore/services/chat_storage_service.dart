// lib/сore/services/chat_storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/chat_session.dart';

class ChatStorageService {
  static const String _sessionKey = 'ai_chat_session';
  static const String _historyKey = 'ai_chat_history';

  /// Сохранить текущую сессию
  Future<void> saveSession(ChatSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = json.encode(session.toJson());
      await prefs.setString(_sessionKey, sessionJson);
      print('✅ Chat session saved');
    } catch (e) {
      print('❌ Error saving chat session: $e');
    }
  }

  /// Загрузить сохраненную сессию
  Future<ChatSession?> loadSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionJson = prefs.getString(_sessionKey);

      if (sessionJson == null) {
        return null;
      }

      final sessionData = json.decode(sessionJson);
      return ChatSession.fromJson(sessionData);
    } catch (e) {
      print('❌ Error loading chat session: $e');
      return null;
    }
  }

  /// Очистить текущую сессию
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_sessionKey);
      print('🗑️ Chat session cleared');
    } catch (e) {
      print('❌ Error clearing chat session: $e');
    }
  }

  /// Сохранить сессию в историю (для авторизованных)
  Future<void> saveToHistory(ChatSession session) async {
    try {
      if (session.isGuest || session.messages.isEmpty) {
        return; // Не сохраняем пустые или гостевые сессии
      }

      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);

      List<Map<String, dynamic>> history = [];

      if (historyJson != null) {
        history = List<Map<String, dynamic>>.from(json.decode(historyJson));
      }

      // Добавляем текущую сессию
      history.insert(0, session.toJson());

      // Храним максимум 10 последних сессий
      if (history.length > 10) {
        history = history.sublist(0, 10);
      }

      await prefs.setString(_historyKey, json.encode(history));
      print('✅ Session saved to history');
    } catch (e) {
      print('❌ Error saving to history: $e');
    }
  }

  /// Получить историю сессий
  Future<List<ChatSession>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);

      if (historyJson == null) {
        return [];
      }

      final historyData = List<Map<String, dynamic>>.from(
        json.decode(historyJson),
      );
      return historyData.map((data) => ChatSession.fromJson(data)).toList();
    } catch (e) {
      print('❌ Error loading history: $e');
      return [];
    }
  }

  /// Очистить всю историю
  Future<void> clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      print('🗑️ Chat history cleared');
    } catch (e) {
      print('❌ Error clearing history: $e');
    }
  }

  /// Удалить конкретную сессию из истории
  Future<void> deleteSession(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_historyKey);

      if (historyJson == null) return;

      var history = List<Map<String, dynamic>>.from(json.decode(historyJson));
      history.removeWhere((session) => session['sessionId'] == sessionId);

      await prefs.setString(_historyKey, json.encode(history));
      print('✅ Session deleted from history');
    } catch (e) {
      print('❌ Error deleting session: $e');
    }
  }
}
