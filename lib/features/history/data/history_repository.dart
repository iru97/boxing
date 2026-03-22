import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import 'package:boxing/features/history/domain/training_record.dart';

class HistoryRepository {
  final Box<String> _box;
  static const _uuid = Uuid();

  HistoryRepository(this._box);

  /// All training records, sorted by date descending (newest first).
  List<TrainingRecord> getAll() {
    final records = <TrainingRecord>[];
    for (final key in _box.keys) {
      final json = _box.get(key);
      if (json != null) {
        try {
          records.add(TrainingRecord.fromJson(jsonDecode(json)));
        } catch (_) {
          // Skip corrupted entries
        }
      }
    }
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  /// Save a training record.
  Future<void> save(TrainingRecord record) async {
    final json = jsonEncode(record.toJson());
    await _box.put(record.id, json);
  }

  /// Delete a single training record.
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  /// Delete all training records.
  Future<void> deleteAll() async {
    await _box.clear();
  }

  /// Factory method to create and save a new record.
  Future<TrainingRecord> addRecord({
    required String sessionId,
    required String sessionName,
    required int durationCompletedSec,
    required int roundsCompleted,
    required int totalRounds,
    required bool completedFully,
    int? combosCompleted,
    String? comboDifficulty,
    String? comboSport,
  }) async {
    final record = TrainingRecord(
      id: _uuid.v4(),
      sessionId: sessionId,
      sessionName: sessionName,
      date: DateTime.now(),
      durationCompletedSec: durationCompletedSec,
      roundsCompleted: roundsCompleted,
      totalRounds: totalRounds,
      completedFully: completedFully,
      combosCompleted: combosCompleted,
      comboDifficulty: comboDifficulty,
      comboSport: comboSport,
    );
    await save(record);
    return record;
  }
}
