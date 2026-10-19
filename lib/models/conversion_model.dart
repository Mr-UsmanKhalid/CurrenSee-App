class ConversionModel {
  final int? id;
  final int userId;
  final String fromCurrency;
  final String toCurrency;
  final double amount;
  final double convertedAmount;
  final double rate;
  final DateTime date;

  ConversionModel({
    this.id,
    required this.userId,
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
    required this.convertedAmount,
    required this.rate,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'amount': amount,
      'converted_amount': convertedAmount,
      'rate': rate,
      'date': date.toIso8601String(),
    };
  }

  factory ConversionModel.fromMap(Map<String, dynamic> map) {
    return ConversionModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      fromCurrency: map['from_currency'] as String,
      toCurrency: map['to_currency'] as String,
      amount: (map['amount'] as num).toDouble(),
      convertedAmount: (map['converted_amount'] as num).toDouble(),
      rate: (map['rate'] as num).toDouble(),
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
