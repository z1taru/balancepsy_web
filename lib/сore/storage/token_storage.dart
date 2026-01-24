// lib/сore/storage/token_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userRoleKey = 'user_role';
  static const String _userEmailKey = 'user_email';

  // ========================================
  // Save Token
  // ========================================
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // ========================================
  // Get Token
  // ========================================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ========================================
  // Save Refresh Token
  // ========================================
  Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  // ========================================
  // Get Refresh Token
  // ========================================
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // ========================================
  // Save User Info
  // ========================================
  Future<void> saveUserInfo({
    required String role,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userRoleKey, role);
    await prefs.setString(_userEmailKey, email);
  }

  // ========================================
  // Get User Role
  // ========================================
  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  // ========================================
  // Get User Email
  // ========================================
  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // ========================================
  // Check if Logged In
  // ========================================
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ========================================
  // Clear All Data (Logout)
  // ========================================
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_userEmailKey);
  }

  // ========================================
  // Save Complete Auth Data
  // ========================================
  Future<void> saveAuthData({
    required String token,
    String? refreshToken,
    required String role,
    required String email,
  }) async {
    await saveToken(token);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
    await saveUserInfo(role: role, email: email);
  }
}
