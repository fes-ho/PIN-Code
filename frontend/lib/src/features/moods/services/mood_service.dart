import 'dart:convert';

import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/features/moods/domain/type_of_mood.dart';
import 'package:frontend/src/utils/date_time_utils.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class MoodService {
  MoodService() {
    _memberService = GetIt.I<MemberService>();
    _headersFactory = GetIt.I<HeadersFactory>();
    _client = GetIt.I<Client>();
  }

  late MemberService _memberService;
  late HeadersFactory _headersFactory;
  late Client _client;

  Mood? _mood;

  Future<TypeOfMood?> getMood() async {
    _mood ??= await _getMood();

    return _mood?.typeOfMood;
  }

  Future<Mood?> _getMood() async {
      String userId = _memberService.getCurrentUserId();

      String date = getTodayDate().toIso8601String();

      final request = await _client.get(
        Uri.parse('${Config.apiUrl}/members/$userId/mood/$date'),
        headers: await _headersFactory.getDefaultHeaders()
      );

      if (request.statusCode != 200 || request.body.toString() == "null") {
        return null;
      }

      return Mood.fromJson(jsonDecode(request.body));
  }

  Future createOrUpdateMood(TypeOfMood typeOfMood) async{
    if (_mood == null) {
      await _createMood(typeOfMood);

      return;
    }

    if (_mood!.typeOfMood == typeOfMood) {
      return;
    }

    await _updateMood(typeOfMood);
  }

  Future _createMood(TypeOfMood typeOfMood) async {
    String userId = _memberService.getCurrentUserId();

    Mood mood = Mood(
      id: null, 
      day: getTodayDate(), 
      typeOfMood: typeOfMood, 
      memberId: userId
    );

    final request = await _client.post(
      Uri.parse('${Config.apiUrl}/members/mood'),
      headers: await _headersFactory.getDefaultHeaders(),
      body: jsonEncode(mood.toJson())
    );

    if (request.statusCode == 201) {
      _mood = Mood.fromJson(jsonDecode(request.body));
    }

    return _mood!;
  }

  Future _updateMood(TypeOfMood typeOfMood) async{
    String moodId = _mood!.id!;
    String typeOfMoodValue = typeOfMood.name;

    final request = await _client.put(
      Uri.parse('${Config.apiUrl}/members/mood/$moodId/$typeOfMoodValue'),
      headers: await _headersFactory.getDefaultHeaders(),
    );

    if (request.statusCode == 200) {
      _mood = Mood.fromJson(jsonDecode(request.body));
    }
  }
}