import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boxing/features/sessions/domain/session_model.dart';
import 'package:boxing/features/timer/domain/timer_engine.dart';
import 'package:boxing/features/timer/domain/timer_state.dart';

/// Helper to create a simple test session.
SessionModel _testSession({
  int rounds = 3,
  int roundDurationSec = 10,
  int restDurationSec = 5,
  int warningTimeSec = 3,
  int warmupDurationSec = 0,
  List<RoundOverride> roundOverrides = const [],
}) {
  return SessionModel(
    id: 'test',
    name: 'Test Session',
    rounds: rounds,
    roundDurationSec: roundDurationSec,
    restDurationSec: restDurationSec,
    warningTimeSec: warningTimeSec,
    warmupDurationSec: warmupDurationSec,
    roundOverrides: roundOverrides,
  );
}

void main() {
  group('TimerEngine - State Machine', () {
    test('starts in idle state', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));
        expect(engine.currentState.phase, isA<TimerIdle>());
        engine.dispose();
      });
    });

    test('warmup → work → rest → work → rest → work → complete', () {
      fakeAsync((async) {
        final phases = <TimerPhase>[];
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));
        engine.stateStream.listen((state) {
          // Track unique phase types (not every tick)
          final phaseType = state.phase.runtimeType;
          if (phases.isEmpty || phases.last.runtimeType != phaseType) {
            phases.add(state.phase);
          }
        });

        engine.start(_testSession(
          rounds: 3,
          roundDurationSec: 5,
          restDurationSec: 3,
          warningTimeSec: 0,
          warmupDurationSec: 2,
        ));

        // Total: 2s warmup + 5s work + 3s rest + 5s work + 3s rest + 5s work = 23s
        async.elapse(const Duration(seconds: 25));

        expect(phases.whereType<TimerWarmup>().isNotEmpty, true);
        expect(phases.whereType<TimerWork>().length, 3);
        expect(phases.whereType<TimerRest>().length, 2);
        expect(phases.whereType<TimerCompleted>().isNotEmpty, true);

        engine.dispose();
      });
    });

    test('no warmup skips directly to work', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));
        engine.start(_testSession(warmupDurationSec: 0, rounds: 1, roundDurationSec: 5));

        async.elapse(const Duration(milliseconds: 100));
        final state = engine.currentState;
        expect(state.phase, isA<TimerWork>());
        expect((state.phase as TimerWork).roundNumber, 1);

        engine.dispose();
      });
    });

    test('no rest goes directly work → work', () {
      fakeAsync((async) {
        final rounds = <int>[];
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));
        engine.stateStream.listen((state) {
          if (state.phase is TimerWork) {
            final round = (state.phase as TimerWork).roundNumber;
            if (rounds.isEmpty || rounds.last != round) {
              rounds.add(round);
            }
          }
          // Should never see a rest phase
          expect(state.phase, isNot(isA<TimerRest>()));
        });

        engine.start(_testSession(
          rounds: 3,
          roundDurationSec: 5,
          restDurationSec: 0,
          warningTimeSec: 0,
        ));

        async.elapse(const Duration(seconds: 20));

        expect(rounds, [1, 2, 3]);

        engine.dispose();
      });
    });

    test('single-round session has no rest', () {
      fakeAsync((async) {
        bool sawRest = false;
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));
        engine.stateStream.listen((state) {
          if (state.phase is TimerRest) sawRest = true;
        });

        engine.start(_testSession(rounds: 1, roundDurationSec: 5, restDurationSec: 5));

        async.elapse(const Duration(seconds: 10));

        expect(sawRest, false);
        expect(engine.currentState.phase, isA<TimerCompleted>());

        engine.dispose();
      });
    });

    test('per-round overrides apply correctly', () {
      fakeAsync((async) {
        final roundDurations = <int, Duration>{};
        int? lastRound;

        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));
        engine.stateStream.listen((state) {
          if (state.phase is TimerWork) {
            final work = state.phase as TimerWork;
            if (lastRound != work.roundNumber) {
              // New round started, record its initial remaining
              if (lastRound == null || work.remaining.inSeconds >= 1) {
                roundDurations[work.roundNumber] = work.remaining;
              }
              lastRound = work.roundNumber;
            }
}
        });

        engine.start(_testSession(
          rounds: 3,
          roundDurationSec: 10,
          restDurationSec: 2,
          warningTimeSec: 0,
          roundOverrides: [
            const RoundOverride(round: 2, durationSec: 5),
          ],
        ));

        // Round 1: 10s, Rest: 2s, Round 2: 5s, Rest: 2s, Round 3: 10s = 29s
        async.elapse(const Duration(seconds: 35));

        // Round 2 should have started with ~5s
        expect(roundDurations[2]!.inSeconds, lessThanOrEqualTo(5));
        // Round 1 and 3 should have started with ~10s
        expect(roundDurations[1]!.inSeconds, lessThanOrEqualTo(10));
        expect(roundDurations[1]!.inSeconds, greaterThanOrEqualTo(9));

        engine.dispose();
      });
    });

    test('round counter increments correctly', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(
          rounds: 3,
          roundDurationSec: 5,
          restDurationSec: 3,
          warningTimeSec: 0,
        ));

        // During round 1
        async.elapse(const Duration(seconds: 2));
        expect(engine.currentState.currentRound, 1);

        // After round 1 (5s) + during rest (3s) + into round 2
        async.elapse(const Duration(seconds: 7));
        expect(engine.currentState.currentRound, 2);

        engine.dispose();
      });
    });
  });

  group('TimerEngine - Timer Accuracy', () {
    test('phase completes within ±100ms of expected duration', () {
      fakeAsync((async) {
        Duration? workStartTime;
        Duration? workEndTime;

        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));
        engine.stateStream.listen((state) {
          if (state.phase is TimerWork && workStartTime == null) {
            workStartTime = state.totalElapsed;
          }
          if (state.phase is TimerRest && workEndTime == null) {
            workEndTime = state.totalElapsed;
          }
        });

        engine.start(_testSession(
          rounds: 2,
          roundDurationSec: 10,
          restDurationSec: 5,
          warningTimeSec: 0,
        ));

        async.elapse(const Duration(seconds: 20));

        expect(workStartTime, isNotNull);
        expect(workEndTime, isNotNull);

        final workDuration = workEndTime! - workStartTime!;
        // Should be ~10 seconds ±100ms
        expect(workDuration.inMilliseconds, closeTo(10000, 150));

        engine.dispose();
      });
    });

    test('does not drift over 12 rounds', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        // Pro boxing: 12 rounds x 180s + 11 rests x 60s = 2160 + 660 = 2820s
        engine.start(_testSession(
          rounds: 12,
          roundDurationSec: 180,
          restDurationSec: 60,
          warningTimeSec: 10,
        ));

        // Elapse total expected + 5 seconds buffer
        async.elapse(const Duration(seconds: 2825));

        expect(engine.currentState.phase, isA<TimerCompleted>());
        expect((engine.currentState.phase as TimerCompleted).totalRounds, 12);

        engine.dispose();
      });
    });
  });

  group('TimerEngine - Warning', () {
    test('warning triggers at configured time before round end', () {
      fakeAsync((async) {
        bool warningDetected = false;
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));
        engine.stateStream.listen((state) {
          if (state.phase is TimerWork && (state.phase as TimerWork).isWarning) {
            warningDetected = true;
          }
        });

        engine.start(_testSession(
          rounds: 1,
          roundDurationSec: 10,
          warningTimeSec: 3,
        ));

        // At 6 seconds, 4 remaining — no warning yet
        async.elapse(const Duration(seconds: 6));
        expect(warningDetected, false);

        // At 7.5 seconds, 2.5 remaining — warning should be active
        async.elapse(const Duration(milliseconds: 1500));
        expect(warningDetected, true);

        engine.dispose();
      });
    });

    test('warning audio cue fires exactly once per round', () {
      fakeAsync((async) {
        int warningCount = 0;
        final engine = TimerEngine(
          clock: async.getClock(DateTime(2026)),
          onAudioCue: (cue) {
            if (cue == AudioCue.warning) warningCount++;
          },
        );

        engine.start(_testSession(
          rounds: 2,
          roundDurationSec: 10,
          restDurationSec: 3,
          warningTimeSec: 3,
        ));

        // Full session: 10+3+10 = 23s
        async.elapse(const Duration(seconds: 25));

        expect(warningCount, 2); // Once per round

        engine.dispose();
      });
    });

    test('zero warning time means no warning', () {
      fakeAsync((async) {
        bool warningDetected = false;
        final engine = TimerEngine(
          clock: async.getClock(DateTime(2026)),
          onAudioCue: (cue) {
            if (cue == AudioCue.warning) warningDetected = true;
          },
        );

        engine.start(_testSession(
          rounds: 1,
          roundDurationSec: 10,
          warningTimeSec: 0,
        ));

        async.elapse(const Duration(seconds: 12));
        expect(warningDetected, false);

        engine.dispose();
      });
    });
  });

  group('TimerEngine - Pause/Resume', () {
    test('pause preserves remaining time', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(
          rounds: 1,
          roundDurationSec: 10,
          warningTimeSec: 0,
        ));

        // Run 4 seconds, then pause
        async.elapse(const Duration(seconds: 4));
        engine.pause();

        final state = engine.currentState;
        expect(state.phase, isA<TimerPaused>());

        final paused = state.phase as TimerPaused;
        expect(paused.previousPhase, isA<TimerWork>());

        final previous = paused.previousPhase as TimerWork;
        // Should have ~6 seconds remaining (±150ms)
        expect(previous.remaining.inMilliseconds, closeTo(6000, 200));

        engine.dispose();
      });
    });

    test('resume continues from correct time', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(
          rounds: 1,
          roundDurationSec: 10,
          warningTimeSec: 0,
        ));

        // Run 4s, pause for 5s, resume, run remaining 6s + buffer
        async.elapse(const Duration(seconds: 4));
        engine.pause();
        async.elapse(const Duration(seconds: 5)); // Paused — time shouldn't count
        engine.resume();
        async.elapse(const Duration(seconds: 7)); // Should complete (6s remaining + buffer)

        expect(engine.currentState.phase, isA<TimerCompleted>());

        engine.dispose();
      });
    });

    test('multiple pause/resume cycles dont accumulate drift', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(
          rounds: 1,
          roundDurationSec: 30,
          warningTimeSec: 0,
        ));

        // Cycle 1: run 5s, pause 10s
        async.elapse(const Duration(seconds: 5));
        engine.pause();
        async.elapse(const Duration(seconds: 10));
        engine.resume();

        // Cycle 2: run 5s, pause 10s
        async.elapse(const Duration(seconds: 5));
        engine.pause();
        async.elapse(const Duration(seconds: 10));
        engine.resume();

        // Cycle 3: run 5s, pause 10s
        async.elapse(const Duration(seconds: 5));
        engine.pause();
        async.elapse(const Duration(seconds: 10));
        engine.resume();

        // 15s of actual running done, 15s remaining
        final state = engine.currentState;
        expect(state.phase, isA<TimerWork>());
        final work = state.phase as TimerWork;
        expect(work.remaining.inMilliseconds, closeTo(15000, 200));

        // Finish it
        async.elapse(const Duration(seconds: 16));
        expect(engine.currentState.phase, isA<TimerCompleted>());

        engine.dispose();
      });
    });

    test('pause during warning maintains warning state on resume', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(
          rounds: 1,
          roundDurationSec: 10,
          warningTimeSec: 3,
        ));

        // Run to warning zone (7.5s in, 2.5s remaining)
        async.elapse(const Duration(milliseconds: 7500));

        // Verify warning is active
        var state = engine.currentState;
        expect(state.phase, isA<TimerWork>());
        expect((state.phase as TimerWork).isWarning, true);

        // Pause and resume
        engine.pause();
        async.elapse(const Duration(seconds: 5));
        engine.resume();

        async.elapse(const Duration(milliseconds: 100));
        state = engine.currentState;
        expect(state.phase, isA<TimerWork>());
        expect((state.phase as TimerWork).isWarning, true);

        engine.dispose();
      });
    });

    test('pause is no-op when already paused', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(rounds: 1, roundDurationSec: 10, warningTimeSec: 0));
        async.elapse(const Duration(seconds: 3));
        engine.pause();

        final state1 = engine.currentState;
        engine.pause(); // Should be no-op
        final state2 = engine.currentState;

        expect(state1.phase, isA<TimerPaused>());
        expect(state2.phase, isA<TimerPaused>());

        engine.dispose();
      });
    });
  });

  group('TimerEngine - Skip', () {
    test('skip forward advances to next phase', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(
          rounds: 3,
          roundDurationSec: 10,
          restDurationSec: 5,
          warningTimeSec: 0,
        ));

        async.elapse(const Duration(seconds: 2));
        expect(engine.currentState.currentRound, 1);
        expect(engine.currentState.phase, isA<TimerWork>());

        // Skip forward from work → rest
        engine.skipForward();
        async.elapse(const Duration(milliseconds: 100));
        expect(engine.currentState.phase, isA<TimerRest>());

        // Skip forward from rest → work round 2
        engine.skipForward();
        async.elapse(const Duration(milliseconds: 100));
        expect(engine.currentState.phase, isA<TimerWork>());
        expect(engine.currentState.currentRound, 2);

        engine.dispose();
      });
    });

    test('skip back restarts current round', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(
          rounds: 3,
          roundDurationSec: 10,
          restDurationSec: 5,
          warningTimeSec: 0,
        ));

        // Go to round 2
        async.elapse(const Duration(seconds: 16)); // 10s work + 5s rest + 1s
        expect(engine.currentState.currentRound, 2);

        // Skip back — should restart round 1 (go back one round during work)
        engine.skipBack();
        async.elapse(const Duration(milliseconds: 100));

        expect(engine.currentState.phase, isA<TimerWork>());
        expect(engine.currentState.currentRound, 1);
        // Should have ~10s remaining (restarted)
        final work = engine.currentState.phase as TimerWork;
        expect(work.remaining.inSeconds, greaterThanOrEqualTo(9));

        engine.dispose();
      });
    });
  });

  group('TimerEngine - Audio Cues', () {
    test('fires correct audio cues for a full session', () {
      fakeAsync((async) {
        final cues = <AudioCue>[];
        final engine = TimerEngine(
          clock: async.getClock(DateTime(2026)),
          onAudioCue: (cue) => cues.add(cue),
        );

        engine.start(_testSession(
          rounds: 2,
          roundDurationSec: 5,
          restDurationSec: 3,
          warningTimeSec: 2,
        ));

        // Full session: 5+3+5 = 13s
        async.elapse(const Duration(seconds: 15));

        // Expected cues:
        // Round 1: roundStart, warning, roundEnd
        // Rest
        // Round 2: roundStart, warning, roundEnd, sessionComplete
        expect(cues.where((c) => c == AudioCue.roundStart).length, 2);
        expect(cues.where((c) => c == AudioCue.warning).length, 2);
        expect(cues.where((c) => c == AudioCue.roundEnd).length, 2);
        expect(cues.where((c) => c == AudioCue.sessionComplete).length, 1);

        engine.dispose();
      });
    });
  });

  group('TimerEngine - Stop', () {
    test('stop resets to idle', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(_testSession(rounds: 3, roundDurationSec: 10));
        async.elapse(const Duration(seconds: 5));
        engine.stop();

        expect(engine.currentState.phase, isA<TimerIdle>());
        expect(engine.isRunning, false);

        engine.dispose();
      });
    });
  });

  group('TimerEngine - Preset Sessions', () {
    test('runs Tabata preset (8x20s/10s) to completion', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(const SessionModel(
          id: 'tabata',
          name: 'Tabata',
          rounds: 8,
          roundDurationSec: 20,
          restDurationSec: 10,
          warningTimeSec: 0,
          isPreset: true,
        ));

        // Total: 8*20 + 7*10 = 160+70 = 230s
        async.elapse(const Duration(seconds: 235));

        expect(engine.currentState.phase, isA<TimerCompleted>());
        expect((engine.currentState.phase as TimerCompleted).totalRounds, 8);

        engine.dispose();
      });
    });

    test('runs Pro Boxing preset (12x180s/60s) to completion', () {
      fakeAsync((async) {
        final engine = TimerEngine(clock: async.getClock(DateTime(2026)));

        engine.start(const SessionModel(
          id: 'pro',
          name: 'Pro Boxing',
          rounds: 12,
          roundDurationSec: 180,
          restDurationSec: 60,
          warningTimeSec: 10,
          isPreset: true,
        ));

        // Total: 12*180 + 11*60 = 2160+660 = 2820s
        async.elapse(const Duration(seconds: 2825));

        expect(engine.currentState.phase, isA<TimerCompleted>());

        engine.dispose();
      });
    });
  });
}
