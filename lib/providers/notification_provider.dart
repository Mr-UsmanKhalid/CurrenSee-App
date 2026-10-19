import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications(int userId) async {
    _isLoading = true;
    notifyListeners();
    _notifications = await _service.getForUser(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNotification(NotificationModel notification) async {
    final saved = await _service.create(notification);
    _notifications.insert(0, saved);
    notifyListeners();
  }

  Future<void> markRead(int id) async {
    await _service.markRead(id);
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) _notifications[idx] = _notifications[idx].copyWith(isRead: true);
    notifyListeners();
  }

  Future<void> markAllRead(int userId) async {
    await _service.markAllRead(userId);
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    notifyListeners();
  }

  Future<void> delete(int id) async {
    await _service.delete(id);
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}
