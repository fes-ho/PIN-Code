import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';

class Friend extends StatelessWidget {
  const Friend({
    super.key,
    required this.member
  });

  final Member member;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(),
      title: Text(member.username),
    );
  }
}