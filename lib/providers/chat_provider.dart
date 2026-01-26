
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../models/chat_session.dart';
import '../сore/services/ai_chat_service.dart';
import '../сore/services/chat_storage_service.dart';
import '../сore/storage/token_storage.dart';

class ChatProvider with ChangeNotifier {
  final AiChatService _aiService = AiChatService();
  final ChatStorageService _storageService = ChatStorageService();
  final TokenStorage _tokenStorage = TokenStorage();

  ChatSession? _currentSession;
  bool _isLoading = false;
  bool _isAiAvailable = false;
  String? _error;

  // Getters
  ChatSession? get currentSession => _currentSession;
  List<ChatMessage> get messages => _currentSession?.messages ?? [];
  bool get isLoading => _isLoading;
  bool get isAiAvailable => _isAiAvailable;
  String? get error => _error;
  bool get hasSession => _currentSession != null;
  
  bool get canSendMessage => 
      _currentSession != null && 
      _currentSession!.canSendMessage &&
      !_isLoading;
  
  int get remainingMessages => _currentSession?.remainingMessages ?? 0;
  bool get isGuest => _currentSession?.isGuest ?? true;

  ChatProvider() {
    _initialize();
  }

  /// Инициализация
  Future<void> _initialize() async {
    await checkAiAvailability();
    await _loadOrCreateSession();
  }

  /// Проверить доступность AI
  Future<void> checkAiAvailability() async {
    _isAiAvailable = await _aiService.isAiAvailable();
    notifyListeners();
  }

  /// Загрузить или создать новую сессию
  Future<void> _loadOrCreateSession() async {
    try {
      // Пытаемся загрузить сохраненную сессию
      final savedSession = await _storageService.loadSession();

      if (savedSession != null) {
        _currentSession = savedSession;
        print('✅ Loaded saved session: ${savedSession.sessionId}');
      } else {
        // Создаем новую сессию в зависимости от авторизации
        await _createNewSession();
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error loading session: $e');
      await _createNewSession();
    }
  }

  /// Создать новую сессию
  Future<void> _createNewSession() async {
    final isLoggedIn = await _tokenStorage.isLoggedIn();
    final role = await _tokenStorage.getUserRole();

    if (isLoggedIn && role != null) {
      final userId = await _getUserId();
      final userMode = _getUserMode(role);

      _currentSession = ChatSession.authenticated(
        userId: userId ?? 'unknown',
        userMode: userMode,
      );

      // Добавляем приветственное сообщение
      _addWelcomeMessage();
    } else {
      _currentSession = ChatSession.guest();
      _addWelcomeMessage();
    }

    await _storageService.saveSession(_currentSession!);
    notifyListeners();
  }

  /// Добавить приветственное сообщение
  void _addWelcomeMessage() {
    if (_currentSession == null) return;

    final welcomeText = _aiService.getWelcomeMessage(_currentSession!.userMode);
    final welcomeMessage = ChatMessage.assistant(welcomeText);

    _currentSession = _currentSession!.copyWith(
      messages: [welcomeMessage],
    );
  }

  /// Отправить сообщение
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || _currentSession == null || _isLoading) {
      return;
    }

    if (!_currentSession!.canSendMessage) {
      _error = 'Достигнут лимит сообщений. Зарегистрируйтесь для продолжения.';
      notifyListeners();
      return;
    }

    if (!_isAiAvailable) {
      _error = 'AI временно недоступен';
      notifyListeners();
      return;
    }

    _error = null;
    _isLoading = true;

    // Добавляем сообщение пользователя
    final userMessage = ChatMessage.user(text.trim());
    _currentSession = _currentSession!.copyWith(
      messages: [..._currentSession!.messages, userMessage],
      updatedAt: DateTime.now(),
    );
    notifyListeners();

