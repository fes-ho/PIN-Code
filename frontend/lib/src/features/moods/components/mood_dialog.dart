import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/components/mood_button.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/features/moods/services/mood_service.dart';
import 'package:get_it/get_it.dart';

Future<void> showMoodDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Choose your today's mood!"),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.spaceEvenly,
          runAlignment: WrapAlignment.spaceEvenly,
          children: List.generate(
            TypeOfMood.values.length,
            (index) => MoodButton(
              typeOfMood: TypeOfMood.values[index], 
              onAction: () async {
                await GetIt.I<MoodService>().manageMood(TypeOfMood.values[index]);
                Navigator.of(context).pop();
              } 
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    }
  );
}