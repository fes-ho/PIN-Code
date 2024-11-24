import 'package:supabase_flutter/supabase_flutter.dart';

/// LoginResponse model, this model is not autogenerated because supabase integration with flutter.
class LoginResponse {

    final User user;

    final Session session;

    LoginResponse({
        required this.user,
        required this.session,
    });
}