import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boxing/features/timer/presentation/widgets/countdown_display.dart';
import 'package:boxing/features/timer/presentation/widgets/progress_ring.dart';
import 'package:boxing/features/timer/presentation/widgets/round_indicator.dart';
import 'package:boxing/features/timer/presentation/widgets/phase_label.dart';
import 'package:boxing/features/timer/presentation/widgets/timer_controls.dart';
import 'package:boxing/core/theme/app_colors.dart';

void main() {
  group('CountdownDisplay', () {
    testWidgets('shows M:SS format for times under 10 minutes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownDisplay(
              remaining: Duration(minutes: 2, seconds: 47),
              color: Colors.green,
            ),
          ),
        ),
      );
      expect(find.text('2:47'), findsOneWidget);
    });

    testWidgets('zero-pads seconds', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownDisplay(
              remaining: Duration(minutes: 1, seconds: 5),
              color: Colors.green,
            ),
          ),
        ),
      );
      expect(find.text('1:05'), findsOneWidget);
    });

    testWidgets('shows 0:00 for zero duration', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownDisplay(
              remaining: Duration.zero,
              color: Colors.white,
            ),
          ),
        ),
      );
      expect(find.text('0:00'), findsOneWidget);
    });

    testWidgets('shows MM:SS format for 10+ minutes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownDisplay(
              remaining: Duration(minutes: 12, seconds: 30),
              color: Colors.green,
            ),
          ),
        ),
      );
      expect(find.text('12:30'), findsOneWidget);
    });
  });

  group('RoundIndicator', () {
    testWidgets('displays correct round text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RoundIndicator(currentRound: 3, totalRounds: 8),
          ),
        ),
      );
      expect(find.text('ROUND 3 / 8'), findsOneWidget);
    });

    testWidgets('displays round 1 of 1', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RoundIndicator(currentRound: 1, totalRounds: 1),
          ),
        ),
      );
      expect(find.text('ROUND 1 / 1'), findsOneWidget);
    });
  });

  group('PhaseLabel', () {
    testWidgets('shows WORK label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhaseLabel(label: 'WORK', color: TimerColors.work),
          ),
        ),
      );
      expect(find.text('WORK'), findsOneWidget);
    });

    testWidgets('shows REST label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PhaseLabel(label: 'REST', color: TimerColors.rest),
          ),
        ),
      );
      expect(find.text('REST'), findsOneWidget);
    });
  });

  group('ProgressRing', () {
    testWidgets('renders without overflow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProgressRing(
                progress: 0.75,
                color: TimerColors.work,
                child: Text('2:15'),
              ),
            ),
          ),
        ),
      );
      expect(find.byType(ProgressRing), findsOneWidget);
      expect(find.text('2:15'), findsOneWidget);
    });

    testWidgets('clamps progress to 0-1 range', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProgressRing(
                progress: 1.5,
                color: TimerColors.work,
              ),
            ),
          ),
        ),
      );
      // Should render without error
      expect(find.byType(ProgressRing), findsOneWidget);
    });
  });

  group('TimerControls', () {
    testWidgets('shows pause icon when running', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerControls(
              isPaused: false,
              accentColor: TimerColors.work,
              onPauseResume: () {},
              onSkipBack: () {},
              onSkipForward: () {},
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow_rounded), findsNothing);
    });

    testWidgets('shows play icon when paused', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerControls(
              isPaused: true,
              accentColor: TimerColors.paused,
              onPauseResume: () {},
              onSkipBack: () {},
              onSkipForward: () {},
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
      expect(find.byIcon(Icons.pause_rounded), findsNothing);
    });

    testWidgets('has skip back and forward icons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerControls(
              isPaused: false,
              accentColor: TimerColors.work,
              onPauseResume: () {},
              onSkipBack: () {},
              onSkipForward: () {},
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.skip_previous_rounded), findsOneWidget);
      expect(find.byIcon(Icons.skip_next_rounded), findsOneWidget);
    });

    testWidgets('pause/resume callback fires on tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerControls(
              isPaused: false,
              accentColor: TimerColors.work,
              onPauseResume: () => tapped = true,
              onSkipBack: () {},
              onSkipForward: () {},
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.pause_rounded));
      expect(tapped, isTrue);
    });

    testWidgets('skip forward callback fires on tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerControls(
              isPaused: false,
              accentColor: TimerColors.work,
              onPauseResume: () {},
              onSkipBack: () {},
              onSkipForward: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.skip_next_rounded));
      expect(tapped, isTrue);
    });

    testWidgets('skip back callback fires on tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerControls(
              isPaused: false,
              accentColor: TimerColors.work,
              onPauseResume: () {},
              onSkipBack: () => tapped = true,
              onSkipForward: () {},
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.skip_previous_rounded));
      expect(tapped, isTrue);
    });

    testWidgets('all touch targets are at least 64dp', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimerControls(
              isPaused: false,
              accentColor: TimerColors.work,
              onPauseResume: () {},
              onSkipBack: () {},
              onSkipForward: () {},
            ),
          ),
        ),
      );
      // Center button should be 80dp
      final pauseButton = tester.getSize(
        find.ancestor(
          of: find.byIcon(Icons.pause_rounded),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(pauseButton.width, greaterThanOrEqualTo(80));
      expect(pauseButton.height, greaterThanOrEqualTo(80));

      // Skip buttons should be 64dp
      final skipButton = tester.getSize(
        find.ancestor(
          of: find.byIcon(Icons.skip_next_rounded),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(skipButton.width, greaterThanOrEqualTo(64));
      expect(skipButton.height, greaterThanOrEqualTo(64));
    });
  });

  group('Phase color mapping', () {
    test('all phase colors are defined', () {
      expect(TimerColors.work, isNotNull);
      expect(TimerColors.warning, isNotNull);
      expect(TimerColors.rest, isNotNull);
      expect(TimerColors.warmup, isNotNull);
      expect(TimerColors.complete, isNotNull);
      expect(TimerColors.idle, isNotNull);
      expect(TimerColors.paused, isNotNull);
    });

    test('phase colors are distinct', () {
      final colors = [
        TimerColors.work,
        TimerColors.warning,
        TimerColors.rest,
        TimerColors.warmup,
        TimerColors.idle,
      ];
      expect(colors.toSet().length, equals(colors.length));
    });
  });
}
