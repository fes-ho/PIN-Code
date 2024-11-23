import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/src/config.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

import 'package:frontend/src/settings/dependencies.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Config.initializeSupabase();

  Config.initializeDependencyInjection();

  final settingsController = SettingsController(SettingsService());

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

