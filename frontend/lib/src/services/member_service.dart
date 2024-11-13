import 'package:frontend/src/config.dart';
import 'package:frontend/src/domain/member.dart';
import 'package:frontend/src/services/exceptions/not_logged_in_member_exception.dart';
import 'package:frontend/src/services/utils/headers/headers_factory.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MemberService {
  MemberService._internal();

  factory MemberService() {
    return _memberService;
  }

  static final MemberService _memberService = MemberService._internal();

  Member? _member;

  Future<Member> getMember() async {
    if (_member == null) {
      Session? currentSession = getCurrentSession();
      User? authUser = getCurrentUser();

      if (currentSession == null || authUser == null) {
        throw NotLoggedInMemberException();
      }

      String username = await getUsername();

      _member = Member(username: username, id: authUser.id);
    }

    return _member!;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Session? getCurrentSession() {
    GoTrueClient authClient = Supabase.instance.client.auth;
    return authClient.currentSession;
  }

  User? getCurrentUser() {
    GoTrueClient authClient = Supabase.instance.client.auth;
    return authClient.currentUser;
  }

  String getCurrentUserId() {
    User? currentUser = getCurrentUser();

    if (currentUser == null) {
      return '';
    }

    return currentUser.id;
  }

  String getJWT() {
    Session? currentSession = getCurrentSession();
    if (currentSession == null) {
      return '';
    }

    return currentSession.accessToken;
  }

  Future<String> getUsername() async{
    String userId = getCurrentUserId();

    final response = await get(
      Uri.parse('${Config.apiUrl}/members/$userId/username'),
      headers: HeadersFactory.getDefaultHeaders()
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to get Username");
    }

    return response.body;
  }
}


