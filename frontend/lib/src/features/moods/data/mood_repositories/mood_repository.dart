
import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/utils/result.dart';

abstract class MoodRepository extends ChangeNotifier
{
  Future<Result<Mood>> createMood(TypeOfMood typeOfMood);

  Future<Result<List<Mood>>> getMoods();

  Future<Result<Mood>> updateMood(String moodId, TypeOfMood typeOfMood);

  Future<Result<void>> deleteMood(String moodId);

  Future<Result<Mood>> getMood();
}