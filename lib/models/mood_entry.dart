import 'package:flutter/material.dart';

/// 情绪等级枚举
enum MoodLevel {
  terrible(1, '糟糕', Icons.sentiment_very_dissatisfied),
  bad(2, '不好', Icons.sentiment_dissatisfied),
  neutral(3, '一般', Icons.sentiment_neutral),
  good(4, '不错', Icons.sentiment_satisfied),
  excellent(5, '很好', Icons.sentiment_very_satisfied);

  final int value;
  final String label;
  final IconData icon;

  const MoodLevel(this.value, this.label, this.icon);

  static MoodLevel fromValue(int value) {
    return MoodLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => MoodLevel.neutral,
    );
  }
}

/// 情绪日记条目模型
class MoodEntry {
  final int? id; // 数据库ID
  final DateTime date; // 记录日期时间
  final MoodLevel moodLevel; // 情绪等级
  final String description; // 描述
  final String? triggerEvent; // 触发事件
  final List<String> tags; // 标签列表
  final double energyLevel; // 能量水平 (0.0-1.0)

  MoodEntry({
    this.id,
    required this.date,
    required this.moodLevel,
    required this.description,
    this.triggerEvent,
    required this.tags,
    required this.energyLevel,
  });

  // 从Map创建实例 (用于数据库操作)
  factory MoodEntry.fromMap(Map<String, dynamic> map) {
    return MoodEntry(
      id: map['id'],
      date: DateTime.parse(map['date']),
      moodLevel: MoodLevel.fromValue(map['moodLevel']),
      description: map['description'],
      triggerEvent: map['triggerEvent'],
      tags: (map['tags'] as String).split(',').where((tag) => tag.isNotEmpty).toList(),
      energyLevel: map['energyLevel'],
    );
  }

  // 转换为Map (用于数据库操作)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'moodLevel': moodLevel.value,
      'description': description,
      'triggerEvent': triggerEvent,
      'tags': tags.join(','),
      'energyLevel': energyLevel,
    };
  }

  // 创建副本并更新部分属性
  MoodEntry copyWith({
    int? id,
    DateTime? date,
    MoodLevel? moodLevel,
    String? description,
    String? triggerEvent,
    List<String>? tags,
    double? energyLevel,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      date: date ?? this.date,
      moodLevel: moodLevel ?? this.moodLevel,
      description: description ?? this.description,
      triggerEvent: triggerEvent ?? this.triggerEvent,
      tags: tags ?? this.tags,
      energyLevel: energyLevel ?? this.energyLevel,
    );
  }
}