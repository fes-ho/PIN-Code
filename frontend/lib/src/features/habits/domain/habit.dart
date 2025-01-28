import 'package:frontend/src/features/habits/domain/day_time.dart';
import 'package:frontend/src/features/habits/domain/frequency.dart';
import 'package:frontend/src/features/habits/domain/category.dart';

class Habit {
  final String? id;
  final String name;
  final String description;
  final String icon;
  final DateTime date;

  DayTime dayTime;
  Frequency frequency;
  Category category;
  bool isCompleted;
  String? memberId;
  int? duration;
  int? estimatedDuration;

  Habit({
    this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.date,
    required this.dayTime,
    required this.frequency,
    required this.category,
    required this.isCompleted,
    this.memberId,
    this.duration,
    this.estimatedDuration,
  });

  Habit.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        icon = json['icon'],
        date = DateTime.parse(json['date']),
        dayTime = dayTimefromJson(json['dayTime']),
        frequency = frequencyfromJson(json['frequency']),
        category = categoryfromJson(json['category']),
        isCompleted = json['is_completed'],
        duration = json['duration'],
        estimatedDuration = json['estimated_duration'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'date': date.toIso8601String(),
      'dayTime': dayTime.name,
      'frequency': frequency.name,
      'category': category.name,
      'is_completed': isCompleted,
      'member_id': memberId,     
      'duration': duration,
      'estimated_duration': estimatedDuration,
    };
  }
}