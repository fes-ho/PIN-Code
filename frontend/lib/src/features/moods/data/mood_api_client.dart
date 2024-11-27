
import 'dart:convert';
import 'dart:io';

import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/utils/date_time_utils.dart';
import 'package:frontend/src/utils/result.dart';

class MoodApiClient {
  MoodApiClient({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<Mood>> getMood() async {
    final client = _apiClient.clientFactory();
    try {
      String memberId = await _apiClient.getMemberId();
      String date = getTodayDate().toIso8601String();
      final request = await client.get(_apiClient.host, _apiClient.port, '/members/$memberId/mood/$date');
      await _apiClient.authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final mood = Mood.fromJson(jsonDecode(stringData));
        return Result.ok(mood);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<Mood>> createMood(Mood mood) async {
    final client = _apiClient.clientFactory();
    try {
      final request = await client.post(_apiClient.host, _apiClient.port, '/members/mood');
      await _apiClient.authHeader(request.headers);
      request.write(jsonEncode(mood));
      final response = await request.close();
      if (response.statusCode == 201) {
        final stringData = await response.transform(utf8.decoder).join();
        final createdMood = Mood.fromJson(jsonDecode(stringData));
        return Result.ok(createdMood);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<Mood>> updateMood(String moodId, String typeOfMoodValue) async {
    final client = _apiClient.clientFactory();
    try {
      final request = await client.put(_apiClient.host, _apiClient.port, '/members/mood/$moodId/$typeOfMoodValue');
      await _apiClient.authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final updatedMood = Mood.fromJson(jsonDecode(stringData));
        return Result.ok(updatedMood);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<List<Mood>>> getMoods() async {
    final client = _apiClient.clientFactory();
    try {
      String memberId = await _apiClient.getMemberId();
      final request = await client.get(_apiClient.host, _apiClient.port, '/members/$memberId/moods');
      await _apiClient.authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final json = jsonDecode(stringData) as List<dynamic>;
        return Result.ok(
          json.map((e) => Mood.fromJson(e)).toList());
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

  Future<Result<void>> deleteMood(String moodId) async {
    final client = _apiClient.clientFactory();
    try {
      final request = await client.delete(_apiClient.host, _apiClient.port, '/members/mood/$moodId');
      await _apiClient.authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        return Result.ok(null);
      } else {
        return Result.error(const HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    } finally {
      client.close();
    }
  }

}