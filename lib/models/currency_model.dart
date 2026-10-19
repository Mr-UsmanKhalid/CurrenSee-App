class CurrencyModel {
  final String code;
  final String name;
  final String symbol;

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
  });

  factory CurrencyModel.fromCodeAndName(String code, String name, String symbol) {
    return CurrencyModel(code: code, name: name, symbol: symbol);
  }

  Map<String, dynamic> toMap() => {'code': code, 'name': name, 'symbol': symbol};

  factory CurrencyModel.fromMap(Map<String, dynamic> map) => CurrencyModel(
        code: map['code'] as String,
        name: map['name'] as String,
        symbol: map['symbol'] as String,
      );
}
