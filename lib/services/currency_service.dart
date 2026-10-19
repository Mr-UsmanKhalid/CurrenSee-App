import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_constants.dart';
import '../core/utils/currency_utils.dart';
import '../models/currency_model.dart';
import 'package:flutter/foundation.dart';

class CurrencyService {
Future<List<CurrencyModel>> fetchCurrencies() async {
  try {
    final response = await http
        .get(Uri.parse(ApiConstants.currencyListUrl))
        .timeout(const Duration(seconds: ApiConstants.requestTimeoutSeconds));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final list = data.map((e) {
        final code = e['iso_code'] as String;
        final apiSymbol = e['symbol'] as String?;
        return CurrencyModel(
          code: code,
          name: e['name'] as String,
          symbol: (apiSymbol != null && apiSymbol.isNotEmpty)
              ? apiSymbol
              : CurrencyUtils.symbolFor(code),
        );
      }).toList()
        ..sort((a, b) => a.code.compareTo(b.code));
      return list;
    }
  } catch (e) {
    debugPrint('fetchCurrencies failed: $e'); // import 'package:flutter/foundation.dart'
  }
  return _fallbackCurrencies();
}

  List<CurrencyModel> _fallbackCurrencies() {
    return CurrencyUtils.names.entries
        .map((e) => CurrencyModel(code: e.key, name: e.value, symbol: CurrencyUtils.symbolFor(e.key)))
        .toList()
      ..sort((a, b) => a.code.compareTo(b.code));
  }
}
