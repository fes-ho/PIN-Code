import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';

class FriendBase extends StatelessWidget {
  const FriendBase({
    super.key,
    required this.member,
    required this.action,
    required this.icon
  });

  final Member member;
  final void Function() action;
  final IconData icon; 

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(),
      title: Text(member.username),
      trailing: IconButton(onPressed: () {
        action();
      }, icon: Icon(icon)),
    );
  }
}