import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_progress.freezed.dart';
part 'program_progress.g.dart';

@freezed
class ProgramProgress with _$ProgramProgress {
  const ProgramProgress._();

  const factory ProgramProgress({
    required String programId,
    required DateTime startedAt,
    @Default({}) Map<String, DateTime> completedDays,
  }) = _ProgramProgress;

  factory ProgramProgress.fromJson(Map<String, dynamic> json) =>
      _$ProgramProgressFromJson(json);

  bool isDayComplete(int week, int day) =>
      completedDays.containsKey('w${week}d$day');

  double completionPercentage(int totalDays) {
    if (totalDays == 0) return 0;
    return completedDays.length / totalDays;
  }

  bool isFullyComplete(int totalDays) =>
      totalDays > 0 && completedDays.length >= totalDays;
}
