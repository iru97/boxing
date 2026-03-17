import 'package:go_router/go_router.dart';

import 'package:boxing/features/sessions/presentation/session_list_screen.dart';
import 'package:boxing/features/timer/presentation/timer_screen.dart';
import 'package:boxing/features/sessions/presentation/session_editor_screen.dart';
import 'package:boxing/features/settings/presentation/settings_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SessionListScreen(),
    ),
    GoRoute(
      path: '/timer/:sessionId',
      builder: (context, state) => TimerScreen(
        sessionId: state.pathParameters['sessionId']!,
      ),
    ),
    GoRoute(
      path: '/session/new',
      builder: (context, state) => const SessionEditorScreen(),
    ),
    GoRoute(
      path: '/session/edit/:sessionId',
      builder: (context, state) => SessionEditorScreen(
        sessionId: state.pathParameters['sessionId'],
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
