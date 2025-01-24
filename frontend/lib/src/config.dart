import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/features/authentication/application/member_service.dart';
import 'package:frontend/src/features/friendship/application/friendship_service.dart';
import 'package:frontend/src/features/moods/services/mood_service.dart';
import 'package:frontend/src/features/profile/application/profile_service.dart';
import 'package:frontend/src/features/streaks/services/streak_service.dart';
import 'package:frontend/src/features/tasks/application/task_service.dart';
import 'package:frontend/src/utils/headers_factory.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class Config {
  static String get apiUrl => dotenv.get('API_URL');
  static String get togetherApiKey => dotenv.get('TOGETHER_API_KEY');

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
    GetIt.I.registerSingleton(http.Client());
    GetIt.I.registerSingleton(MemberService());
    GetIt.I.registerSingleton(StreakService());
    GetIt.I.registerSingleton(TaskService());
    GetIt.I.registerSingleton(MoodService());
    GetIt.I.registerSingleton(ProfileService());
    GetIt.I.registerSingleton(FriendshipService());
  }
}

class AIChatService {
  String get apiKey => Config.togetherApiKey;
  
  Future<String> getAIResponse(String message) async {
    try {
      print('Using API Key: ${apiKey.substring(0, 5)}...'); 
      
      final response = await http.post(
        Uri.parse('https://api.together.xyz/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'deepseek-ai/DeepSeek-R1',
          'messages': [{'role': 'user', 'content': message}],
        }),
      );
      
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode != 200) {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
      
      final data = jsonDecode(response.body);
      if (data['choices'] == null || data['choices'].isEmpty) {
        throw Exception('Invalid API response format');
      }
      
      return data['choices'][0]['message']['content'];
    } catch (e) {
      print('Error in getAIResponse: $e');
      rethrow;
    }
  }
}

