import '../core/constants/api_constants.dart';
import 'api_client.dart';

class PreferenceService {
  /// Returns null if the user has no preferences row yet (shouldn't normally
  /// happen — the backend creates one at registration — but handled safely).
  Future<Map<String, dynamic>?> getPreferences() async {
    final data = await ApiClient.get(ApiConstants.preferencesUrl);
    return data as Map<String, dynamic>?;
  }

  Future<void> updatePreferences({
    required String defaultBaseCurrency,
    required bool notificationsEnabled,
    required String themeMode,
  }) async {
    await ApiClient.put(ApiConstants.preferencesUrl, {
      'defaultBaseCurrency': defaultBaseCurrency,
      'notificationsEnabled': notificationsEnabled,
      'themeMode': themeMode,
    });
  }
}
