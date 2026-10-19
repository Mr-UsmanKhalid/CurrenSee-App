import 'package:flutter/foundation.dart';
import '../models/rate_alert_model.dart';
import '../services/alert_service.dart';

class AlertProvider extends ChangeNotifier {
  final AlertService _service = AlertService();

  List<RateAlertModel> _alerts = [];
  bool _isLoading = false;

  List<RateAlertModel> get alerts => _alerts;
  bool get isLoading => _isLoading;

  Future<void> loadAlerts(int userId) async {
    _isLoading = true;
    notifyListeners();
    _alerts = await _service.getAlerts(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createAlert(RateAlertModel alert) async {
    final saved = await _service.createAlert(alert);
    _alerts.insert(0, saved);
    notifyListeners();
  }

  Future<void> toggleActive(RateAlertModel alert) async {
    final updated = alert.copyWith(isActive: !alert.isActive);
    await _service.updateAlert(updated);
    final idx = _alerts.indexWhere((a) => a.id == alert.id);
    if (idx != -1) _alerts[idx] = updated;
    notifyListeners();
  }

  Future<void> deleteAlert(int id) async {
    await _service.deleteAlert(id);
    _alerts.removeWhere((a) => a.id == id);
    notifyListeners();
  }

  /// Checks live rates against active alerts and returns any that just
  /// crossed their threshold (caller is responsible for notifying/persisting).
  List<RateAlertModel> checkTriggers(Map<String, double> latestRates, String base) {
    final triggered = <RateAlertModel>[];
    for (final alert in _alerts) {
      if (!alert.isActive || alert.isTriggered || alert.baseCurrency != base) continue;
      final rate = latestRates[alert.targetCurrency];
      if (rate == null) continue;
      final crossed = alert.condition == AlertCondition.above ? rate >= alert.threshold : rate <= alert.threshold;
      if (crossed) triggered.add(alert);
    }
    return triggered;
  }

  Future<void> markTriggered(RateAlertModel alert) async {
    final updated = alert.copyWith(isTriggered: true);
    await _service.updateAlert(updated);
    final idx = _alerts.indexWhere((a) => a.id == alert.id);
    if (idx != -1) _alerts[idx] = updated;
    notifyListeners();
  }
}
