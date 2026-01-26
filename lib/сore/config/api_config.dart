// lib/сore/config/api_config.dart

class ApiConfig {
  // ========================================
  // Base URLs
  // ========================================

  // ✅ ИСПРАВЛЕНО: Для Flutter Web используем 127.0.0.1 вместо localhost
  static const String devBaseUrl = 'http://127.0.0.1:8080/api';

  // Для продакшена (замените на ваш домен)
  static const String prodBaseUrl = 'https://api.balance-psy.kz/api';

  // Текущий режим
  static const bool isDevelopment = true;

  // Активный базовый URL
  static String get baseUrl => isDevelopment ? devBaseUrl : prodBaseUrl;

  // ========================================
  // Auth Endpoints
  // ========================================
  static String get registerClient => '$baseUrl/auth/register/client';
  static String get registerPsychologist =>
      '$baseUrl/auth/register/psychologist';
  static String get login => '$baseUrl/auth/login';
  static String get sendCode => '$baseUrl/auth/send-code';
  static String get verifyCode => '$baseUrl/auth/verify-code';
  static String get me => '$baseUrl/auth/me';
  static String get forgotPassword => '$baseUrl/auth/forgot-password';
  static String get resetPassword => '$baseUrl/auth/reset-password';

  // ========================================
  // User Endpoints
  // ========================================
  static String get currentUser => '$baseUrl/users/me';
  static String get updateProfile => '$baseUrl/users/me';
  static String get changePassword => '$baseUrl/users/me/password';
  static String get uploadAvatar => '$baseUrl/users/me/avatar';
  static String get deleteAccount => '$baseUrl/users/me';
  static String get searchClient => '$baseUrl/users/search';

  // ========================================
  // Psychologist Endpoints
  // ========================================
  static String get psychologists => '$baseUrl/psychologists';
  static String get topPsychologists => '$baseUrl/psychologists/top';
  static String psychologistById(int id) => '$baseUrl/psychologists/$id';
  static String get myPsychologist => '$baseUrl/psychologists/me';
  static String get updateAvailability =>
      '$baseUrl/psychologists/me/availability';
  static String psychologistSchedule(int id) =>
      '$baseUrl/psychologists/$id/schedule';
  static String get mySchedule => '$baseUrl/psychologists/me/schedule';

  // ========================================
  // Appointment Endpoints
  // ========================================
  static String get appointments => '$baseUrl/appointments';
  static String get myAppointments => '$baseUrl/appointments/me';
  static String get psychologistAppointments =>
      '$baseUrl/appointments/psychologist/me';
  static String confirmAppointment(int id) =>
      '$baseUrl/appointments/$id/confirm';
  static String rejectAppointment(int id) => '$baseUrl/appointments/$id/reject';
  static String cancelAppointment(int id) => '$baseUrl/appointments/$id/cancel';
  static String startAppointment(int id) => '$baseUrl/appointments/$id/start';
  static String completeAppointment(int id) =>
      '$baseUrl/appointments/$id/complete';
  static String markNoShow(int id) => '$baseUrl/appointments/$id/no-show';

  // ========================================
  // Article Endpoints
  // ========================================
  static String get articles => '$baseUrl/articles';
  static String articleBySlug(String slug) => '$baseUrl/articles/slug/$slug';
  static String get searchArticles => '$baseUrl/articles/search';
  static String get topArticles => '$baseUrl/articles/top';
  static String get favoriteArticles => '$baseUrl/articles/favorites';
  static String addToFavorites(int id) => '$baseUrl/articles/$id/favorite';
  static String removeFromFavorites(int id) => '$baseUrl/articles/$id/favorite';
  static String isFavorite(int id) => '$baseUrl/articles/$id/is-favorite';

  // ========================================
  // Review Endpoints
  // ========================================
  static String get reviews => '$baseUrl/reviews';
  static String get myReviews => '$baseUrl/reviews/my';
  static String psychologistReviews(int psychologistId) =>
      '$baseUrl/reviews/psychologist/$psychologistId';
  static String reviewById(int id) => '$baseUrl/reviews/$id';
  static String canReview(int appointmentId) =>
      '$baseUrl/reviews/appointment/$appointmentId/can-review';

