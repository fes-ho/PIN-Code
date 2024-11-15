import 'package:frontend/src/config.dart';
import 'package:frontend/src/domain/mood.dart';
import 'package:frontend/src/services/member_service.dart';
import 'package:frontend/src/services/utils/headers/date_time_utils.dart';
import 'package:frontend/src/services/utils/headers/headers_factory.dart';
import 'package:http/http.dart';

class MoodService {
  MoodService._internal();

  factory MoodService() {
    return _moodService;
  }

  static final MoodService _moodService = MoodService._internal();

  Mood? _mood;

  Future<Mood?> getMood() async {
    _mood ??= await _getMood();

    return _mood;
  }

  Future<Mood?> _getMood() async {
      String userId = MemberService().getCurrentUserId();

      String date = getTodayDate().toIso8601String();

      final request = await get(
        Uri.parse('${Config.apiUrl}/$userId/mood/$date'),
        headers: await HeadersFactory.getDefaultHeaders()
      );

      if (request.statusCode != 201) {
        throw 
      }
  }
}