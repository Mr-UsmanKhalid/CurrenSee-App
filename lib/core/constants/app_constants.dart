class AppConstants {
  AppConstants._();

  static const String appName = 'CurrenSee';
  static const String appTagline = 'See every currency, clearly.';

  // SharedPreferences keys
  static const String keySessionUserId = 'session_user_id'; // no longer needed once JWT is in, kept in case other code reads it
  static const String keyOnboardingSeen = 'onboarding_seen';
  static const String keyThemeMode = 'theme_mode';
  static const String keyAuthToken = 'auth_token'; // NEW: JWT from the backend

  // Default fallback currency
  static const String defaultBaseCurrency = 'USD';

  // Validation
  static const int minPasswordLength = 6;
}
