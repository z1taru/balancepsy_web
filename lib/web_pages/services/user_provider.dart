// lib/web_pages/services/user_provider.dart

import 'package:flutter/material.dart';
import './auth_service_impl.dart';
import './profile_service.dart';
import './storage_service.dart';

class UserProvider with ChangeNotifier {
  final StorageService _storage = StorageService();
  final ProfileService _profileService = ProfileService();

  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Геттеры для удобного доступа к данным
  String? get userName => _user?['name'];
  String? get userEmail => _user?['email'];
  String? get userAvatar => _user?['avatarUrl'];
  String? get userRole => _user?['role'];
  String? get userPhone => _user?['phone'];
  String? get userBirthDate => _user?['birthDate'];
  String? get userGender => _user?['gender'];
  String? get userTherapyGoals => _user?['therapyGoals'];

  // Инициализация при запуске приложения
  Future<void> initialize() async {
    await loadProfile();
  }

  // Вход в систему
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await AuthServiceImpl.login(email, password);
      if (result['success'] == true) {
        final token = result['token'] as String?;
        final user = result['user'];

        if (token != null) {
          await _storage.saveToken(token);
        }
        if (user is Map<String, dynamic>) {
          await _storage.saveUserData(user);
          _user = user;
        } else {
          _user = null;
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _error = result['message']?.toString() ?? 'Ошибка входа';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Загрузить профиль с сервера
  Future<void> loadProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final token = await _storage.getToken();
      
      if (token == null) {
        _user = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final userData = await _profileService.getCurrentUser();
      _user = userData;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Ошибка загрузки профиля: $e');
      _error = e.toString();
      _isLoading = false;
      
      // Если ошибка авторизации, очищаем данные
      if (e.toString().contains('Сессия истекла')) {
        _user = null;
      }
      
      notifyListeners();
    }
  }

  // Обновить профиль
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? birthDate,
    String? gender,
    String? therapyGoals,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedUser = await _profileService.updateProfile(
        name: name,
        phone: phone,
        birthDate: birthDate,
        gender: gender,
        therapyGoals: therapyGoals,
      );

      _user = updatedUser;
      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      print('Ошибка обновления профиля: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      
      return false;
    }
  }

  // Загрузить аватар
  Future<bool> uploadAvatar(String imagePath) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _profileService.uploadAvatar(imagePath);
      
      // Обновляем URL аватара в локальных данных
      if (_user != null) {
        _user!['avatarUrl'] = result['avatarUrl'];
      }

      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      print('Ошибка загрузки аватара: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      
      return false;
    }
  }

  // Изменить пароль
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _profileService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      print('Ошибка смены пароля: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      
      return false;
    }
  }

  // Выход из системы
  Future<void> performLogout() async {
    await _storage.clearToken();
    _user = null;
    notifyListeners();
  }

  // Удалить аккаунт
  Future<bool> deleteAccount() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _profileService.deleteAccount();
      
      _user = null;
      _isLoading = false;
      notifyListeners();
      
      return true;
    } catch (e) {
      print('Ошибка удаления аккаунта: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      
      return false;
    }
  }

  // Очистить ошибку
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
