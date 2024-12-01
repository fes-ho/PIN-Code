// ignore_for_file: non_constant_identifier_names

import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_duration.freezed.dart';

part 'task_duration.g.dart';

@freezed
class TaskDuration with _$TaskDuration{
  const factory TaskDuration({
    required int duration,
    required int? estimated_duration,
  }) = _TaskDuration;

  factory TaskDuration.fromJson(Map<String, Object?> json) => 
  _$TaskDurationFromJson(json);
}