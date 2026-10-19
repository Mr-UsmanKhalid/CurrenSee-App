class FeedbackModel {
  final int? id;
  final int userId;
  final String subject;
  final String message;
  final int? rating;
  final DateTime createdAt;

  FeedbackModel({
    this.id,
    required this.userId,
    required this.subject,
    required this.message,
    this.rating,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'subject': subject,
      'message': message,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      subject: map['subject'] as String,
      message: map['message'] as String,
      rating: map['rating'] as int?,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
