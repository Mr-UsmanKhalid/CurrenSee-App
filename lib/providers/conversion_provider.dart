import 'package:flutter/foundation.dart';
import '../models/conversion_model.dart';
import '../services/conversion_service.dart';

class ConversionProvider extends ChangeNotifier {
  final ConversionService _service = ConversionService();

  List<ConversionModel> _history = [];
  bool _isLoading = false;

  List<ConversionModel> get history => _history;
  bool get isLoading => _isLoading;

  Future<void> loadHistory(int userId) async {
    _isLoading = true;
    notifyListeners();
    _history = await _service.getHistory(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<ConversionModel> recordConversion({
    required int userId,
    required String fromCurrency,
    required String toCurrency,
    required double amount,
    required double convertedAmount,
    required double rate,
  }) async {
    final conversion = ConversionModel(
      userId: userId,
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      amount: amount,
      convertedAmount: convertedAmount,
      rate: rate,
    );
    final saved = await _service.saveConversion(conversion);
    _history.insert(0, saved);
    notifyListeners();
    return saved;
  }

  Future<void> deleteConversion(int id) async {
    await _service.deleteConversion(id);
    _history.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<void> clearHistory(int userId) async {
    await _service.clearHistory(userId);
    _history.clear();
    notifyListeners();
  }
}
