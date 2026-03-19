import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'package:boxing/features/programs/data/program_library.dart';
import 'package:boxing/features/programs/data/program_progress_repository.dart';
import 'package:boxing/features/programs/domain/program_progress.dart';
import 'package:boxing/features/programs/domain/training_program.dart';

/// Hive box provider for program progress (overridden in main.dart).
final programProgressBoxProvider = Provider<Box<String>>((ref) {
  throw UnimplementedError('programProgressBoxProvider must be overridden');
});

/// Provides the ProgramProgressRepository backed by Hive.
final programProgressRepositoryProvider =
    Provider<ProgramProgressRepository>((ref) {
  final box = ref.watch(programProgressBoxProvider);
  return ProgramProgressRepository(box);
});

/// All available training programs.
final allProgramsProvider = Provider<List<TrainingProgram>>((ref) {
  return ProgramLibrary.all;
});

/// Lookup a program by ID.
final programByIdProvider =
    Provider.family<TrainingProgram?, String>((ref, id) {
  return ProgramLibrary.byId(id);
});

/// Invalidation counter for progress data.
final _progressInvalidator = StateProvider<int>((ref) => 0);

/// Progress for a specific program.
final programProgressProvider =
    Provider.family<ProgramProgress?, String>((ref, programId) {
  ref.watch(_progressInvalidator);
  return ref.watch(programProgressRepositoryProvider).getProgress(programId);
});

/// All programs that have been started (have progress).
final activeProgramsProvider =
    Provider<List<(TrainingProgram, ProgramProgress)>>((ref) {
  ref.watch(_progressInvalidator);
  final repo = ref.watch(programProgressRepositoryProvider);
  final allProgress = repo.getAllProgress();
  final programs = ProgramLibrary.all;

  final result = <(TrainingProgram, ProgramProgress)>[];
  for (final entry in allProgress.entries) {
    final program =
        programs.where((p) => p.id == entry.key).firstOrNull;
    if (program != null) {
      // Only include if not fully completed
      if (!entry.value.isFullyComplete(program.totalDays)) {
        result.add((program, entry.value));
      }
    }
  }
  return result;
});

/// Controller for program progress operations.
final programsControllerProvider =
    Provider<ProgramsController>((ref) => ProgramsController(ref));

class ProgramsController {
  final Ref _ref;

  ProgramsController(this._ref);

  ProgramProgressRepository get _repo =>
      _ref.read(programProgressRepositoryProvider);

  Future<ProgramProgress> startProgram(String programId) async {
    final progress = await _repo.startProgram(programId);
    _invalidate();
    return progress;
  }

  Future<ProgramProgress> completeDay(
    String programId,
    int week,
    int day,
  ) async {
    final progress = await _repo.completeDay(programId, week, day);
    _invalidate();
    return progress;
  }

  Future<void> resetProgress(String programId) async {
    await _repo.deleteProgress(programId);
    _invalidate();
  }

  /// Find the next incomplete day in a program.
  /// Returns (weekNumber, dayNumber) or null if all complete.
  (int, int)? nextIncompleteDay(
    TrainingProgram program,
    ProgramProgress? progress,
  ) {
    if (progress == null) return (1, 1);
    for (final week in program.weeks) {
      for (final day in week.days) {
        if (!progress.isDayComplete(week.weekNumber, day.dayNumber)) {
          return (week.weekNumber, day.dayNumber);
        }
      }
    }
    return null;
  }

  void _invalidate() {
    _ref.read(_progressInvalidator.notifier).state++;
  }
}
