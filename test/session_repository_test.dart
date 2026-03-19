import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:boxing/core/constants/preset_sessions.dart';
import 'package:boxing/features/sessions/data/session_repository.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

/// In-memory Hive box for testing.
class _FakeBox implements Box<String> {
  final Map<String, String> _data = {};

  @override
  String? get(dynamic key, {String? defaultValue}) =>
      _data[key] ?? defaultValue;

  @override
  Future<void> put(dynamic key, String value) async {
    _data[key.toString()] = value;
  }

  @override
  Future<void> delete(dynamic key) async {
    _data.remove(key.toString());
  }

  @override
  Iterable<dynamic> get keys => _data.keys;

  @override
  int get length => _data.length;

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  // Unused overrides
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  late _FakeBox box;
  late SessionRepository repo;

  setUp(() {
    box = _FakeBox();
    repo = SessionRepository(box);
  });

  group('SessionRepository - Presets', () {
    test('getAllPresets returns 70 presets', () {
      final presets = repo.getAllPresets();
      expect(presets.length, 70);
      expect(presets.every((s) => s.isPreset), isTrue);
    });

    test('getAll returns presets when no custom sessions exist', () {
      final all = repo.getAll();
      expect(all.length, 70);
    });

    test('getById finds preset by ID', () {
      final session = repo.getById('preset_boxing_pro_men');
      expect(session, isNotNull);
      expect(session!.name, 'Pro Boxing (Men)');
    });

    test('deleteSession returns false for presets', () async {
      final result = await repo.deleteSession('preset_boxing_pro_men');
      expect(result, isFalse);
    });
  });

  group('SessionRepository - CRUD', () {
    final testSession = const SessionModel(
      id: 'test_session_1',
      name: 'Test Session',
      rounds: 5,
      roundDurationSec: 180,
      restDurationSec: 60,
      isPreset: false,
    );

    test('saveSession persists a session', () async {
      await repo.saveSession(testSession);
      final loaded = repo.getById('test_session_1');
      expect(loaded, isNotNull);
      expect(loaded!.name, 'Test Session');
      expect(loaded.rounds, 5);
    });

    test('getCustomSessions returns saved sessions', () async {
      await repo.saveSession(testSession);
      final custom = repo.getCustomSessions();
      expect(custom.length, 1);
      expect(custom.first.id, 'test_session_1');
    });

    test('getAll includes both presets and custom', () async {
      await repo.saveSession(testSession);
      final all = repo.getAll();
      expect(all.length, 71); // 70 presets + 1 custom
    });

    test('saveSession overwrites existing session', () async {
      await repo.saveSession(testSession);
      final updated = testSession.copyWith(name: 'Updated Name');
      await repo.saveSession(updated);
      final loaded = repo.getById('test_session_1');
      expect(loaded!.name, 'Updated Name');
    });

    test('deleteSession removes custom session', () async {
      await repo.saveSession(testSession);
      expect(repo.getCustomSessions().length, 1);
      final result = await repo.deleteSession('test_session_1');
      expect(result, isTrue);
      expect(repo.getCustomSessions().length, 0);
    });

    test('deleteSession returns true for non-existent custom ID', () async {
      final result = await repo.deleteSession('nonexistent');
      expect(result, isTrue); // No error, just no-op
    });

    test('getById returns null for unknown ID', () {
      final session = repo.getById('unknown_id');
      expect(session, isNull);
    });
  });

  group('SessionRepository - Duplicate', () {
    test('duplicateSession creates copy with new ID', () async {
      final original = PresetSessions.all.first;
      final duplicate = await repo.duplicateSession(original);

      expect(duplicate.id, isNot(original.id));
      expect(duplicate.name, '${original.name} (copy)');
      expect(duplicate.rounds, original.rounds);
      expect(duplicate.roundDurationSec, original.roundDurationSec);
      expect(duplicate.isPreset, isFalse);
    });

    test('duplicated session is persisted', () async {
      final original = PresetSessions.all.first;
      final duplicate = await repo.duplicateSession(original);

      final loaded = repo.getById(duplicate.id);
      expect(loaded, isNotNull);
      expect(loaded!.name, duplicate.name);
    });
  });

  group('SessionRepository - Serialization', () {
    test('roundtrip: Session → JSON → Session', () {
      final session = const SessionModel(
        id: 'roundtrip_test',
        name: 'Roundtrip',
        rounds: 8,
        roundDurationSec: 180,
        restDurationSec: 60,
        warningTimeSec: 15,
        warmupDurationSec: 10,
        autoAdvance: false,
        keepScreenOn: false,
        voiceAnnounce: true,
        volumeOverride: true,
        soundPack: 'digital_buzzer',
        roundOverrides: [RoundOverride(round: 3, durationSec: 120)],
        isPreset: false,
      );

      final json = jsonEncode(session.toJson());
      final restored = SessionModel.fromJson(jsonDecode(json));

      expect(restored.id, session.id);
      expect(restored.name, session.name);
      expect(restored.rounds, session.rounds);
      expect(restored.roundDurationSec, session.roundDurationSec);
      expect(restored.restDurationSec, session.restDurationSec);
      expect(restored.warningTimeSec, session.warningTimeSec);
      expect(restored.warmupDurationSec, session.warmupDurationSec);
      expect(restored.autoAdvance, session.autoAdvance);
      expect(restored.keepScreenOn, session.keepScreenOn);
      expect(restored.voiceAnnounce, session.voiceAnnounce);
      expect(restored.volumeOverride, session.volumeOverride);
      expect(restored.soundPack, session.soundPack);
      expect(restored.roundOverrides.length, 1);
      expect(restored.roundOverrides.first.round, 3);
      expect(restored.roundOverrides.first.durationSec, 120);
      expect(restored.isPreset, session.isPreset);
    });

    test('handles corrupted JSON gracefully', () async {
      await box.put('bad_data', 'not valid json');
      final sessions = repo.getCustomSessions();
      expect(sessions, isEmpty); // Corrupted entry skipped
    });
  });

  group('Session validation logic', () {
    test('totalDuration is correct with warmup and rest', () {
      const session = SessionModel(
        id: 'val_1',
        name: 'Validate',
        rounds: 3,
        roundDurationSec: 180,
        restDurationSec: 60,
        warmupDurationSec: 15,
      );
      // warmup(15) + round1(180) + rest(60) + round2(180) + rest(60) + round3(180)
      expect(session.totalDuration.inSeconds, 675);
    });

    test('totalDuration with no rest', () {
      const session = SessionModel(
        id: 'val_2',
        name: 'No Rest',
        rounds: 3,
        roundDurationSec: 60,
        restDurationSec: 0,
      );
      expect(session.totalDuration.inSeconds, 180);
    });

    test('durationForRound returns override when present', () {
      const session = SessionModel(
        id: 'val_3',
        name: 'Overrides',
        rounds: 3,
        roundDurationSec: 180,
        restDurationSec: 60,
        roundOverrides: [RoundOverride(round: 2, durationSec: 120)],
      );
      expect(session.durationForRound(1), 180);
      expect(session.durationForRound(2), 120);
      expect(session.durationForRound(3), 180);
    });
  });
}
