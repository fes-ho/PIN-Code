import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';

class LeaderboardComponent extends StatelessWidget {
  const LeaderboardComponent({
    super.key,
    required this.member,
    required this.currentStreak,
    required this.position,
  });

  final Member member;
  final int currentStreak;
  final int position;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$position.", style: const TextStyle(fontSize: 24.0,),),
          const CircleAvatar(),
        ],
      ),
      title: Text(member.username),
      trailing: Text(
        "$currentStreak",
        style: const TextStyle(fontSize: 24.0,),
    )
    );
  }
}