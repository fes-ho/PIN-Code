
import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/data/mood_repositories/mood_repository.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/utils/command.dart';

class MoodViewModel extends ChangeNotifier
{
  MoodViewModel({
    required MoodRepository moodRepository,
  }) : _moodRepository = moodRepository;   

  final MoodRepository _moodRepository;

  late Command0 getTypeOfMood;

  Mood? _todayMood;

  TypeOfMood get typeOfMood => _todayMood?.typeOfMood ?? TypeOfMood.great;
}