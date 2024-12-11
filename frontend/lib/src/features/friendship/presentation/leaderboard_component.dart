import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';

class LeaderboardComponent extends StatelessWidget {
  const LeaderboardComponent({
    super.key,
    required this.member,
    required this.currentStreak,
  });

  final Member member;
  final int currentStreak;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(),
      title: Text(member.username + currentStreak.toString()),
    );
  }
}