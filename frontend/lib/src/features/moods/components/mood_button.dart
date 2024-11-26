import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/components/mood_emoji.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';

class MoodButton extends StatelessWidget {
  const MoodButton({
    super.key,
    required this.typeOfMood, 
    required this.onAction
  });

  final TypeOfMood typeOfMood;
  final void Function() onAction;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onAction,
      child: MoodEmoji(
        mood: typeOfMood,
      )
    );
  }
}
