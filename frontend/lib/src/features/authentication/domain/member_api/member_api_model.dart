import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'member_api_model.freezed.dart';
part 'member_api_model.g.dart';

@freezed
abstract class MemberApiModel with _$MemberApiModel {
  const factory MemberApiModel({
    /// The member's ID.
    required String id,

    /// The member's username.
    required String username,
  }) = _MemberApiModel;

  factory MemberApiModel.fromJson(Map<String, Object?> json) =>
      _$MemberApiModelFromJson(json);
}