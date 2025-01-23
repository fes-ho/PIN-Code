import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Container( 
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.only(top: 10.0, bottom: 2.0, left: 10.0, right: 10.0),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "$position.",
              style: GoogleFonts.quicksand(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 10),
            Image.asset('assets/images/base_avatar.png'),
          ],
        ),
        title: Text(
          member.username,
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.w500,
            color: colorScheme.secondary,
          ),
        ),
        trailing: Text(
          "$currentStreak",
          style: GoogleFonts.quicksand(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: colorScheme.secondary,
          ),
        ),
      )
    );
  }
}