import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/features/moods/presentation/mood_emoji.dart';
import 'package:frontend/src/features/today/presentation/today_viewmodel.dart';
import 'package:go_router/go_router.dart';

class MoodDialog extends StatelessWidget{
  const MoodDialog({
    super.key,
    required this.viewModel,
  });

  final TodayViewModel viewModel;

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: const Text("Choose your today's mood!"),
        content: Wrap (
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.spaceEvenly,
          runAlignment: WrapAlignment.spaceEvenly,
          children: 
            List.generate(
              TypeOfMood.values.length,
              (index) {
                return TextButton(
                  onPressed: () {
                    viewModel.manageMood.execute(TypeOfMood.values[index]);
                    context.pop();
                  },
                child: MoodEmoji(mood: TypeOfMood.values[index]),
              );
            },
          ),
        ),
      );
    }
  }
