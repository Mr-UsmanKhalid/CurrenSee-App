import 'package:flutter/material.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/currencies/currency_list_screen.dart';
import '../../screens/rates/exchange_rate_screen.dart';
import '../../screens/rates/historical_rate_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String currencyList = '/currencies';
  static const String exchangeRates = '/rates';
  static const String historicalRate = '/rates/history';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashScreen(),
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        forgotPassword: (_) => const ForgotPasswordScreen(),
        dashboard: (_) => const DashboardScreen(),
        currencyList: (_) => const CurrencyListScreen(),
        exchangeRates: (_) => const ExchangeRateScreen(),
      };

  /// Routes that need arguments are handled via onGenerateRoute in app.dart.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == historicalRate) {
      final args = settings.arguments as Map<String, dynamic>? ?? {};
      return MaterialPageRoute(
        builder: (_) => HistoricalRateScreen(
          base: args['base'] as String? ?? 'USD',
          target: args['target'] as String? ?? 'EUR',
        ),
      );
    }
    return null;
  }
}
