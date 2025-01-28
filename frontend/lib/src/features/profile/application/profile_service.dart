import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class ProfileService extends ChangeNotifier {
  ProfileService() {
    _client = GetIt.I<Client>();
    _memberService = GetIt.I<MemberService>();
  }

  late Client _client;
  late MemberService _memberService;


  Future<String> getUsername() async {
    final userId = _memberService.getCurrentUserId();
    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$userId/username'),
      headers: await _memberService.getJWT().then((jwt) => {'Authorization': 'Bearer $jwt'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load username');
    }

    return response.body;
  }

  Future<void> updateImage(String newImage) async {
    final userId = _memberService.getCurrentUserId();
    final response = await _client.put(
      Uri.parse('${Config.apiUrl}/members/$userId/image'),
      headers: await _memberService.getJWT().then((jwt) => {
        'Authorization': 'Bearer $jwt',
        'Content-Type': 'application/json',
        }),
      body: jsonEncode({'image': newImage}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update image');
    }
  }

  Future<int> getNumberTasks() async {
    final userId = _memberService.getCurrentUserId();
    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$userId/tasks'),
      headers: await _memberService.getJWT().then((jwt) => {'Authorization': 'Bearer $jwt'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load number of tasks');
    }

    final tasks = jsonDecode(response.body) as List;

    int res = 0;
    for (var task in tasks) {
      if (task['is_completed'] == true) {
        res++;
      }
    }

    return res;
  }

  Future<int> getNumberHabits() async {
    final userId = _memberService.getCurrentUserId();
    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$userId/habits'),
      headers: await _memberService.getJWT().then((jwt) => {'Authorization': 'Bearer $jwt'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load number of habits');
    }

    final habits = jsonDecode(response.body) as List;

    int res = 0;
    for (var habit in habits) {
      if (habit['is_completed'] == true) {
        res++;
      }
    }

    return res;
  }

  Future<List<double>> getWeeklyProgress() async {
    final userId = _memberService.getCurrentUserId();
    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$userId/tasks'),
      headers: await _memberService.getJWT().then((jwt) => {'Authorization': 'Bearer $jwt'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load weekly progress');
    }

    final tasks = jsonDecode(response.body) as List;

    List<int> completedTasksPerDay = List<int>.filled(7, 0);

    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));

    int totalCompletedTasks = 0;

    for (var task in tasks) {
      final taskDate = DateTime.parse(task['date']);
      if (taskDate.isAfter(lastWeek) && taskDate.isBefore(now)) {
        if (task['is_completed']) {
          int dayIndex = now.difference(taskDate).inDays;
          completedTasksPerDay[dayIndex]++;
          totalCompletedTasks++;
        }
      }
    }

    List<double> progressPerDay = completedTasksPerDay.map((count) => count / totalCompletedTasks).toList();

    return progressPerDay.reversed.toList();
  }
   
  Future<List<String>> getWeeklyProgressDays() async {
  List<String> days = [];
  DateTime now = DateTime.now();
  for (int i = 0; i < 7; i++) {
    DateTime day = now.subtract(Duration(days: i));
    days.add(_getDayOfWeek(day.weekday));
  }
  return days.reversed.toList();
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}