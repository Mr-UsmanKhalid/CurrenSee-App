import '../core/constants/api_constants.dart';
import '../models/notification_model.dart';
import 'api_client.dart';

class NotificationService {
  /// [userId] kept for signature compatibility; the backend scopes to the
  /// JWT's user regardless of what's passed here.
  Future<List<NotificationModel>> getForUser(int userId) async {
    final data = await ApiClient.get(ApiConstants.notificationsUrl) as List;
    return data.map((e) => NotificationModel.fromMap(e as Map<String, dynamic>)).toList();
  }

  Future<NotificationModel> create(NotificationModel notification) async {
    final data = await ApiClient.post(ApiConstants.notificationsUrl, {
      'title': notification.title,
      'message': notification.message,
      'type': notification.type,
    });
    return NotificationModel.fromMap(data as Map<String, dynamic>);
  }

  Future<void> markRead(int id) async {
    await ApiClient.put(ApiConstants.notificationReadUrl(id), {});
  }

  Future<void> markAllRead(int userId) async {
    await ApiClient.put(ApiConstants.notificationsReadAllUrl, {});
  }

  Future<void> delete(int id) async {
    await ApiClient.delete(ApiConstants.notificationUrl(id));
  }
}
