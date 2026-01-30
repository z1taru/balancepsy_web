// lib/сore/config/api_config.dart

class ApiConfig {
  // Base URL
  static const String baseUrl = 'http://localhost:8080/api';

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);

  // ========================================
  // AUTH ENDPOINTS
  // ========================================
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register/client';
  static const String registerPsychologist =
      '$baseUrl/auth/register/psychologist';
  static const String me = '$baseUrl/auth/me';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String resetPassword = '$baseUrl/auth/reset-password';

  // Email verification
  static const String sendCode = '$baseUrl/auth/send-code';
  static const String verifyCode = '$baseUrl/auth/verify-code';

  // ========================================
  // PROFILE ENDPOINTS
  // ========================================
  static const String profile = '$baseUrl/profile/me';
  static const String updateProfile = '$baseUrl/profile/me';
  static const String uploadAvatar = '$baseUrl/profile/me/avatar';
  static const String deleteAvatar = '$baseUrl/profile/me/avatar';
  static const String updateAvailability = '$baseUrl/profile/me/availability';

  // ========================================
  // USER ENDPOINTS
  // ========================================
  static const String users = '$baseUrl/users/me';
  static const String changePassword = '$baseUrl/users/me/password';
  static const String deleteAccount = '$baseUrl/users/me';
  static const String searchUsers = '$baseUrl/users/search';

  // ========================================
  // PSYCHOLOGISTS ENDPOINTS
  // ========================================
  static const String psychologists = '$baseUrl/psychologists';

  static String psychologistById(int id) => '$baseUrl/psychologists/$id';
  static String psychologistSchedule(int id) =>
      '$baseUrl/psychologists/$id/schedule';

  // ========================================
  // APPOINTMENTS ENDPOINTS
  // ========================================
  static const String appointments = '$baseUrl/appointments';
  static const String myAppointments = '$baseUrl/appointments/me';
  static const String psychologistAppointments =
      '$baseUrl/appointments/psychologist/me';

  static String confirmAppointment(int id) =>
      '$baseUrl/appointments/$id/confirm';
  static String rejectAppointment(int id) => '$baseUrl/appointments/$id/reject';
  static String cancelAppointment(int id) => '$baseUrl/appointments/$id/cancel';
  static String startAppointment(int id) => '$baseUrl/appointments/$id/start';
  static String completeAppointment(int id) =>
      '$baseUrl/appointments/$id/complete';
  static String noShowAppointment(int id) =>
      '$baseUrl/appointments/$id/no-show';

  // ========================================
  // ARTICLES ENDPOINTS
  // ========================================
  static const String articles = '$baseUrl/articles';

  static String articleBySlug(String slug) => '$baseUrl/articles/slug/$slug';
  static String articleById(int id) => '$baseUrl/articles/$id';

  // ========================================
  // REVIEWS ENDPOINTS
  // ========================================
  static const String reviews = '$baseUrl/reviews';
  static const String myReviews = '$baseUrl/reviews/my';

  static String psychologistReviews(int psychologistId) =>
      '$baseUrl/reviews/psychologist/$psychologistId';
  static String reviewById(int id) => '$baseUrl/reviews/$id';
  static String canReviewAppointment(int appointmentId) =>
      '$baseUrl/reviews/appointment/$appointmentId/can-review';

  // ========================================
  // DIAGNOSTICS ENDPOINTS
  // ========================================
  static const String diagnosticTests = '$baseUrl/diagnostics/tests';
  static const String submitDiagnostic = '$baseUrl/diagnostics/sessions/submit';

  static String diagnosticTest(String testCode) =>
      '$baseUrl/diagnostics/tests/$testCode';
  static String diagnosticSession(int sessionId) =>
      '$baseUrl/diagnostics/sessions/$sessionId';
  static String myDiagnosticSessions = '$baseUrl/diagnostics/sessions/my';

  // ========================================
  // SURVEYS ENDPOINTS
  // ========================================
  static const String surveys = '$baseUrl/surveys';
  static const String mySurveySessions = '$baseUrl/surveys/my/sessions';

  static String surveyById(int id) => '$baseUrl/surveys/$id';
  static String submitSurveyResponse(int surveyId) =>
      '$baseUrl/surveys/$surveyId/responses';
  static String surveyAnalytics(int surveyId) =>
      '$baseUrl/surveys/$surveyId/analytics';
  static String surveyQuestionAnalytics(int surveyId, int questionId) =>
      '$baseUrl/surveys/$surveyId/analytics/question/$questionId';
  static String exportSurvey(int surveyId) =>
      '$baseUrl/surveys/$surveyId/export';

  // ========================================
  // INTRO ENDPOINTS
  // ========================================
  static const String introContent = '$baseUrl/intro/content';
  static const String completeIntro = '$baseUrl/intro/complete';
  static const String introStatus = '$baseUrl/intro/status';

  // ========================================
  // HEADERS
  // ========================================
  static Map<String, String> get headers => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };

  static Map<String, String> headersWithAuth(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
