// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

part 'task.g.dart';

@freezed
class Task with _$Task{
  const factory Task({
    required String id,
    required String name,
    required String description,
    required String icon,
    required DateTime date,
    required bool is_completed,
    String? member_id,
    int? estimated_duration,
    int? duration,
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json) => 
  _$TaskFromJson(json);
}