import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/currency_provider.dart';
import 'providers/exchange_rate_provider.dart';
import 'providers/conversion_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/news_provider.dart';
import 'providers/user_provider.dart';
import 'providers/preference_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CurrenSeeRoot());
}

class CurrenSeeRoot extends StatelessWidget {
  const CurrenSeeRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CurrencyProvider()),
        ChangeNotifierProvider(create: (_) => ExchangeRateProvider()),
        ChangeNotifierProvider(create: (_) => ConversionProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PreferenceProvider()),
      ],
      child: const CurrenSeeApp(),
    );
  }
}
