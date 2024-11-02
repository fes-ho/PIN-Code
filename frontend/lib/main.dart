import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.get("URL"),
    anonKey: dotenv.get("ANON_KEY"),
  );

  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();
  
  runApp(MyApp(settingsController: settingsController));
}