import 'package:intl/intl.dart';

class CurrencyUtils {
  CurrencyUtils._();

 static const Map<String, String> symbols = {
  'USD': '\$', 'EUR': '€', 'GBP': '£', 'JPY': '¥', 'INR': '₹',
  'AUD': 'A\$', 'CAD': 'C\$', 'CHF': 'CHF', 'CNY': '¥', 'PKR': '₨',
  'AED': 'د.إ', 'SGD': 'S\$', 'NZD': 'NZ\$', 'ZAR': 'R', 'SEK': 'kr',
  'NOK': 'kr', 'DKK': 'kr', 'HKD': 'HK\$', 'KRW': '₩', 'MXN': '\$',
  'BRL': 'R\$', 'TRY': '₺', 'THB': '฿', 'IDR': 'Rp', 'MYR': 'RM',
  'PLN': 'zł', 'RUB': '₽', 'SAR': '﷼', 'PHP': '₱',
  'CZK': 'Kč', 'HUF': 'Ft', 'ISK': 'kr', 'RON': 'lei',
};

  static const Map<String, String> names = {
    'USD': 'US Dollar', 'EUR': 'Euro', 'GBP': 'British Pound',
    'JPY': 'Japanese Yen', 'INR': 'Indian Rupee', 'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar', 'CHF': 'Swiss Franc', 'CNY': 'Chinese Yuan',
    'PKR': 'Pakistani Rupee', 'AED': 'UAE Dirham', 'SGD': 'Singapore Dollar',
    'NZD': 'New Zealand Dollar', 'ZAR': 'South African Rand', 'SEK': 'Swedish Krona',
    'NOK': 'Norwegian Krone', 'DKK': 'Danish Krone', 'HKD': 'Hong Kong Dollar',
    'KRW': 'South Korean Won', 'MXN': 'Mexican Peso', 'BRL': 'Brazilian Real',
    'TRY': 'Turkish Lira', 'THB': 'Thai Baht', 'IDR': 'Indonesian Rupiah',
    'MYR': 'Malaysian Ringgit', 'PLN': 'Polish Zloty', 'RUB': 'Russian Ruble',
    'SAR': 'Saudi Riyal', 'PHP': 'Philippine Peso',
    'CZK': 'Czech Koruna', 'HUF': 'Hungarian Forint', 'ISK': 'Icelandic Krona',
    'RON': 'Romanian Leu',
  };

  static String symbolFor(String code) => symbols[code.toUpperCase()] ?? code.toUpperCase();

  static String nameFor(String code) => names[code.toUpperCase()] ?? code.toUpperCase();

  static String formatAmount(double amount, {int decimals = 2}) {
    final formatter = NumberFormat.currency(symbol: '', decimalDigits: decimals);
    return formatter.format(amount).trim();
  }

  static String formatWithSymbol(double amount, String code, {int decimals = 2}) {
    return '${symbolFor(code)}${formatAmount(amount, decimals: decimals)}';
  }

  static String formatDate(DateTime date) => DateFormat('MMM d, yyyy • h:mm a').format(date);

  static String formatDateShort(DateTime date) => DateFormat('MMM d, yyyy').format(date);
}