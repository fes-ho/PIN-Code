import 'dart:convert';

import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/authentication/domain/member.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

class FriendshipService {
  FriendshipService() {
    _memberService = GetIt.I<MemberService>();
    _headersFactory = GetIt.I<HeadersFactory>();
    _client = GetIt.I<Client>();
  }

  List<Member> _friends = []; 

  late MemberService _memberService;
  late HeadersFactory _headersFactory;
  late Client _client;

  Future<bool> addFriend(String friendId) async {
    String memberId = _memberService.getCurrentUserId();

    final response = await _client.post(
      Uri.parse('${Config.apiUrl}/members/$memberId/friends/$friendId'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 201) {
      Member friend = Member.fromJson(jsonDecode(response.body));
      _friends.add(friend);

      return true;
    }

    return false;
  }

  Future<bool> deleteFriend(String friendId) async {
    String memberId = _memberService.getCurrentUserId();

    final response = await _client.delete(
      Uri.parse('${Config.apiUrl}/members/$memberId/friends/$friendId'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 200) {
      _deleteFriendFromList(friendId);

      return true;
    }

    return false;
  }

  Future<List<Member>> getFriends() async {
    String memberId = _memberService.getCurrentUserId();

    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$memberId/friends'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 200) {
      _friends = _convertJsonToMemberList(response);
    }

    return _friends;
  }

  Future<List<Member>> getMembersByName(String username) async {
    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/username/$username'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode == 200) {
      return _convertJsonToMemberList(response);
    }

    return [];
  }

  bool isMemberFriend(Member member) {
    return _friends.any((m) => m.id == member.id);
  }

  List<Member> _convertJsonToMemberList(Response response) {
    final List<dynamic> friendsListJson = jsonDecode(response.body) as List<dynamic>;
    
    return friendsListJson.map((json) => Member.fromJson(json)).toList();
  }

  void _deleteFriendFromList(String friendId) {
    _friends.removeWhere((f) => f.id == friendId);
  }
}