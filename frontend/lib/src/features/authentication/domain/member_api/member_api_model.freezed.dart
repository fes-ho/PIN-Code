// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'member_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MemberApiModel _$MemberApiModelFromJson(Map<String, dynamic> json) {
  return _MemberApiModel.fromJson(json);
}

/// @nodoc
mixin _$MemberApiModel {
  /// The member's ID.
  String get id => throw _privateConstructorUsedError;

  /// The member's username.
  String get username => throw _privateConstructorUsedError;

  /// Serializes this MemberApiModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemberApiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemberApiModelCopyWith<MemberApiModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemberApiModelCopyWith<$Res> {
  factory $MemberApiModelCopyWith(
          MemberApiModel value, $Res Function(MemberApiModel) then) =
      _$MemberApiModelCopyWithImpl<$Res, MemberApiModel>;
  @useResult
  $Res call({String id, String username});
}

/// @nodoc
class _$MemberApiModelCopyWithImpl<$Res, $Val extends MemberApiModel>
    implements $MemberApiModelCopyWith<$Res> {
  _$MemberApiModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemberApiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemberApiModelImplCopyWith<$Res>
    implements $MemberApiModelCopyWith<$Res> {
  factory _$$MemberApiModelImplCopyWith(_$MemberApiModelImpl value,
          $Res Function(_$MemberApiModelImpl) then) =
      __$$MemberApiModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String username});
}

/// @nodoc
class __$$MemberApiModelImplCopyWithImpl<$Res>
    extends _$MemberApiModelCopyWithImpl<$Res, _$MemberApiModelImpl>
    implements _$$MemberApiModelImplCopyWith<$Res> {
  __$$MemberApiModelImplCopyWithImpl(
      _$MemberApiModelImpl _value, $Res Function(_$MemberApiModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MemberApiModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
  }) {
    return _then(_$MemberApiModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemberApiModelImpl
    with DiagnosticableTreeMixin
    implements _MemberApiModel {
  const _$MemberApiModelImpl({required this.id, required this.username});

  factory _$MemberApiModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemberApiModelImplFromJson(json);

  /// The member's ID.
  @override
  final String id;

  /// The member's username.
  @override
  final String username;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MemberApiModel(id: $id, username: $username)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MemberApiModel'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('username', username));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemberApiModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, username);

  /// Create a copy of MemberApiModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemberApiModelImplCopyWith<_$MemberApiModelImpl> get copyWith =>
      __$$MemberApiModelImplCopyWithImpl<_$MemberApiModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemberApiModelImplToJson(
      this,
    );
  }
}

abstract class _MemberApiModel implements MemberApiModel {
  const factory _MemberApiModel(
      {required final String id,
      required final String username}) = _$MemberApiModelImpl;

  factory _MemberApiModel.fromJson(Map<String, dynamic> json) =
      _$MemberApiModelImpl.fromJson;

  /// The member's ID.
  @override
  String get id;

  /// The member's username.
  @override
  String get username;

  /// Create a copy of MemberApiModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemberApiModelImplCopyWith<_$MemberApiModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
