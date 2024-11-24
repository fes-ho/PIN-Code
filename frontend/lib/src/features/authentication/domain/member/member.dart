import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'member.freezed.dart';
part 'member.g.dart';

@freezed
abstract class Member with _$Member{
  const factory Member({
    
    required String username,

    required String id,
  }) = _Member;

  factory Member.fromJson(Map<String, Object?> json) =>
      _$MemberFromJson(json);

}