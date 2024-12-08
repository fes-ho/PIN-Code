import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/features/friendship/application/friendship_service.dart';
import 'package:frontend/src/features/friendship/presentation/friend_component_base.dart';
import 'package:get_it/get_it.dart';

class AddFriend extends StatelessWidget {
  const AddFriend({
    super.key,
    required this.member,
    required this.updateState
  });

  final Member member;
  final void Function() updateState;

  @override
  Widget build(BuildContext context) {
    return FriendBase(
      member: member,
      action: () async {
        await GetIt.I<FriendshipService>().addFriend(member.id);
        updateState();
      },
      icon: Icons.add
    );
  }
}