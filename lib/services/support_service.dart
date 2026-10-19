import '../core/constants/api_constants.dart';
import 'api_client.dart';

/// No SupportTicketModel was shared with me, so this returns the raw
/// decoded map (id, user_id, subject, message, status, created_at) — wrap
/// it in a model later if you add one, following the same pattern as
/// FeedbackModel.
class SupportService {
  Future<Map<String, dynamic>> submitTicket({
    required String subject,
    required String message,
  }) async {
    final data = await ApiClient.post(ApiConstants.supportUrl, {
      'subject': subject,
      'message': message,
    });
    return data as Map<String, dynamic>;
  }

  Future<List<dynamic>> getMyTickets() async {
    final data = await ApiClient.get(ApiConstants.supportUrl) as List;
    return data;
  }
}