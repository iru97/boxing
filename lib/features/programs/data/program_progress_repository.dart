import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:boxing/features/programs/domain/program_progress.dart';

class ProgramProgressRepository {
  final Box<String> _box;

  ProgramProgressRepository(this._box);

  /// Get progress for a specific program.
  ProgramProgress? getProgress(String programId) {
    final json = _box.get(programId);
    if (json == null) return null;
    try {
      return ProgramProgress.fromJson(jsonDecode(json));
    } catch (_) {
      return null;
    }
  }

  /// Save progress for a program.
  Future<void> saveProgress(ProgramProgress progress) async {
    final json = jsonEncode(progress.toJson());
    await _box.put(progress.programId, json);
  }

  /// Delete progress for a program (reset).
  Future<void> deleteProgress(String programId) async {
    await _box.delete(programId);
  }

  /// Get all saved progress entries.
  Map<String, ProgramProgress> getAllProgress() {
    final result = <String, ProgramProgress>{};
    for (final key in _box.keys) {
      final json = _box.get(key as String);
      if (json != null) {
        try {
          result[key] = ProgramProgress.fromJson(jsonDecode(json));
        } catch (_) {
          // Skip corrupted entries
        }
      }
    }
    return result;
  }

  /// Mark a specific day as completed.
  Future<ProgramProgress> completeDay(
    String programId,
    int week,
    int day,
  ) async {
    var progress = getProgress(programId);
    progress ??= ProgramProgress(
      programId: programId,
      startedAt: DateTime.now(),
    );
    final key = 'w${week}d$day';
    if (!progress.completedDays.containsKey(key)) {
      final updated = progress.copyWith(
        completedDays: {...progress.completedDays, key: DateTime.now()},
      );
      await saveProgress(updated);
      return updated;
    }
    return progress;
  }

  /// Start a program (create initial progress if not exists).
  Future<ProgramProgress> startProgram(String programId) async {
    var progress = getProgress(programId);
    if (progress != null) return progress;
    progress = ProgramProgress(
      programId: programId,
      startedAt: DateTime.now(),
    );
    await saveProgress(progress);
    return progress;
  }
}
