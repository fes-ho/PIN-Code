
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:frontend/src/features/moods/data/mood_repositories/mood_repository.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/utils/command.dart';
import 'package:frontend/src/utils/result.dart';

class StatisticsViewmodel extends ChangeNotifier {
  StatisticsViewmodel({
    required MoodRepository moodRepository,
  }) : _moodRepository = moodRepository {
      _moodRepository.addListener(_getMemberMoods);
      getMemberMoods = Command0(_getMemberMoods)..execute();
  }

  final MoodRepository _moodRepository;

  late Command0 getMemberMoods;

  final List<Mood> _moods = [];

  UnmodifiableListView<Mood> get moods => UnmodifiableListView(_moods);

  Future<Result<List<void>>> _getMemberMoods() async {
    try {
      final result = await _moodRepository.getMoods();
      switch(result) {
        case Ok<List<Mood>>():
          _moods.clear();
          _moods.addAll(result.asOk.value);
          return result;
        case Error<List<Mood>>():
          return result;
      }
    } finally {
      notifyListeners();
    }
  }
}