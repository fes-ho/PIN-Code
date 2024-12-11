import 'package:frontend/src/features/habits/domain/day_time.dart';

class Habit {
  final String? id;
  final String name;
  final String description;
  final String icon;
  DayTime dayTime;
  bool isCompleted;
  String? memberId;
  int? duration;
  int? estimatedDuration;

  Habit({
    this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.dayTime,
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
        dayTime = dayTimefromJson(json['dayTime']),
        isCompleted = json['is_completed'],
        duration = json['duration'],
        estimatedDuration = json['estimated_duration'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'dayTime': dayTime.name,
      'member_id': memberId,
      'is_completed': isCompleted,
      'duration': duration,
      'estimated_duration': estimatedDuration,
    };
  }
}