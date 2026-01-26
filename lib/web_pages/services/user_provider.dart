import 'package:flutter/foundation.dart';
import 'auth_service_impl.dart';
import 'api_service.dart';
import 'storage_service.dart';

/// Provider для управления состоянием пользователя
class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  // Getters
  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isInitialized => _isInitialized;

  /// Инициализация - загрузить данные из локального хранилища
  Future<void> initialize() async {
    if (_isInitialized) return;

    _isLoading = true;
    notifyListeners();

    try {
      final token = await StorageService.getToken();
      final userData = await StorageService.getUser();

      if (token != null && userData != null) {
        _token = token;
        _user = userData;
        ApiService.setToken(token);

        // Попробовать обновить профиль
        await loadProfile();
      }
    } catch (e) {
      debugPrint('Error initializing user: $e');
    } finally {
      _isInitialized = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Установить данные пользователя
  Future<void> setUser(Map<String, dynamic> userData, String authToken) async {
    _user = userData;
    _token = authToken;
    _error = null;

    // Сохраняем в локальное хранилище
    await StorageService.saveToken(authToken);
    await StorageService.saveUser(userData);
    ApiService.setToken(authToken);

    notifyListeners();
  }

  /// Обновить данные пользователя
  Future<void> updateUser(Map<String, dynamic> userData) async {
    _user = userData;
    _error = null;

    // Сохраняем в локальное хранилище
    await StorageService.saveUser(userData);

    notifyListeners();
  }

  /// Установить состояние загрузки
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Установить ошибку
  void setError(String errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }

  /// Очистить ошибку
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Выход из системы
  Future<void> logout() async {
    _user = null;
    _token = null;
    _error = null;
    _isLoading = false;

    // Очищаем локальное хранилище
    await StorageService.clearAll();
    ApiService.clearToken();

    notifyListeners();
  }

  /// Получить роль пользователя
  String? get userRole => _user?['role'];

  /// Получить имя пользователя
  String? get userName => _user?['fullName'];

  /// Получить email
  String? get userEmail => _user?['email'];

  /// Получить аватар
  String? get userAvatar => _user?['avatarUrl'];

  /// Проверить, является ли пользователь клиентом
  bool get isClient => userRole == 'CLIENT';

  /// Проверить, является ли пользователь психологом
  bool get isPsychologist => userRole == 'PSYCHOLOGIST';

  /// Проверить, является ли пользователь админом
  bool get isAdmin => userRole == 'ADMIN';

  /// Вход в систему
  Future<bool> login(String email, String password) async {
    setLoading(true);
    clearError();

    final result = await AuthServiceImpl.login(email, password);

    if (result['success'] == true) {
      await setUser(result['user'], result['token']);
      setLoading(false);
      return true;
    } else {
      setError(result['message'] ?? 'Ошибка входа');
      setLoading(false);
      return false;
    }
  }

  /// Загрузить профиль
  Future<bool> loadProfile() async {
    if (!ApiService.isAuthenticated()) {
      return false;
    }

    setLoading(true);

    final result = await AuthServiceImpl.getProfile();

    if (result['success'] == true) {
      await updateUser(result['user']);
      setLoading(false);
      return true;
    } else {
      setLoading(false);
      return false;
    }
  }

  /// Выход с очисткой токена
  Future<void> performLogout() async {
    await AuthServiceImpl.logout();
    await logout();
  }
}
