class ApiConfig {
  // ========================================
  // ENVIRONMENT CONFIGURATION
  // ========================================
  // Set to false to use production backend
  // Set to true to use local backend
  static const bool useLocalBackend = true;

  // Base URL
  static String get baseUrl => useLocalBackend 
      ? 'http://localhost:8080/api'
      : 'https://api.balance-psy.kz/api';

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);

  // ========================================
  // AUTH ENDPOINTS
  // ========================================
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register/client';
  static String get registerPsychologist => '$baseUrl/auth/register/psychologist';
  static String get me => '$baseUrl/auth/me';
  static String get forgotPassword => '$baseUrl/auth/forgot-password';
  static String get resetPassword => '$baseUrl/auth/reset-password';

  // Email verification
  static String get sendCode => '$baseUrl/auth/send-code';
  static String get verifyCode => '$baseUrl/auth/verify-code';

  // ========================================
  // PROFILE ENDPOINTS
  // ========================================
  static String get profile => '$baseUrl/profile/me';
  static String get updateProfile => '$baseUrl/profile/me';
  static String get uploadAvatar => '$baseUrl/profile/me/avatar';
  static String get deleteAvatar => '$baseUrl/profile/me/avatar';
  static String get updateAvailability => '$baseUrl/profile/me/availability';

  // ========================================
  // USER ENDPOINTS
  // ========================================
  static String get users => '$baseUrl/users/me';
  static String get changePassword => '$baseUrl/users/me/password';
  static String get deleteAccount => '$baseUrl/users/me';
  static String get searchUsers => '$baseUrl/users/search';

  // ========================================
  // PSYCHOLOGISTS ENDPOINTS
  // ========================================
  static String get psychologists => '$baseUrl/psychologists';

  static String psychologistById(int id) => '$baseUrl/psychologists/$id';
  static String psychologistSchedule(int id) =>
      '$baseUrl/psychologists/$id/schedule';

  // ========================================
  // APPOINTMENTS ENDPOINTS
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
  static String noShowAppointment(int id) =>
      '$baseUrl/appointments/$id/no-show';

  // ========================================
  // ARTICLES ENDPOINTS
  // ========================================
  static String get articles => '$baseUrl/articles';

  static String articleBySlug(String slug) => '$baseUrl/articles/slug/$slug';
  static String articleById(int id) => '$baseUrl/articles/$id';

  // ========================================
  // REVIEWS ENDPOINTS
  // ========================================
  static String get reviews => '$baseUrl/reviews';
  static String get myReviews => '$baseUrl/reviews/my';

  static String psychologistReviews(int psychologistId) =>
      '$baseUrl/reviews/psychologist/$psychologistId';
  static String reviewById(int id) => '$baseUrl/reviews/$id';
  static String canReviewAppointment(int appointmentId) =>
      '$baseUrl/reviews/appointment/$appointmentId/can-review';

  // ========================================
  // DIAGNOSTICS ENDPOINTS
  // ========================================
  static String get diagnosticTests => '$baseUrl/diagnostics/tests';
  static String get submitDiagnostic => '$baseUrl/diagnostics/sessions/submit';

  static String diagnosticTest(String testCode) =>
      '$baseUrl/diagnostics/tests/$testCode';
  static String diagnosticSession(int sessionId) =>
      '$baseUrl/diagnostics/sessions/$sessionId';
  static String get myDiagnosticSessions => '$baseUrl/diagnostics/sessions/my';

  // ========================================
  // SURVEYS ENDPOINTS
  // ========================================
  static String get surveys => '$baseUrl/surveys';
  static String get mySurveySessions => '$baseUrl/surveys/my/sessions';

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
  static String get introContent => '$baseUrl/intro/content';
  static String get completeIntro => '$baseUrl/intro/complete';
  static String get introStatus => '$baseUrl/intro/status';

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