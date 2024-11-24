import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:frontend/src/settings/dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  final settingsController = SettingsController(SettingsService());

  await Supabase.initialize(
    url: dotenv.get("URL"),
    anonKey: dotenv.get("ANON_KEY"),
  );

  await settingsController.loadSettings();
  
  runApp(
    MultiProvider(
      providers: providersRemote,
      child: MyApp(settingsController: settingsController),
    )
  );
    // ChangeNotifierProvider( 
    //   create: (context) => TaskListState(),
    //   child: MyApp(settingsController: settingsController)));
}

