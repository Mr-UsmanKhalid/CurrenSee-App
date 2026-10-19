import 'package:flutter/foundation.dart';
import '../models/exchange_rate_model.dart';
import '../services/exchange_rate_service.dart';

class ExchangeRateProvider extends ChangeNotifier {
  final ExchangeRateService _service = ExchangeRateService();

  Map<String, double> _rates = {};
  String _base = 'USD';
  bool _isLoading = false;
  String? _error;
  DateTime? _lastUpdated;

  List<HistoricalRatePoint> _history = [];
  bool _historyLoading = false;

  Map<String, double> get rates => _rates;
  String get base => _base;
  bool get isLoading => _isLoading;
  String? get error => _error;
  DateTime? get lastUpdated => _lastUpdated;
  List<HistoricalRatePoint> get history => _history;
  bool get historyLoading => _historyLoading;

  Future<void> loadRates(String base) async {
    _isLoading = true;
    _error = null;
    _base = base;
    notifyListeners();
    try {
      _rates = await _service.fetchLatestRates(base);
      _lastUpdated = DateTime.now();
    } catch (e) {
      _error = 'Unable to fetch live rates. Check your connection and try again.';
    }
    _isLoading = false;
    notifyListeners();
  }

  double? rateFor(String target) => _rates[target];

  Future<double?> getPairRate(String base, String target) async {
    try {
      final result = await _service.fetchPairRate(base, target);
      return result.rate;
    } catch (_) {
      return _rates[target];
    }
  }

  Future<void> loadHistory(String base, String target, {int days = 30}) async {
    _historyLoading = true;
    notifyListeners();
    try {
      _history = await _service.fetchHistory(base, target, days: days);
    } catch (e) {
      _history = [];
    }
    _historyLoading = false;
    notifyListeners();
  }
}