    // Добавляем индикатор загрузки
    final loadingMessage = ChatMessage.loading();
    _currentSession = _currentSession!.copyWith(
      messages: [..._currentSession!.messages, loadingMessage],
    );
    notifyListeners();

    try {
      // Отправляем запрос к AI
      final reply = await _aiService.sendMessage(
        message: text.trim(),
        session: _currentSession!,
      );

      // Удаляем loading и добавляем ответ
      final messagesWithoutLoading = _currentSession!.messages
          .where((m) => m.id != 'loading')
          .toList();

      final assistantMessage = ChatMessage.assistant(reply);

      _currentSession = _currentSession!.copyWith(
        messages: [...messagesWithoutLoading, assistantMessage],
        updatedAt: DateTime.now(),
      );

      // Сохраняем сессию
      await _storageService.saveSession(_currentSession!);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error sending message: $e');

      // Удаляем loading и показываем ошибку
      final messagesWithoutLoading = _currentSession!.messages
          .where((m) => m.id != 'loading')
          .toList();

      final errorMessage = ChatMessage.error(
        'Извините, произошла ошибка: ${e.toString()}',
      );

      _currentSession = _currentSession!.copyWith(
        messages: [...messagesWithoutLoading, errorMessage],
      );

      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Начать новый диалог
  Future<void> startNewChat() async {
    if (_currentSession != null) {
      // Сохраняем в историю если есть сообщения
      if (_currentSession!.messages.length > 1) {
        await _storageService.saveToHistory(_currentSession!);
      }

      // Сбрасываем thread на backend
      await _aiService.resetThread(_currentSession!);
    }

    // Создаем новую сессию
    await _createNewSession();
    notifyListeners();
  }

  /// Очистить ошибку
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Получить историю диалогов
  Future<List<ChatSession>> getHistory() async {
    return await _storageService.getHistory();
  }

  /// Загрузить конкретную сессию из истории
  Future<void> loadSession(ChatSession session) async {
    _currentSession = session;
    await _storageService.saveSession(session);
    notifyListeners();
  }

  /// Удалить сессию из истории
  Future<void> deleteSession(String sessionId) async {
    await _storageService.deleteSession(sessionId);
    notifyListeners();
  }

  /// Обновить сессию после авторизации
  Future<void> onUserLoggedIn(String userId, String role) async {
    if (_currentSession != null && _currentSession!.isGuest) {
      // Сохраняем сообщения из гостевой сессии
      final guestMessages = _currentSession!.messages;

      // Создаем авторизованную сессию
      final userMode = _getUserMode(role);
      _currentSession = ChatSession.authenticated(
        userId: userId,
        userMode: userMode,
      );

      // Добавляем приветственное сообщение
      _addWelcomeMessage();

      // Переносим старые сообщения (кроме welcome)
      if (guestMessages.length > 1) {
        _currentSession = _currentSession!.copyWith(
          messages: [
            ..._currentSession!.messages,
            ...guestMessages.skip(1), // Пропускаем старое welcome
          ],
        );
      }

      await _storageService.saveSession(_currentSession!);
      notifyListeners();
    }
  }

  /// Сбросить сессию при логауте
  Future<void> onUserLoggedOut() async {
    if (_currentSession != null && !_currentSession!.isGuest) {
      // Сохраняем в историю
      await _storageService.saveToHistory(_currentSession!);

      // Создаем гостевую сессию
      _currentSession = ChatSession.guest();
      _addWelcomeMessage();

      await _storageService.saveSession(_currentSession!);
      notifyListeners();
    }
  }

  // Helper methods
  Future<String?> _getUserId() async {
    final email = await _tokenStorage.getUserEmail();
    return email?.split('@')[0]; // Используем часть email как ID
  }

  UserMode _getUserMode(String role) {
    switch (role.toUpperCase()) {
      case 'PSYCHOLOGIST':
        return UserMode.psychologist;
      case 'CLIENT':
        return UserMode.client;
      default:
        return UserMode.guest;
    }
  }
}