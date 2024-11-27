import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/presentation/mood_dialog.dart';
import 'package:frontend/src/features/moods/presentation/mood_emoji.dart';
import 'package:frontend/src/features/moods/presentation/mood_viewmodel.dart';

class MoodButton extends StatelessWidget {
  const MoodButton({
    super.key,
    required this.viewModel,
  });

  final MoodViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return TextButton(
          onPressed: () => (), 
          child: MoodEmoji( 
            mood: viewModel.typeOfMood,
          )
        );
      } 
    );
  }
}
