class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.frankfurter.dev/v2';

  // All rates from a base (list of {date, base, quote, rate})
  static String latestRates(String base) => '$baseUrl/rates?base=$base';

  // Single pair (returns one object: {date, base, quote, rate})
  static String pairRate(String base, String target) =>
      '$baseUrl/rate/$base/$target';

  // Time series for a pair
  static String historicalRates(
          String base, String target, String start, String end) =>
      '$baseUrl/rates?base=$base&quotes=$target&from=$start&to=$end';

  // Active currencies. Add '?scope=all' only if you want legacy ones too
  // (legacy currencies have no current rates).
  static const String currencyListUrl = '$baseUrl/currencies';

  static const int requestTimeoutSeconds = 12;

  // ---------------------------------------------------------------------
  // Your own Node.js + MySQL backend
  // ---------------------------------------------------------------------
  // Android emulator -> 10.0.2.2 (maps to your computer's localhost)
  // iOS simulator     -> localhost works as-is
  // Physical device   -> use your computer's LAN IP, e.g. 192.168.1.50
// Set at build time with --dart-define=BACKEND_URL=...
// Must include /api at the end.
static const String backendBaseUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://localhost:3000/api',
);

  static String get registerUrl => '$backendBaseUrl/auth/register';
  static String get loginUrl => '$backendBaseUrl/auth/login';
  static String get forgotPasswordUrl => '$backendBaseUrl/auth/forgot-password';

  static String get profileUrl => '$backendBaseUrl/users/me';
  static String get preferencesUrl => '$backendBaseUrl/users/me/preferences';

  static String get conversionsUrl => '$backendBaseUrl/conversions';
  static String conversionUrl(int id) => '$backendBaseUrl/conversions/$id';

  static String get alertsUrl => '$backendBaseUrl/alerts';
  static String alertUrl(int id) => '$backendBaseUrl/alerts/$id';

  static String get notificationsUrl => '$backendBaseUrl/notifications';
  static String notificationReadUrl(int id) => '$backendBaseUrl/notifications/$id/read';
  static String get notificationsReadAllUrl => '$backendBaseUrl/notifications/read-all';
  static String notificationUrl(int id) => '$backendBaseUrl/notifications/$id';

  static String get feedbackUrl => '$backendBaseUrl/feedback';
  static String get supportUrl => '$backendBaseUrl/support';
}