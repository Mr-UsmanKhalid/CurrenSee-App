class NotificationModel {
  final int? id;
  final int userId;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final String type; // alert | system | news

  NotificationModel({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    this.isRead = false,
    this.type = 'system',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'message': message,
      'is_read': isRead ? 1 : 0,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      message: map['message'] as String,
      isRead: (map['is_read'] as int? ?? 0) == 1,
      type: map['type'] as String? ?? 'system',
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      userId: userId,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      type: type,
      createdAt: createdAt,
    );
  }
}
