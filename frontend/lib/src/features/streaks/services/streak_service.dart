
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
  
  List<Streak> get streaks => _streaks;

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
    }
  }
}