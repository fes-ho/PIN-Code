// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_duration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskDurationImpl _$$TaskDurationImplFromJson(Map<String, dynamic> json) =>
    _$TaskDurationImpl(
      duration: (json['duration'] as num).toInt(),
      estimated_duration: (json['estimated_duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TaskDurationImplToJson(_$TaskDurationImpl instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'estimated_duration': instance.estimated_duration,
    };
