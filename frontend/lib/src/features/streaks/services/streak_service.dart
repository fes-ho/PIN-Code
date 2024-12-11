
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/streaks/domain/streak.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class StreakService extends ChangeNotifier {

  StreakService() {
    _memberService = GetIt.I<MemberService>();
    _headersFactory = GetIt.I<HeadersFactory>();
    _client = GetIt.I<Client>();
    getStreaks();
  }

  late MemberService _memberService;
  late Client _client;
  late HeadersFactory _headersFactory;

  List<Streak> _streaks = [];
  int _currentStreak = 0;
  int _bestStreak = 0;
  
  List<Streak> get streaks => _streaks;

  int get currentStreak => _currentStreak;
  int get bestStreak => _bestStreak;

  void calculateBestStreak() {
    _bestStreak = 0;
    int streak = 0;
    for (int i = 0; i < _streaks.length; i++){
      if (i == 0){
        streak = 1;
      } else {
        if (_streaks[i].date.difference(_streaks[i - 1].date).inDays == 1){
          streak++;
          if (streak > _bestStreak){
            _bestStreak = streak;
          }
        } else {
          streak = 1;
        }
      }
    }
  }

  void calculateCurrentStreak() {
    _currentStreak = 0;
    _streaks.sort((a, b) => b.date.compareTo(a.date));
    for (int i = 0; i < _streaks.length; i++){
      if (i == 0 && _streaks[i].date.day != DateTime.now().day){
        break;
      }
      var difference = _streaks[i].date.difference(DateTime.now()).inDays;
      if (difference == -i){
        _currentStreak++;
      } else {
        break;
      }
    }
  }

  Future<void> getStreaks() async {
    String userId = _memberService.getCurrentUserId();

    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$userId/streaks'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 200) {
      _streaks = (jsonDecode(response.body) as List)
          .map((e) => Streak.fromJson(e))
          .toList();

      _streaks.sort((a, b) => a.date.compareTo(b.date));
      calculateBestStreak();
      calculateCurrentStreak();
    }
  }

Future<int> getCurrentStreaksByUserId(String userId) async {
    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$userId/streaks'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 200) {
      _streaks = (jsonDecode(response.body) as List)
          .map((e) => Streak.fromJson(e))
          .toList();
      calculateCurrentStreak();
      return _currentStreak;
    }else {
      throw Exception('Failed to get Streaks');
    }
  }
}