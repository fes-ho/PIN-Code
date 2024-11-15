import 'package:flutter/material.dart';
import 'package:frontend/src/components/mood/utils/mood_utils.dart';
import 'package:frontend/src/domain/type_of_mood.dart';

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