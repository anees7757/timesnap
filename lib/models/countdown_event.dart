import 'dart:convert';

class CountdownEvent {
  final String id;
  final String title;
  final DateTime targetDate;
  final DateTime createdAt;
  final int colorValue;
  final String emoji;
  final bool isPinned;

  CountdownEvent({
    required this.id,
    required this.title,
    required this.targetDate,
    DateTime? createdAt,
    this.colorValue = 0xFF6366F1,
    this.emoji = '⏳',
    this.isPinned = false,
  }) : createdAt = createdAt ?? DateTime.now();

  CountdownEvent copyWith({
    String? id,
    String? title,
    DateTime? targetDate,
    DateTime? createdAt,
    int? colorValue,
    String? emoji,
    bool? isPinned,
  }) {
    return CountdownEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDate: targetDate ?? this.targetDate,
      createdAt: createdAt ?? this.createdAt,
      colorValue: colorValue ?? this.colorValue,
      emoji: emoji ?? this.emoji,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetDate': targetDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'colorValue': colorValue,
      'emoji': emoji,
      'isPinned': isPinned,
    };
  }

  factory CountdownEvent.fromMap(Map<String, dynamic> map) {
    return CountdownEvent(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      targetDate: DateTime.parse(map['targetDate']),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      colorValue: map['colorValue'] ?? 0xFF6366F1,
      emoji: map['emoji'] ?? '⏳',
      isPinned: map['isPinned'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountdownEvent.fromJson(String source) =>
      CountdownEvent.fromMap(json.decode(source));

  Duration get timeLeft => targetDate.difference(DateTime.now());
  bool get hasPassed => timeLeft.isNegative;

  /// Returns the elapsed fraction from creation to target (0.0 → 1.0).
  double get progressFraction {
    final totalDuration = targetDate.difference(createdAt);
    if (totalDuration.inSeconds <= 0) return 1.0;
    final elapsed = DateTime.now().difference(createdAt);
    return (elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
  }
}
