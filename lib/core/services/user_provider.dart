import 'package:flutter/material.dart';
import './unified_auth_service.dart';
import '../../providers/chat_provider.dart';

class UserProvider with ChangeNotifier {
  final UnifiedAuthService _authService = UnifiedAuthService();
  ChatProvider? _chatProvider;

  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // ✅ Геттеры для удобного доступа
  String? get userName => _user?['fullName'];
  String? get userEmail => _user?['email'];
  String? get userAvatar => _user?['avatarUrl'];
  String? get userRole => _user?['role']; // ✅ CLIENT, PSYCHOLOGIST, ADMIN
  String? get userPhone => _user?['phone'];
  String? get userBirthDate => _user?['dateOfBirth'];
  String? get userGender => _user?['gender'];

  // ✅ Для психолога (если role == PSYCHOLOGIST)
  Map<String, dynamic>? get psychologistProfile =>
      _user?['psychologistProfile'];

  void attachChatProvider(ChatProvider provider) {
    _chatProvider = provider;
  }

  Future<void> initialize() async {
    await loadProfile();
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _authService.login(email: email, password: password);

      if (result['success'] == true) {
        _user = result['user'];
        await _chatProvider?.onUserLoggedIn(
          _user!['userId'].toString(),
          _user!['role'],
        );

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

  Future<void> loadProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final isLoggedIn = await _authService.isLoggedIn();

      if (!isLoggedIn) {
        _user = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      // ✅ Загружаем профиль с /api/auth/me
      final result = await _authService.getProfile();

      if (result['success'] == true) {
        _user = result['profile'];
        print('✅ Profile loaded: role=${_user?['role']}');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading profile: $e');
      _error = e.toString();
      _isLoading = false;

      // Если ошибка авторизации, очищаем данные
      if (e.toString().contains('Сессия истекла')) {
        _user = null;
      }

      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? dateOfBirth,
    String? gender,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updates = <String, dynamic>{};
      if (fullName != null) updates['fullName'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (dateOfBirth != null) updates['dateOfBirth'] = dateOfBirth;
      if (gender != null) updates['gender'] = gender;

      final result = await _authService.updateProfile(updates);

      if (result['success'] == true) {
        _user = result['profile'];
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('❌ Error updating profile: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> performLogout() async {
    await _authService.logout();

    // ✅ ДОБАВИТЬ: Сбросить ChatProvider
    await _chatProvider?.onUserLoggedOut();

    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  String getDashboardRoute() {
    switch (userRole) {
      case 'PSYCHOLOGIST':
        return '/psycho/dashboard';
      case 'CLIENT':
        return '/dashboard';
      case 'ADMIN':
        return '/psycho/dashboard'; // или создайте отдельный admin dashboard
      default:
        return '/';
    }
  }

  String getProfileRoute() {
    switch (userRole) {
      case 'PSYCHOLOGIST':
        return '/psycho/profile';
      case 'CLIENT':
        return '/profile';
      case 'ADMIN':
        return '/psycho/profile';
      default:
        return '/';
    }
  }
}
