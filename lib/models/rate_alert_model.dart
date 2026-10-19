enum AlertCondition { above, below }

class RateAlertModel {
  final int? id;
  final int userId;
  final String baseCurrency;
  final String targetCurrency;
  final double threshold;
  final AlertCondition condition;
  final bool isActive;
  final bool isTriggered;
  final DateTime createdAt;

  RateAlertModel({
    this.id,
    required this.userId,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.threshold,
    required this.condition,
    this.isActive = true,
    this.isTriggered = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'base_currency': baseCurrency,
      'target_currency': targetCurrency,
      'threshold': threshold,
      'condition': condition.name,
      'is_active': isActive ? 1 : 0,
      'is_triggered': isTriggered ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory RateAlertModel.fromMap(Map<String, dynamic> map) {
    return RateAlertModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      baseCurrency: map['base_currency'] as String,
      targetCurrency: map['target_currency'] as String,
      threshold: (map['threshold'] as num).toDouble(),
      condition: (map['condition'] as String) == 'above' ? AlertCondition.above : AlertCondition.below,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      isTriggered: (map['is_triggered'] as int? ?? 0) == 1,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  RateAlertModel copyWith({bool? isActive, bool? isTriggered}) {
    return RateAlertModel(
      id: id,
      userId: userId,
      baseCurrency: baseCurrency,
      targetCurrency: targetCurrency,
      threshold: threshold,
      condition: condition,
      isActive: isActive ?? this.isActive,
      isTriggered: isTriggered ?? this.isTriggered,
      createdAt: createdAt,
    );
  }
}
