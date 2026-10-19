import '../core/constants/api_constants.dart';
import '../models/conversion_model.dart';
import 'api_client.dart';

class ConversionService {
  /// [userId] is accepted for signature compatibility with the existing
  /// provider, but isn't sent anywhere: the backend scopes every request to
  /// whichever user the JWT belongs to, so it's always "the current user".
  Future<List<ConversionModel>> getHistory(int userId) async {
    final data = await ApiClient.get(ApiConstants.conversionsUrl) as List;
    return data.map((e) => ConversionModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<ConversionModel> saveConversion(ConversionModel conversion) async {
    final data = await ApiClient.post(ApiConstants.conversionsUrl, {
      'fromCurrency': conversion.fromCurrency,
      'toCurrency': conversion.toCurrency,
      'amount': conversion.amount,
      'convertedAmount': conversion.convertedAmount,
      'rate': conversion.rate,
    });
    return ConversionModel.fromMap(data as Map<String, dynamic>);
  }

  Future<void> deleteConversion(int id) async {
    await ApiClient.delete(ApiConstants.conversionUrl(id));
  }

  Future<void> clearHistory(int userId) async {
    await ApiClient.delete(ApiConstants.conversionsUrl);
  }
}
