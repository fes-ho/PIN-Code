import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/components/utils/mood_utils.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';

class MoodEmoji extends StatelessWidget {
  const MoodEmoji({super.key, this.mood});

  final TypeOfMood? mood;

  @override
  Widget build(BuildContext context) {
    return Text(
      mood != null ? mood!.getEmoji() : '',
      style: const TextStyle(
        fontSize: 23
      ),
    );
  }
}