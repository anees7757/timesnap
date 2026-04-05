import 'dart:convert';

class CountdownEvent {
  final String id;
  final String title;
  final DateTime targetDate;
  final int colorValue;
  final bool isPinned;

  CountdownEvent({
    required this.id,
    required this.title,
    required this.targetDate,
    this.colorValue = 0xFF6366F1,
    this.isPinned = false,
  });

  CountdownEvent copyWith({
    String? id,
    String? title,
    DateTime? targetDate,
    int? colorValue,
    bool? isPinned,
  }) {
    return CountdownEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      targetDate: targetDate ?? this.targetDate,
      colorValue: colorValue ?? this.colorValue,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetDate': targetDate.toIso8601String(),
      'colorValue': colorValue,
      'isPinned': isPinned,
    };
  }

  factory CountdownEvent.fromMap(Map<String, dynamic> map) {
    return CountdownEvent(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      targetDate: DateTime.parse(map['targetDate']),
      colorValue: map['colorValue'] ?? 0xFF6366F1,
      isPinned: map['isPinned'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountdownEvent.fromJson(String source) => CountdownEvent.fromMap(json.decode(source));

  Duration get timeLeft => targetDate.difference(DateTime.now());
  bool get hasPassed => timeLeft.isNegative;
}
