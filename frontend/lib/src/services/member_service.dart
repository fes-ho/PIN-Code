import 'package:frontend/src/domain/member.dart';
import 'package:frontend/src/services/exceptions/not_logged_in_member_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MemberService {
  MemberService._internal();

  factory MemberService() {
    return _memberService;
  }

  static final MemberService _memberService = MemberService._internal();

  Member? _member;

  Future<Member> getMember() async{
    if (_member == null) {
      GoTrueClient authClient = Supabase.instance.client.auth;
      Session? currentSession = authClient.currentSession;
      User? authUser = authClient.currentUser;
      
      if(currentSession == null || authUser == null) {
        throw NotLoggedInMemberException();
      }

      // TODO Retrieve the Member Username calling the API
      _member = Member(username: "anyUserName", id: authUser.id);

    }

    // TODO change when user is retrieved using the API call
    return Future.value(_member);
  }

  Future<AuthResponse> signIn(String email, String password) async{
    return Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
}