import 'package:frontend/src/features/authentication/data/api_client.dart';
import 'package:frontend/src/features/authentication/data/auth_apli_client.dart';
import 'package:frontend/src/features/authentication/data/auth_repository.dart';
import 'package:frontend/src/features/authentication/data/auth_repository_remote.dart';
import 'package:frontend/src/features/authentication/data/member_repository_remote.dart';
import 'package:frontend/src/features/authentication/data/member_repository.dart';
import 'package:frontend/src/features/authentication/data/shared_preferences_service.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

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
    ChangeNotifierProvider(
      create: (context) => TaskListState(),
    ),
    ..._sharedProviders,
  ];
}

// TODO:
/// Configure dependencies for local data.
/// This dependency list uses repositories that provide local data.
/// The user is always logged in.
// List<SingleChildWidget> get providersLocal {return null}