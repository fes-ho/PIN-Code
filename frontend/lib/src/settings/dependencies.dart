import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/authentication/data/auth_apli_client.dart';
import 'package:frontend/src/features/authentication/data/auth_repositories/auth_repository.dart';
import 'package:frontend/src/features/authentication/data/auth_repositories/auth_repository_remote.dart';
import 'package:frontend/src/features/authentication/data/member_repositories/member_repository_remote.dart';
import 'package:frontend/src/features/authentication/data/member_repositories/member_repository.dart';
import 'package:frontend/src/features/authentication/data/shared_preferences_service.dart';
import 'package:frontend/src/features/moods/data/mood_api_client.dart';
import 'package:frontend/src/features/moods/data/mood_repositories/mood_repository.dart';
import 'package:frontend/src/features/moods/data/mood_repositories/mood_repository_remote.dart';
import 'package:frontend/src/features/tasks/data/task_repository.dart';
import 'package:frontend/src/features/tasks/data/task_repository_remote.dart';
import 'package:frontend/src/features/today/presentation/today_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:frontend/src/features/time_tracking/data/time_tracking_api_client.dart';
import 'package:frontend/src/features/time_tracking/data/time_tracking_service.dart';
import 'package:frontend/src/features/time_tracking/data/time_tracking_repository.dart';

/// Shared providers for all configurations.
List<SingleChildWidget> _sharedProviders = [];

/// Configure dependencies for remote data.
/// This dependency list uses repositories that connect to a remote server.
List<SingleChildWidget> get providersRemote {
  return [
    Provider(
      create: (context) => AuthApiClient(),
    ),
    Provider(
      create: (context) => ApiClient(),
    ),
    Provider(
      create: (context) => MoodApiClient(
        apiClient: context.read(),
      ),
    ),
    Provider(
      create: (context) => SharedPreferencesService(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryRemote(
        authApiClient: context.read(),
        apiClient: context.read(),
        sharedPreferencesService: context.read(),
      ) as AuthRepository,
    ),
    Provider(
      create: (context) => MemberRepositoryRemote(
        apiClient: context.read(),
      ) as MemberRepository,
    ),
    Provider(
      create: (context) => TaskRepositoryRemote(
        apiClient: context.read(),
      ) as TaskRepository,
    ),
    ChangeNotifierProvider(
      create: (context) => MoodRepositoryRemote(
        apiClient: context.read(),
        moodApiClient: context.read(),
      ) as MoodRepository,
    ),
    ChangeNotifierProvider(
      create: (context) => TodayViewModel(
        taskRepository: context.read(),
        moodRepository: context.read(),
      ),
    ),
    Provider(
      create: (context) => TimeTrackingApiClient(
        apiClient: context.read(),
      ),
    ),
    Provider(
      create: (context) => TimeTrackingService(
        apiClient: context.read(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => TimeTrackingRepository(
        service: context.read(),
      ),
    ),
    ..._sharedProviders,
  ];
}

// TODO:
/// Configure dependencies for local data.
/// This dependency list uses repositories that provide local data.
/// The user is always logged in.
// List<SingleChildWidget> get providersLocal {return null}