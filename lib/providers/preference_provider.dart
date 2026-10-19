import 'package:flutter/material.dart';
import '../services/preference_service.dart';

class PreferenceProvider extends ChangeNotifier {
  final _service = PreferenceService();

  String defaultBaseCurrency = 'USD';
  bool notificationsEnabled = true;
  ThemeMode themeMode = ThemeMode.light;

  /// [userId] kept for signature compatibility with existing call sites; the
  /// backend scopes to the JWT's user regardless of what's passed here.
  Future<void> load(int userId) async {
    try {
      final prefs = await _service.getPreferences();
      if (prefs != null) {
        defaultBaseCurrency = prefs['default_base_currency'] as String? ?? 'USD';
        notificationsEnabled = (prefs['notifications_enabled'] as int? ?? 1) == 1;
        themeMode = (prefs['theme_mode'] as String? ?? 'light') == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light;
      }
    } catch (_) {
      // Keep the defaults above if the fetch fails (e.g. offline at launch).
    }
    notifyListeners();
  }

  Future<void> updateDefaultCurrency(int userId, String currency) async {
    defaultBaseCurrency = currency;
    notifyListeners();
    await _service.updatePreferences(
      defaultBaseCurrency: currency,
      notificationsEnabled: notificationsEnabled,
      themeMode: themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> updateNotificationsEnabled(int userId, bool enabled) async {
    notificationsEnabled = enabled;
    notifyListeners();
    await _service.updatePreferences(
      defaultBaseCurrency: defaultBaseCurrency,
      notificationsEnabled: enabled,
      themeMode: themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> updateThemeMode(int userId, ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    await _service.updatePreferences(
      defaultBaseCurrency: defaultBaseCurrency,
      notificationsEnabled: notificationsEnabled,
      themeMode: mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
