import 'dart:convert';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/habits/domain/day_time.dart';
import 'package:frontend/src/features/habits/domain/habit.dart';
import 'package:frontend/src/features/streaks/services/streak_service.dart';
import 'package:frontend/src/features/tasks/domain/task.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import '../../authentication/application/member_service.dart';

class HabitService {
  late Client _client;
  late HeadersFactory _headersFactory;
  late MemberService _memberService;
  late StreakService _streakService;

  HabitService() {
    _client = GetIt.I<Client>();
    _headersFactory = GetIt.I<HeadersFactory>();
    _memberService = GetIt.I<MemberService>();
    _streakService = GetIt.I<StreakService>();
  }

  Future<Habit> createHabit(Habit habit) async {
    final response = await _client.post(
      Uri.parse('${Config.apiUrl}/habits'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode(habit.toJson()),
    );

    if (response.statusCode == 201) {
      return Habit.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create habit');
    }
  }

  Future<Habit> updateHabit(Habit habit) async {
    final response = await _client.put(
      Uri.parse('${Config.apiUrl}/habits/${habit.id}'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode(habit.toJson()),
    );

    if (response.statusCode == 200) {
      return Habit.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update habit');
    }
  }

  Future<void> completeHabit(Habit habit) async {
    final response = await _client.patch(
      Uri.parse('${Config.apiUrl}/habits/${habit.id}/complete'),
      headers: await _headersFactory.getDefaultHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to complete habit');
    }
    await _streakService.getStreaks();
  }

  Future<void> deleteHabit(Habit habit) async {
    final response = await _client.delete(
      Uri.parse('${Config.apiUrl}/habits/${habit.id}'),
      headers: await _headersFactory.getDefaultHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete habit');
    }
  }

  Future<List<Habit>> getHabits() async {
    var memberId = await _memberService.getMember().then((member) => member.id);
    final response = await get(
      Uri.parse('${Config.apiUrl}/members/$memberId/habits'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 200) {
      final List<dynamic> habitListJson = jsonDecode(response.body) as List<dynamic>;
      return habitListJson.map((json) => Habit.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to retrieve habits');
    }
  }

  Future<Habit> updateHabitDuration(String habitId, int duration, {int? estimatedDuration}) async {
    final response = await _client.patch(
      Uri.parse('${Config.apiUrl}/habits/$habitId/duration'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode({
        'duration': duration,
        'estimated_duration': estimatedDuration,
      }),
    );

    if (response.statusCode == 200) {
      return Habit.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update habits duration');
    }
  }

  Future<Habit> updateHabitTime(String habitId, DayTime dayTime) async {
    final response = await _client.patch(
      Uri.parse('${Config.apiUrl}/habits/$habitId/time'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode({
        'dayTime': dayTime,
      }),
    );

    if (response.statusCode == 200) {
      return Habit.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to update habits time');
    }
  }
}