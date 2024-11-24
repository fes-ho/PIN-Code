import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/moods/domain/mood.dart';
import 'package:frontend/src/utils/date_time_utils.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class MoodService {
  MoodService() {
    _memberService = GetIt.I<MemberService>();
    _headersFactory = GetIt.I<HeadersFactory>();
  }

  late MemberService _memberService;
  late HeadersFactory _headersFactory;

  Mood? _mood;

  Future<Mood?> getMood() async {
    _mood ??= await _getMood();

    return _mood;
  }

  Future<Mood?> _getMood() async {
      String userId = _memberService.getCurrentUserId();

      String date = getTodayDate().toIso8601String();

      final request = await get(
        Uri.parse('${Config.apiUrl}/$userId/mood/$date'),
        headers: await _headersFactory.getDefaultHeaders()
      );

      if (request.statusCode != 201) {
      }
  }
}