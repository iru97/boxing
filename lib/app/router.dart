import 'package:go_router/go_router.dart';

import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/sessions/presentation/session_list_screen.dart';
import 'package:boxing/features/timer/presentation/timer_screen.dart';
import 'package:boxing/features/sessions/presentation/session_editor_screen.dart';
import 'package:boxing/features/history/presentation/history_screen.dart';
import 'package:boxing/features/settings/presentation/settings_screen.dart';
import 'package:boxing/features/programs/presentation/program_browse_screen.dart';
import 'package:boxing/features/programs/presentation/program_detail_screen.dart';
import 'package:boxing/features/programs/presentation/program_day_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SessionListScreen(),
    ),
    GoRoute(
      path: '/timer/:sessionId',
      builder: (context, state) {
        final sessionId = state.pathParameters['sessionId']!;
        final resume = state.uri.queryParameters['resume'] == 'true';

        // Check for program workout data passed via extra
        final extra = state.extra;
        SessionModel? sessionOverride;
        String? programId;
        int? weekNum;
        int? dayNum;

        if (extra is Map<String, dynamic>) {
          sessionOverride = extra['session'] as SessionModel?;
          programId = extra['programId'] as String?;
          weekNum = extra['weekNum'] as int?;
          dayNum = extra['dayNum'] as int?;
        }

        return TimerScreen(
          sessionId: sessionId,
          resumeFromCheckpoint: resume,
          sessionOverride: sessionOverride,
          programId: programId,
          programWeekNum: weekNum,
          programDayNum: dayNum,
        );
      },
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
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/programs',
      builder: (context, state) => const ProgramBrowseScreen(),
    ),
    GoRoute(
      path: '/programs/:programId',
      builder: (context, state) => ProgramDetailScreen(
        programId: state.pathParameters['programId']!,
      ),
    ),
    GoRoute(
      path: '/programs/:programId/day/:weekDay',
      builder: (context, state) => ProgramDayScreen(
        programId: state.pathParameters['programId']!,
        weekDay: state.pathParameters['weekDay']!,
      ),
    ),
  ],
);
