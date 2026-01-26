// lib/сore/services/auth_api_service.dart
import '../config/api_config.dart';
import '../storage/token_storage.dart';
import 'api_client.dart';

class AuthApiService {
  final ApiClient _apiClient = ApiClient();
  final TokenStorage _tokenStorage = TokenStorage();

  // ========================================
  // Login
  // ========================================
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(ApiConfig.login, {
      'email': email,
      'password': password,
    }, requiresAuth: false);

    // Извлекаем данные из ответа
    if (response['success'] == true && response['data'] != null) {
      final data = response['data'];
      final token = data['token'];
      final user = data['user'];

      // Сохраняем токен и информацию о пользователе
      await _tokenStorage.saveAuthData(
        token: token,
        role: user['role'],
        email: user['email'],
      );

      return response;
    }

    throw ApiException('Ошибка авторизации');
  }

  // ========================================
  // Register Client
  // ========================================
  Future<Map<String, dynamic>> registerClient({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    List<String>? interests,
    String? registrationGoal,
    bool isMinor = false,
    String? parentEmail,
  }) async {
    final body = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'password': password,
    };

    if (phone != null) body['phone'] = phone;
    if (dateOfBirth != null)
      body['dateOfBirth'] = dateOfBirth.toIso8601String();
    if (gender != null) body['gender'] = gender;
    if (interests != null) body['interests'] = interests;
    if (registrationGoal != null) body['registrationGoal'] = registrationGoal;
    body['isMinor'] = isMinor;
    if (parentEmail != null) body['parentEmail'] = parentEmail;

    return await _apiClient.post(
      ApiConfig.register,
      body,
      requiresAuth: false,
    );
  }

  // ========================================
  // Register Psychologist
  // ========================================
  Future<Map<String, dynamic>> registerPsychologist({
    required String fullName,
    required String email,
    required String password,
    required String phone,
    required String specialization,
    required int experienceYears,
    required String bio,
    required String education,
    String? certificateUrl,
    List<String>? approaches,
    double? hourlyRate,
  }) async {
    final body = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'password': password,
      'phone': phone,
      'specialization': specialization,
      'experienceYears': experienceYears,
      'bio': bio,
      'education': education,
    };

    if (certificateUrl != null) body['certificateUrl'] = certificateUrl;
    if (approaches != null) body['approaches'] = approaches;
    if (hourlyRate != null) body['hourlyRate'] = hourlyRate;

    return await _apiClient.post(
      ApiConfig.registerPsychologist,
      body,
      requiresAuth: false,
    );
  }

  // ========================================
  // Send Verification Code
  // ========================================
  Future<Map<String, dynamic>> sendVerificationCode({
    required String email,
    bool isParentEmail = false,
  }) async {
    return await _apiClient.post(ApiConfig.sendCode, {
      'email': email,
      'isParentEmail': isParentEmail,
    }, requiresAuth: false);
  }

  // ========================================
  // Verify Email Code
  // ========================================
  Future<Map<String, dynamic>> verifyCode({
    required String email,
    required String code,
    bool isParentEmail = false,
  }) async {
    return await _apiClient.post(ApiConfig.verifyCode, {
      'email': email,
      'code': code,
      'isParentEmail': isParentEmail,
    }, requiresAuth: false);
  }

  // ========================================
  // Get Current User
  // ========================================
  Future<Map<String, dynamic>> getCurrentUser() async {
    return await _apiClient.get(ApiConfig.me, requiresAuth: true);
  }

  // ========================================
  // Forgot Password
  // ========================================
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await _apiClient.post(ApiConfig.forgotPassword, {
      'email': email,
    }, requiresAuth: false);
  }

  // ========================================
  // Reset Password
  // ========================================
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async {
    return await _apiClient.post(ApiConfig.resetPassword, {
      'email': email,
      'code': code,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    }, requiresAuth: false);
  }

  // ========================================
  // Logout
  // ========================================
  Future<void> logout() async {
    await _tokenStorage.clearAll();
  }

  // ========================================
  // Check Auth Status
  // ========================================
  Future<bool> isLoggedIn() async {
    return await _tokenStorage.isLoggedIn();
  }

  // ========================================
  // Get User Role
  // ========================================
  Future<String?> getUserRole() async {
    return await _tokenStorage.getUserRole();
  }
}
