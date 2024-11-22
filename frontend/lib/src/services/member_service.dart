import 'package:frontend/src/config.dart';
import 'package:frontend/src/domain/member.dart';
import 'package:frontend/src/services/exceptions/not_logged_in_member_exception.dart';
import 'package:frontend/src/services/utils/headers/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MemberService {

  MemberService() {
    _headersFactory = GetIt.I<HeadersFactory>();
    _client = GetIt.I<Client>();
    _goTrueClient = GetIt.I<GoTrueClient>();
  }

  Member? _member;
  late HeadersFactory _headersFactory;
  late Client _client;
  late GoTrueClient _goTrueClient;

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
    return _goTrueClient.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Session? getCurrentSession() {
    return _goTrueClient.currentSession;
  }

  User? getCurrentUser() {
    return _goTrueClient.currentUser;
  }

  String getCurrentUserId() {
    User? currentUser = getCurrentUser();

    if (currentUser == null) {
      return '';
    }

    return currentUser.id;
  }

  Future<String> getJWT() async{
    Session? currentSession = getCurrentSession();
    
    if (currentSession == null) {
      return '';
    }

    if (currentSession.isExpired) {
      await _goTrueClient.refreshSession();
    }

    return currentSession.accessToken;
  }

  Future<String> getUsername() async{
    String userId = getCurrentUserId();

    final response = await _client.get(
      Uri.parse('${Config.apiUrl}/members/$userId/username'),
      headers: await _headersFactory.getDefaultHeaders()
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to get Username");
    }

    return response.body;
  }
}