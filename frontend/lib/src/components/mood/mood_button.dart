import 'package:flutter/material.dart';
import 'package:frontend/src/components/mood/mood_emoji.dart';
import 'package:frontend/src/domain/type_of_mood.dart';

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
