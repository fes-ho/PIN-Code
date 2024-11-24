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
    String? memberId,
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json) => 
  _$TaskFromJson(json);
}