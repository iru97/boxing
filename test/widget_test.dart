import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:boxing/core/constants/preset_sessions.dart';
import 'package:boxing/core/utils/duration_formatter.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

void main() {
  group('SessionModel', () {
    test('creates with required fields', () {
      const session = SessionModel(
        id: 'test',
        name: 'Test Session',
        rounds: 3,
        roundDurationSec: 180,
        restDurationSec: 60,
      );

      expect(session.id, 'test');
      expect(session.name, 'Test Session');
      expect(session.rounds, 3);
      expect(session.roundDurationSec, 180);
      expect(session.restDurationSec, 60);
      expect(session.warningTimeSec, 10);
      expect(session.isPreset, false);
    });

    test('copyWith works correctly', () {
      const session = SessionModel(
        id: 'test',
        name: 'Original',
        rounds: 3,
        roundDurationSec: 180,
        restDurationSec: 60,
      );

      final modified = session.copyWith(name: 'Modified', rounds: 5);
      expect(modified.name, 'Modified');
      expect(modified.rounds, 5);
      expect(modified.roundDurationSec, 180);
    });

    test('equality works', () {
      const a = SessionModel(
        id: 'test',
        name: 'Test',
        rounds: 3,
        roundDurationSec: 180,
        restDurationSec: 60,
      );
      const b = SessionModel(
        id: 'test',
        name: 'Test',
        rounds: 3,
        roundDurationSec: 180,
        restDurationSec: 60,
      );

      expect(a, equals(b));
    });

    test('JSON serialization roundtrip', () {
      const session = SessionModel(
        id: 'test',
        name: 'Test Session',
        rounds: 8,
        roundDurationSec: 180,
        restDurationSec: 60,
        warningTimeSec: 15,
        warmupDurationSec: 10,
        soundPack: 'digital_buzzer',
        roundOverrides: [RoundOverride(round: 3, durationSec: 120)],
      );

      // Simulate real Hive storage: encode to JSON string, decode back
      final jsonString = jsonEncode(session.toJson());
      final restored = SessionModel.fromJson(
          jsonDecode(jsonString) as Map<String, dynamic>);
      expect(restored, equals(session));
    });

    test('duration extensions work', () {
      const session = SessionModel(
        id: 'test',
        name: 'Test',
        rounds: 3,
        roundDurationSec: 180,
        restDurationSec: 60,
        warningTimeSec: 10,
        warmupDurationSec: 5,
      );

      expect(session.roundDuration, const Duration(seconds: 180));
      expect(session.restDuration, const Duration(seconds: 60));
      expect(session.warningTime, const Duration(seconds: 10));
      expect(session.warmupDuration, const Duration(seconds: 5));
    });

    test('totalDuration calculates correctly', () {
      const session = SessionModel(
        id: 'test',
        name: 'Test',
        rounds: 3,
        roundDurationSec: 180,
        restDurationSec: 60,
        warmupDurationSec: 10,
      );

      // 10 warmup + 3*180 work + 2*60 rest = 10 + 540 + 120 = 670
      expect(session.totalDuration, const Duration(seconds: 670));
    });

    test('durationForRound respects overrides', () {
      const session = SessionModel(
        id: 'test',
        name: 'Test',
        rounds: 5,
        roundDurationSec: 180,
        restDurationSec: 60,
        roundOverrides: [
          RoundOverride(round: 3, durationSec: 120),
          RoundOverride(round: 5, durationSec: 240),
        ],
      );

      expect(session.durationForRound(1), 180);
      expect(session.durationForRound(3), 120);
      expect(session.durationForRound(5), 240);
    });
  });

  group('PresetSessions', () {
    test('has 20 presets', () {
      expect(PresetSessions.all.length, 20);
    });

    test('all presets are marked as preset', () {
      for (final preset in PresetSessions.all) {
        expect(preset.isPreset, true, reason: '${preset.name} should be preset');
      }
    });

    test('all presets have unique IDs', () {
      final ids = PresetSessions.all.map((s) => s.id).toSet();
      expect(ids.length, PresetSessions.all.length);
    });

    test('all presets have valid durations', () {
      for (final preset in PresetSessions.all) {
        expect(preset.rounds, greaterThan(0),
            reason: '${preset.name} rounds > 0');
        expect(preset.roundDurationSec, greaterThanOrEqualTo(15),
            reason: '${preset.name} round >= 15s');
        expect(preset.restDurationSec, greaterThanOrEqualTo(0),
            reason: '${preset.name} rest >= 0');
      }
    });
  });

  group('DurationFormatter', () {
    test('formats seconds correctly', () {
      expect(DurationFormatter.format(const Duration(seconds: 180)), '3:00');
      expect(DurationFormatter.format(const Duration(seconds: 90)), '1:30');
      expect(DurationFormatter.format(const Duration(seconds: 5)), '0:05');
      expect(DurationFormatter.format(const Duration(seconds: 0)), '0:00');
      expect(DurationFormatter.format(const Duration(seconds: 601)), '10:01');
    });

    test('formatSeconds works', () {
      expect(DurationFormatter.formatSeconds(180), '3:00');
      expect(DurationFormatter.formatSeconds(65), '1:05');
    });
  });
}
