import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/data/auth_repository.dart';
import 'package:frontend/src/features/authentication/presentation/login_view.dart';
import 'package:frontend/src/features/authentication/presentation/login_viewmodel.dart';
import 'package:frontend/src/routing/routes.dart';
import 'package:frontend/src/views/today_view.dart';
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
        GoRoute(
          path: Routes.today,
          builder: (context, state) {
            return TodayView();
          },
        ),
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