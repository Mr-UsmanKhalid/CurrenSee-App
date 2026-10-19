import '../core/constants/api_constants.dart';
import '../models/feedback_model.dart';
import 'api_client.dart';

class FeedbackService {
  Future<FeedbackModel> submit(FeedbackModel feedback) async {
    final data = await ApiClient.post(ApiConstants.feedbackUrl, {
      'subject': feedback.subject,
      'message': feedback.message,
      'rating': feedback.rating,
    });
    return FeedbackModel.fromMap(data as Map<String, dynamic>);
  }

  Future<List<FeedbackModel>> getMine() async {
    final data = await ApiClient.get(ApiConstants.feedbackUrl) as List;
    return data.map((e) => FeedbackModel.fromMap(e as Map<String, dynamic>)).toList();
  }
}