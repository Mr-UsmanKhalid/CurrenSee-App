import '../core/constants/api_constants.dart';
import '../models/rate_alert_model.dart';
import 'api_client.dart';

class AlertService {
  /// [userId] kept for signature compatibility; the backend scopes to the
  /// JWT's user regardless of what's passed here.
  Future<List<RateAlertModel>> getAlerts(int userId) async {
    final data = await ApiClient.get(ApiConstants.alertsUrl) as List;
    return data.map((e) => RateAlertModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<RateAlertModel> createAlert(RateAlertModel alert) async {
    final data = await ApiClient.post(ApiConstants.alertsUrl, {
      'baseCurrency': alert.baseCurrency,
      'targetCurrency': alert.targetCurrency,
      'threshold': alert.threshold,
      'condition': alert.condition.name,
    });
    return RateAlertModel.fromMap(data as Map<String, dynamic>);
  }

  /// AlertProvider only needs this to persist isActive/isTriggered changes
  /// (it already updates its own in-memory list), so this returns void.
  Future<void> updateAlert(RateAlertModel alert) async {
    if (alert.id == null) return;
    await ApiClient.put(ApiConstants.alertUrl(alert.id!), {
      'isActive': alert.isActive,
      'isTriggered': alert.isTriggered,
    });
  }

  Future<void> deleteAlert(int id) async {
    await ApiClient.delete(ApiConstants.alertUrl(id));
  }
}
