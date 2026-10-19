import 'package:flutter/foundation.dart';
import '../models/currency_model.dart';
import '../services/currency_service.dart';

class CurrencyProvider extends ChangeNotifier {
  final CurrencyService _service = CurrencyService();

  List<CurrencyModel> _currencies = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<CurrencyModel> get currencies => _currencies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<CurrencyModel> get filteredCurrencies {
    if (_searchQuery.isEmpty) return _currencies;
    final q = _searchQuery.toLowerCase();
    return _currencies
        .where((c) => c.code.toLowerCase().contains(q) || c.name.toLowerCase().contains(q))
        .toList();
  }

  Future<void> loadCurrencies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final fetched = await _service.fetchCurrencies();
      _currencies = fetched.where((c) => c.code != 'ILS').toList();
    } catch (e) {
      _error = 'Could not load currencies. Showing offline list.';
    }
    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  CurrencyModel? byCode(String code) {
    try {
      return _currencies.firstWhere((c) => c.code == code);
    } catch (_) {
      return null;
    }
  }
}