  // ========================================
  // Chat Endpoints
  // ========================================
  static String get chats => '$baseUrl/chats';
  static String chatWithPsychologist(int psychologistId) =>
      '$baseUrl/chats/psychologist/$psychologistId';
  static String chatMessages(int chatRoomId) =>
      '$baseUrl/chats/$chatRoomId/messages';
  static String get sendMessage => '$baseUrl/chats/messages';
  static String uploadChatFile(int chatRoomId) =>
      '$baseUrl/chats/$chatRoomId/upload';
  static String uploadVoice(int chatRoomId) =>
      '$baseUrl/chats/$chatRoomId/voice';
  static String markAsRead(int chatRoomId) => '$baseUrl/chats/$chatRoomId/read';
  static String zvondaUrl(int chatRoomId) =>
      '$baseUrl/chats/$chatRoomId/zvonda-url';

  // ========================================
  // Diagnostic Endpoints
  // ========================================
  static String get submitDiagnostic => '$baseUrl/diagnostic/submit';
  static String get latestDiagnostic => '$baseUrl/diagnostic/latest';
  static String get diagnosticHistory => '$baseUrl/diagnostic/history';
  static String clientDiagnostic(int clientId) =>
      '$baseUrl/diagnostic/client/$clientId';

  // ========================================
  // Dynamic Diagnostic Endpoints
  // ========================================
  static String testQuestions(String testCode) =>
      '$baseUrl/diagnostics/tests/$testCode';
  static String get submitSession => '$baseUrl/diagnostics/sessions/submit';
  static String get mySessions => '$baseUrl/diagnostics/sessions/my';
  static String exportSession(int sessionId) =>
      '$baseUrl/diagnostics/sessions/$sessionId/export';

  // ========================================
  // Intro Endpoints
  // ========================================
  static String get introContent => '$baseUrl/intro/content';
  static String get completeIntro => '$baseUrl/intro/complete';
  static String get introStatus => '$baseUrl/intro/status';

  // ========================================
  // Mood Survey Endpoints
  // ========================================
  static String get moodSurveys => '$baseUrl/mood-surveys';
  static String get moodHistory => '$baseUrl/mood-surveys/history';

  // ========================================
  // Progress Endpoints
  // ========================================
  static String get myProgress => '$baseUrl/progress/me';

  // ========================================
  // Statistics Endpoints
  // ========================================
  static String get myStatistics => '$baseUrl/statistics/me';
  static String psychologistStatistics(int psychologistId) =>
      '$baseUrl/statistics/psychologists/$psychologistId';

  // ========================================
  // Report Endpoints
  // ========================================
  static String get reports => '$baseUrl/reports';
  static String get myReports => '$baseUrl/reports/my';
  static String get incompleteReports => '$baseUrl/reports/incomplete';
  static String reportById(int id) => '$baseUrl/reports/$id';
  static String clientReports(int clientId) =>
      '$baseUrl/reports/client/$clientId';
  static String reportByAppointment(int appointmentId) =>
      '$baseUrl/reports/appointment/$appointmentId';

  // ========================================
  // Survey Endpoints
  // ========================================
  static String survey(String code) => '$baseUrl/surveys/$code';
  static String submitSurvey(String code) => '$baseUrl/surveys/$code/responses';
  static String surveyAnalytics(String code) =>
      '$baseUrl/surveys/$code/analytics';
  static String questionAnalytics(String code, int questionId) =>
      '$baseUrl/surveys/$code/analytics/question/$questionId';
  static String exportSurvey(String code) => '$baseUrl/surveys/$code/export';
  static String get mySurveys => '$baseUrl/surveys/my/sessions';

  // ========================================
  // HTTP Headers
  // ========================================
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> headersWithAuth(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> multipartHeadersWithAuth(String token) => {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
  };

  // ========================================
  // Timeout Settings
  // ========================================
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ========================================
  // Debug Helper
  // ========================================
  static void printDebugInfo() {
    print('🔧 API Configuration:');
    print('   Base URL: $baseUrl');
    print('   Mode: ${isDevelopment ? "Development" : "Production"}');
    print('   Login: $login');
    print('   Profile: $me');
  }
}
