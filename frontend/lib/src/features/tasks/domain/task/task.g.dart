// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      date: DateTime.parse(json['date'] as String),
      is_completed: json['is_completed'] as bool,
      member_id: json['member_id'] as String?,
      estimated_duration: json['estimated_duration'] as int?,
      duration: json['duration'] as int?,
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'icon': instance.icon,
      'date': instance.date.toIso8601String(),
      'is_completed': instance.is_completed,
      'member_id': instance.member_id,
      'estimated_duration': instance.estimated_duration,
      'duration': instance.duration,
    };
