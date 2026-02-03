// lib/core/services/user_provider.dart

import 'package:flutter/material.dart';
import '../core/services/profile_patient_service.dart';
import '../core/storage/token_storage.dart';
import '../core/services/auth_api_service.dart';

class UserProvider with ChangeNotifier {
  final TokenStorage _storage = TokenStorage();
  final ProfilePatientService _profileService = ProfilePatientService();
  final AuthApiService _authService = AuthApiService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _userRole;
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  String? _userAvatar;
  int? _userId;
  int? _psychologistId;
  Map<String, dynamic>? _user;
  String? _error; // ✅ ДОБАВЛЕНО

  // Геттеры
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get userRole => _userRole;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userPhone => _userPhone;
  String? get userAvatar => _userAvatar;
  int? get userId => _userId;
  int? get psychologistId => _psychologistId;
  Map<String, dynamic>? get user => _user;
  String? get error => _error; // ✅ ДОБАВЛЕНО

  UserProvider() {
    _initializeUser();
  }

  // Public wrapper for compatibility with call sites.
  Future<void> initialize() async {
    await _initializeUser();
  }

  Future<void> _initializeUser() async {
    _isLoading = true;
    notifyListeners();

    final isLoggedIn = await _storage.isLoggedIn();

    if (isLoggedIn) {
      try {
        await loadProfile(); // ✅ ИЗМЕНЕНО: теперь вызываем loadProfile()
      } catch (e) {
        print('❌ Failed to load profile on init: $e');
        await _storage.clearAll();
        _isAuthenticated = false;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  // ✅ ДОБАВЛЕНО: Метод login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      if (response['success'] == true && response['data'] != null) {
        final token = response['data']['token'];
        await _storage.saveToken(token);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Ошибка входа';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('❌ Login error: $e');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ✅ ПЕРЕИМЕНОВАНО: loadUserProfile → loadProfile для совместимости
  Future<void> loadProfile() async {
    try {
      final response = await _profileService.getCurrentProfile();

      if (response['success'] == true && response['data'] != null) {
        final userData = response['data'];
        _user = userData;
        _userId = userData['userId'];
        _userName = userData['fullName'];
        _userEmail = userData['email'];
        _userPhone = userData['phone'];
        _userAvatar = userData['avatarUrl'];
        _userRole = userData['role'];

        // Извлекаем psychologistId для PSYCHOLOGIST
        if (_userRole == 'PSYCHOLOGIST' &&
            userData['psychologistProfile'] != null) {
          _psychologistId = userData['psychologistProfile']['profileId'];
          print('✅ Loaded psychologistId: $_psychologistId');
        }

        _isAuthenticated = true;
        _error = null;
        print('✅ User profile loaded: $_userName ($_userRole)');
      }
    } catch (e) {
      print('❌ Error loading user profile: $e');
      _error = e.toString();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // ✅ ДОБАВЛЕНО: Метод performLogin для совместимости
  Future<void> performLogin(String token) async {
    await _storage.saveToken(token);
    await loadProfile();
  }

  // ✅ ДОБАВЛЕНО: Метод performLogout
  Future<void> performLogout() async {
    await _storage.clearAll();
    _isAuthenticated = false;
    _userRole = null;
    _userName = null;
    _userEmail = null;
    _userPhone = null;
    _userAvatar = null;
    _userId = null;
    _psychologistId = null;
    _user = null;
    _error = null;
    notifyListeners();
  }

  // ✅ Метод updateProfile — вызывается из UnifiedProfilePage
  Future<bool> updateProfile({
    String? fullName,
    String? phone,
    String? gender,
    String? avatarUrl,
  }) async {
    try {
      final response = await _profileService.updateProfile(
        fullName: fullName,
        phone: phone,
        gender: gender,
      );

      if (response['success'] == true) {
        // Обновляем локальное состояние провайдера
        if (fullName != null) {
          _user?['fullName'] = fullName;
          _userName = fullName;
        }
        if (phone != null) _user?['phone'] = phone;
        if (gender != null) _user?['gender'] = gender;
        if (avatarUrl != null) {
          _user?['avatarUrl'] = avatarUrl;
          _userAvatar = avatarUrl;
        }

        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      print('❌ Error updating profile: $e');
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
