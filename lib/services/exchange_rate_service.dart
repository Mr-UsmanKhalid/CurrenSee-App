import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../core/constants/api_constants.dart';
import '../models/exchange_rate_model.dart';

class ExchangeRateService {
  Future<Map<String, double>> fetchLatestRates(String base) async {
    final response = await http
        .get(Uri.parse(ApiConstants.latestRates(base)))
        .timeout(const Duration(seconds: ApiConstants.requestTimeoutSeconds));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch exchange rates (${response.statusCode}).');
    }
    // v2: list of {date, base, quote, rate}
    final List<dynamic> rows = json.decode(response.body);
    return {
      for (final r in rows)
        if (r['quote'] != base) r['quote'] as String: (r['rate'] as num).toDouble(),
    };
  }

  Future<ExchangeRateModel> fetchPairRate(String base, String target) async {
    final response = await http
        .get(Uri.parse(ApiConstants.pairRate(base, target)))
        .timeout(const Duration(seconds: ApiConstants.requestTimeoutSeconds));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch exchange rate (${response.statusCode}).');
    }
    // v2: single object {date, base, quote, rate}
    final Map<String, dynamic> d = json.decode(response.body);
    // Reshape to the old v1 layout so ExchangeRateModel.fromJson still works.
    final legacy = {
      'amount': 1.0,
      'base': d['base'],
      'date': d['date'],
      'rates': {target: d['rate']},
    };
    return ExchangeRateModel.fromJson(base, target, legacy);
  }

  Future<List<HistoricalRatePoint>> fetchHistory(
    String base,
    String target, {
    int days = 30,
  }) async {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));
    final fmt = DateFormat('yyyy-MM-dd');
    final response = await http
        .get(Uri.parse(ApiConstants.historicalRates(
            base, target, fmt.format(start), fmt.format(end))))
        .timeout(const Duration(seconds: ApiConstants.requestTimeoutSeconds));
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch historical rates (${response.statusCode}).');
    }
    // v2: list of {date, base, quote, rate}
    final List<dynamic> rows = json.decode(response.body);
    final points = rows
        .map((r) => HistoricalRatePoint(
              date: DateTime.parse(r['date'] as String),
              rate: (r['rate'] as num).toDouble(),
            ))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return points;
  }
}