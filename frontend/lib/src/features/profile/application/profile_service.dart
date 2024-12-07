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
}