import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:boxing/features/timer/domain/timer_checkpoint.dart';

/// Persists the active timer checkpoint to Hive.
/// Single-key design — at most one active checkpoint at any time.
class CheckpointRepository {
  final Box<String> _box;
  static const _key = 'active_checkpoint';

  CheckpointRepository(this._box);

  TimerCheckpoint? get() {
    final json = _box.get(_key);
    if (json == null) return null;
    try {
      return TimerCheckpoint.fromJson(jsonDecode(json));
    } catch (_) {
      return null;
    }
  }

  Future<void> save(TimerCheckpoint checkpoint) async {
    await _box.put(_key, jsonEncode(checkpoint.toJson()));
  }

  Future<void> clear() async {
    await _box.delete(_key);
  }

  bool get hasCheckpoint => _box.containsKey(_key);
}
