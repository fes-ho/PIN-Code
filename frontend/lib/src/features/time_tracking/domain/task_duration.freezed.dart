// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_duration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskDuration _$TaskDurationFromJson(Map<String, dynamic> json) {
  return _TaskDuration.fromJson(json);
}

/// @nodoc
mixin _$TaskDuration {
  int get duration => throw _privateConstructorUsedError;
  int? get estimated_duration => throw _privateConstructorUsedError;

  /// Serializes this TaskDuration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskDuration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskDurationCopyWith<TaskDuration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskDurationCopyWith<$Res> {
  factory $TaskDurationCopyWith(
          TaskDuration value, $Res Function(TaskDuration) then) =
      _$TaskDurationCopyWithImpl<$Res, TaskDuration>;
  @useResult
  $Res call({int duration, int? estimated_duration});
}

/// @nodoc
class _$TaskDurationCopyWithImpl<$Res, $Val extends TaskDuration>
    implements $TaskDurationCopyWith<$Res> {
  _$TaskDurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskDuration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? estimated_duration = freezed,
  }) {
    return _then(_value.copyWith(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      estimated_duration: freezed == estimated_duration
          ? _value.estimated_duration
          : estimated_duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskDurationImplCopyWith<$Res>
    implements $TaskDurationCopyWith<$Res> {
  factory _$$TaskDurationImplCopyWith(
          _$TaskDurationImpl value, $Res Function(_$TaskDurationImpl) then) =
      __$$TaskDurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int duration, int? estimated_duration});
}

/// @nodoc
class __$$TaskDurationImplCopyWithImpl<$Res>
    extends _$TaskDurationCopyWithImpl<$Res, _$TaskDurationImpl>
    implements _$$TaskDurationImplCopyWith<$Res> {
  __$$TaskDurationImplCopyWithImpl(
      _$TaskDurationImpl _value, $Res Function(_$TaskDurationImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskDuration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? estimated_duration = freezed,
  }) {
    return _then(_$TaskDurationImpl(
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      estimated_duration: freezed == estimated_duration
          ? _value.estimated_duration
          : estimated_duration // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskDurationImpl implements _TaskDuration {
  const _$TaskDurationImpl(
      {required this.duration, required this.estimated_duration});

  factory _$TaskDurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskDurationImplFromJson(json);

  @override
  final int duration;
  @override
  final int? estimated_duration;

  @override
  String toString() {
    return 'TaskDuration(duration: $duration, estimated_duration: $estimated_duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskDurationImpl &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.estimated_duration, estimated_duration) ||
                other.estimated_duration == estimated_duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, duration, estimated_duration);

  /// Create a copy of TaskDuration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskDurationImplCopyWith<_$TaskDurationImpl> get copyWith =>
      __$$TaskDurationImplCopyWithImpl<_$TaskDurationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskDurationImplToJson(
      this,
    );
  }
}

abstract class _TaskDuration implements TaskDuration {
  const factory _TaskDuration(
      {required final int duration,
      required final int? estimated_duration}) = _$TaskDurationImpl;

  factory _TaskDuration.fromJson(Map<String, dynamic> json) =
      _$TaskDurationImpl.fromJson;

  @override
  int get duration;
  @override
  int? get estimated_duration;

  /// Create a copy of TaskDuration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskDurationImplCopyWith<_$TaskDurationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
