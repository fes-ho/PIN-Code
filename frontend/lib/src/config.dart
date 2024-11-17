import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/services/member_service.dart';
import 'package:frontend/src/services/task_service.dart';
import 'package:frontend/src/services/utils/headers/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Config {
  static String get apiUrl => dotenv.get('API_URL');

  static Future initializeSupabase({bool? isTest}) async {
    if (isTest != null && isTest) {
      return;
    }

    final supabase = await Supabase.initialize(
      url: dotenv.get("URL"),
      anonKey: dotenv.get("ANON_KEY"),
    );

    GetIt.I.registerSingleton(supabase);
    GetIt.I.registerSingleton(supabase.client.auth);
  }

  static void initializeDependencyInjection({bool? isTest}) {
    if (isTest != null && isTest) {
      return;
    }

    GetIt.I.registerSingleton(HeadersFactory());
    GetIt.I.registerSingleton(Client());
    GetIt.I.registerSingleton(MemberService());
    GetIt.I.registerSingleton(TaskService());
  }
}
