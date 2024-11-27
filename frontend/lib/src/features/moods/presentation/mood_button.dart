import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/presentation/mood_dialog.dart';
import 'package:frontend/src/features/moods/presentation/mood_emoji.dart';
import 'package:frontend/src/features/today/presentation/today_viewmodel.dart';

class MoodButton extends StatefulWidget  {
  const MoodButton({
    super.key,
    required this.viewModel,
  });

  final TodayViewModel viewModel;

  @override
  State<MoodButton> createState() => _MoodButtonState();
}

class _MoodButtonState extends State<MoodButton> {

  @override
  void initState() {
    super.initState();
    widget.viewModel.getTodayMood.execute();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return TextButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) => MoodDialog(viewModel: widget.viewModel),
            );
          }, 
          child: MoodEmoji( 
            mood: widget.viewModel.typeOfMood,
          )
        );
      } 
    );
  }
}
