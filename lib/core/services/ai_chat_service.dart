import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../../models/chat_message.dart';
import '../../models/chat_session.dart';

class AiChatService {
  // ✅ Используем динамический URL на основе окружения
  static String get _aiBaseUrl => ApiConfig.useLocalBackend
      ? 'http://localhost:8080/internal'
      : 'https://api.balance-psy.kz/internal';

  /// Проверить доступность AI
  Future<bool> isAiAvailable() async {
    try {
      final response = await http
          .get(Uri.parse('$_aiBaseUrl/ai-status'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['configured'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error checking AI availability: $e');
      return false;
    }
  }

  /// Отправить сообщение AI
  Future<String> sendMessage({
    required String message,
    required ChatSession session,
  }) async {
    try {
      final userId = _getUserIdForBackend(session);

      print('🤖 Sending message to AI: userId=$userId');
      print('🌐 Using backend: $_aiBaseUrl');

      final response = await http
          .post(
            Uri.parse('$_aiBaseUrl/ai-test?userId=$userId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'message': message}),
          )
          .timeout(const Duration(seconds: 90));

      print('📡 AI response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['status'] == 'success' && data['reply'] != null) {
          return data['reply'];
        }

        throw Exception('Некорректный ответ от AI');
      }

      if (response.statusCode == 503) {
        throw Exception(
          'AI временно недоступен. Попробуйте позже или обратитесь к администратору.',
        );
      }

      final error = json.decode(utf8.decode(response.bodyBytes));
      throw Exception(error['message'] ?? 'Ошибка при общении с AI');
    } catch (e) {
      print('❌ Error sending message to AI: $e');
      rethrow;
    }
  }

  /// Сбросить контекст диалога (начать заново)
  Future<void> resetThread(ChatSession session) async {
    try {
      final userId = _getUserIdForBackend(session);

      print('🔄 Resetting AI thread for userId=$userId');

      final response = await http
          .delete(Uri.parse('$_aiBaseUrl/ai-reset?userId=$userId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ Thread reset successfully');
      } else {
        print('⚠️ Failed to reset thread: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error resetting thread: $e');
      // Не прерываем работу, просто логируем
    }
  }

  /// Получить welcome message в зависимости от роли
  String getWelcomeMessage(UserMode userMode) {
    switch (userMode) {
      case UserMode.guest:
        return 'Привет! 👋\n\nЯ AI-ассистент BalancePsy. Могу ответить на общие вопросы о психологии и нашей платформе.\n\n⚠️ У вас есть 3 бесплатных сообщения. Зарегистрируйтесь для полного доступа.';

      case UserMode.client:
        return 'Привет! 👋\n\nЯ ваш AI-ассистент. Могу помочь с:\n\n• Ответами на вопросы о психологии\n• Поиском подходящего специалиста\n• Общими рекомендациями\n\n❗️ Помните: я не заменяю профессионального психолога.';

      case UserMode.psychologist:
        return 'Привет! 👋\n\nЯ AI-ассистент для психологов. Могу помочь с:\n\n• Анализом клиентских запросов\n• Супервизией сложных случаев\n• Рекомендациями по методологии\n\nЧем могу быть полезен?';
    }
  }

  /// Получить system prompt для разных ролей
  String _getSystemPrompt(UserMode userMode) {
    switch (userMode) {
      case UserMode.guest:
        return 'Ты AI-консультант платформы BalancePsy. Отвечай кратко и дружелюбно на общие вопросы.';

      case UserMode.client:
        return 'Ты AI-помощник для клиентов платформы психотерапии. Давай поддержку, но всегда напоминай о необходимости работы с реальным психологом.';

      case UserMode.psychologist:
        return 'Ты AI-супервизор для психологов. Помогай с профессиональными вопросами, анализом случаев и методологией.';
    }
  }

  /// Сформировать userId для backend
  String _getUserIdForBackend(ChatSession session) {
    if (session.isGuest) {
      return session.sessionId; // guest_123456789
    }

    final prefix = session.userMode == UserMode.psychologist
        ? 'psycho'
        : 'client';
    return '${prefix}_${session.userId}';
  }
}
