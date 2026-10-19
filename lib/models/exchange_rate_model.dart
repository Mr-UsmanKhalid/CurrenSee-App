class ExchangeRateModel {
  final String base;
  final String target;
  final double rate;
  final DateTime date;

  ExchangeRateModel({
    required this.base,
    required this.target,
    required this.rate,
    required this.date,
  });

  factory ExchangeRateModel.fromJson(String base, String target, Map<String, dynamic> json) {
    final rates = json['rates'] as Map<String, dynamic>? ?? {};
    return ExchangeRateModel(
      base: base,
      target: target,
      rate: (rates[target] as num?)?.toDouble() ?? 0,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class HistoricalRatePoint {
  final DateTime date;
  final double rate;

  HistoricalRatePoint({required this.date, required this.rate});
}
