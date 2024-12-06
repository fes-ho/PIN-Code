import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/utils/date_time_utils.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class MoodService extends ChangeNotifier{
  MoodService() {
    _memberService = GetIt.I<MemberService>();
    _headersFactory = GetIt.I<HeadersFactory>();
    _client = GetIt.I<Client>();
    getMemberMoods();
  }

  late MemberService _memberService;
  late HeadersFactory _headersFactory;
  late Client _client;

  Mood? _todayMood;
  List<Mood> _memberMoods = [];

  get moods => _memberMoods;

  Future<TypeOfMood?> getMood() async {
    _todayMood ??= await _getMood();

    return _todayMood?.typeOfMood;
  }

  Future<Mood?> _getMood() async {
      String userId = _memberService.getCurrentUserId();

      String date = getTodayDate().toIso8601String();

      final response = await _client.get(
        Uri.parse('${Config.apiUrl}/members/$userId/mood/$date'),
        headers: await _headersFactory.getDefaultHeaders()
      );

      if (response.statusCode != 200 || response.body.toString() == "null") {
        return null;
      }

      return Mood.fromJson(jsonDecode(response.body));
  }

  Future manageMood(TypeOfMood typeOfMood) async{
    try {
      if (_todayMood == null) {
        await _createMood(typeOfMood);

        return;
      }

      if (_todayMood!.typeOfMood == typeOfMood) {
        await _deleteMood();
        return;
      }

      await _updateMood(typeOfMood);

      _memberMoods.add(_todayMood!);
    
    } finally {
      notifyListeners();
    }
  }

  Future _createMood(TypeOfMood typeOfMood) async {
    String userId = _memberService.getCurrentUserId();

    Mood mood = Mood(
      id: null, 
      day: getTodayDate(), 
      typeOfMood: typeOfMood, 
      memberId: userId
    );

    final response = await _client.post(
      Uri.parse('${Config.apiUrl}/members/mood'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode(mood.toJson())
    );

    if (response.statusCode == 201) {
      _todayMood = Mood.fromJson(jsonDecode(response.body));
      _memberMoods.add(_todayMood!);
    }

    return _todayMood!;
  }

  Future _updateMood(TypeOfMood typeOfMood) async {
    String moodId = _todayMood!.id!;
    String typeOfMoodValue = typeOfMood.name;

    final response = await _client.put(
      Uri.parse('${Config.apiUrl}/members/mood/$moodId/$typeOfMoodValue'),
      headers: await _headersFactory.getDefaultHeaders(),
    );

    if (response.statusCode == 200) {
      _memberMoods.removeWhere((mood) => mood.id == _todayMood!.id);
      _todayMood = Mood.fromJson(jsonDecode(response.body));
      _memberMoods.add(_todayMood!);
    }
  }

  Future<List<Mood>> getMemberMoods() async {
    String memberId = _memberService.getCurrentUserId();

    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$memberId/moods'),
      headers: await _headersFactory.getDefaultHeaders(),
    );

    if (response.statusCode != 200) {
      return [];
    }

    final List<dynamic> taskListJson = jsonDecode(response.body) as List<dynamic>;

    _memberMoods = taskListJson.map((json) => Mood.fromJson(json)).toList();

    return _memberMoods;
  }
  
  Future _deleteMood() async {
    if (_todayMood == null) {
      return;
    }

    final response = await _client.delete(
      Uri.parse('${Config.apiUrl}/members/mood/${_todayMood!.id}'),
      headers: await _headersFactory.getDefaultHeaders(),
    );

    if (response.statusCode == 200) {
      if (_memberMoods.any((mood) => mood.id == _todayMood!.id)) {
        _memberMoods.removeWhere((mood) => mood.id == _todayMood!.id);
      }
      _todayMood = null;
    }

  }
}