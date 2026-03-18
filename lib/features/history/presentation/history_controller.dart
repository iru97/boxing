import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:boxing/features/history/data/history_repository.dart';
import 'package:boxing/features/history/domain/training_record.dart';

/// Hive box provider for history (overridden in main.dart).
final historyBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('historyBoxProvider must be overridden');
});

/// Provides the HistoryRepository backed by Hive.
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final box = ref.watch(historyBoxProvider);
  return HistoryRepository(box);
});

/// Invalidation counter — increment to refresh history list.
final _historyInvalidator = StateProvider<int>((ref) => 0);

/// All training records, sorted by date descending.
final historyListProvider = Provider<List<TrainingRecord>>((ref) {
  ref.watch(_historyInvalidator);
  return ref.watch(historyRepositoryProvider).getAll();
});

/// Controller for history CRUD operations.
final historyControllerProvider =
    Provider<HistoryController>((ref) => HistoryController(ref));

class HistoryController {
  final Ref _ref;

  HistoryController(this._ref);

  HistoryRepository get _repo => _ref.read(historyRepositoryProvider);

  Future<void> addRecord({
    required String sessionId,
    required String sessionName,
    required int durationCompletedSec,
    required int roundsCompleted,
    required int totalRounds,
    required bool completedFully,
  }) async {
    await _repo.addRecord(
      sessionId: sessionId,
      sessionName: sessionName,
      durationCompletedSec: durationCompletedSec,
      roundsCompleted: roundsCompleted,
      totalRounds: totalRounds,
      completedFully: completedFully,
    );
    _invalidate();
  }

  Future<void> deleteRecord(String id) async {
    await _repo.delete(id);
    _invalidate();
  }

  Future<void> clearAll() async {
    await _repo.deleteAll();
    _invalidate();
  }

  void _invalidate() {
    _ref.read(_historyInvalidator.notifier).state++;
  }
}
