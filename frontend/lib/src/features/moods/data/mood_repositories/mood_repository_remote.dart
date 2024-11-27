import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/moods/data/mood_api_client.dart';
import 'package:frontend/src/features/moods/data/mood_repositories/mood_repository.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/utils/date_time_utils.dart';
import 'package:frontend/src/utils/result.dart';

class MoodRepositoryRemote extends ChangeNotifier implements MoodRepository {
  MoodRepositoryRemote({
    required ApiClient apiClient,
    required MoodApiClient moodApiClient,
  }) : _moodApiClient = moodApiClient,
       _apiClient = apiClient;

  final ApiClient _apiClient;
  final MoodApiClient _moodApiClient;

  List<Mood>? _cachedData;

  @override
  Future<Result<Mood>> getMood() async {
    return await _moodApiClient.getMood();
  }

  @override
  Future<Result<Mood>> createMood(TypeOfMood typeOfMood) async {
    Mood mood = Mood(
      id: null,
      day: getTodayDate(),
      typeOfMood: typeOfMood,
      memberId: await _apiClient.getMemberId(),
    );
    final result = await _moodApiClient.createMood(mood);
    final createdMood = result.asOk.value;
    _cachedData ??= [];
    _checkDuplicates(createdMood.id);
    _cachedData?.add(result.asOk.value);
    notifyListeners();
    return result;
  }

  @override
  Future<Result<void>> deleteMood(String moodId) async {
    _cachedData?.removeWhere((element) => element.id == moodId);
    notifyListeners();
    return await _moodApiClient.deleteMood(moodId);
  }

  @override
  Future<Result<List<Mood>>> getMoods() async {
    if (_cachedData == null) {
      final result = await _moodApiClient.getMoods();
      if (result is Ok) {
        _cachedData = result.asOk.value;
        notifyListeners();
      }
      return result;
    } else {
      return Result.ok(_cachedData!);
    }
  }

  @override
  Future<Result<Mood>> updateMood(String moodId, TypeOfMood typeOfMood) async {
    String typeOfMoodValue = typeOfMood.name;
    _checkDuplicates(moodId);
    final result = await _moodApiClient.updateMood(moodId, typeOfMoodValue);
    if (result is Ok) {
      final updatedMood = result.asOk.value;
      _cachedData?.add(updatedMood);
      notifyListeners();

      return Result.ok(updatedMood);
    } else {
      return result;
    }
  }

  void _checkDuplicates(String? moodId) {
    if (_cachedData == null || 
        moodId == null || 
        !_cachedData!.any((element) => element.id == moodId)) 
    {
      return;
    }
    _cachedData?.removeWhere((element) => element.id == moodId);
  }
}