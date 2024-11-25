import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/data/auth_repositories/auth_repository.dart';
import 'package:frontend/src/features/authentication/presentation/login_view.dart';
import 'package:frontend/src/features/authentication/presentation/login_viewmodel.dart';
import 'package:frontend/src/features/tasks/domain/task/task.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_view.dart';
import 'package:frontend/src/features/tasks/presentation/create_task_viewmodel.dart';
import 'package:frontend/src/features/tasks/presentation/task_list_view.dart';
import 'package:frontend/src/features/tasks/presentation/today_viewmodel.dart';
import 'package:frontend/src/routing/routes.dart';
import 'package:frontend/src/common_widgets/custom_navigation_bar.dart';
import 'package:frontend/src/features/tasks/presentation/today_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Top go_router entry point.
///
/// Listens to changes in [AuthTokenRepository] to redirect the user
/// to /login when the user logs out.
GoRouter router(
  AuthRepository authRepository,
) =>
    GoRouter(
      initialLocation: Routes.today,
      debugLogDiagnostics: true,
      redirect: _redirect,
      refreshListenable: authRepository,
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) {
            return LoginView(
              viewModel: LoginViewModel(
                authRepository: context.read(),
              ),
            );
          },
        ),
        StatefulShellRoute.indexedStack(
            builder: (context, state, navigationShell) =>
                CustomNavigationBar(navigationShell: navigationShell),
            branches: [
              StatefulShellBranch(routes: [
                GoRoute(
                    path: Routes.today,
                    builder: (context, state) {
                      return TodayView(
                        viewModel: context.read(),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: Routes.createTaskRelative,
                        builder: (context, state) {
                          return CreateTaskView(
                            viewModel: CreateTaskViewModel(
                              taskRepository: context.read(),
                              todayViewModel: context.read(),
                            ),
                          );
                        },
                      )
                    ]),
              ]),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.social,
                    builder: (context, state) {
                      // TODO: Implement Social view
                      return Container(
                        color: Colors.blue,
                        child: Center(
                          child: Text('Social'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.stats,
                    builder: (context, state) {
                      // TODO: Implement Stats view
                      return Container(
                        color: Colors.green,
                        child: Center(
                          child: Text('Stats'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: Routes.profile,
                    builder: (context, state) {
                      // TODO: Implement profile view
                      return Container(
                        color: Colors.purple,
                        child: Center(
                          child: Text('Profile'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ])
      ],
    );

// From https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/redirection.dart
Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  // if the user is not logged in, they need to login
  final bool loggedIn = await context.read<AuthRepository>().isAuthenticated;
  final bool loggingIn = state.matchedLocation == Routes.login;
  if (!loggedIn) {
    return Routes.login;
  }

  // if the user is logged in but still on the login page, send them to
  // the home page
  if (loggingIn) {
    return Routes.today;
  }

  // no need to redirect at all
  return null;
}
