import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/features/friendship/application/friendship_service.dart';
import 'package:frontend/src/features/friendship/presentation/friend_component_base.dart';
import 'package:get_it/get_it.dart';

class Friend extends StatelessWidget {
  const Friend({
    super.key,
    required this.member,
    required this.updateFriendsState
  });

  final Member member;
  final void Function() updateFriendsState;  

  @override
  Widget build(BuildContext context) {
    return FriendBase(
      member: member,
      action: () {
        GetIt.I<FriendshipService>()
          .deleteFriend(member.id)
          .then((value) => updateFriendsState());
      },
      icon: Icons.delete
    ) ;
  }
}