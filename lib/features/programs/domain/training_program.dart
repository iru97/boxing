import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

part 'training_program.freezed.dart';
part 'training_program.g.dart';

@freezed
class ProgramDay with _$ProgramDay {
  const factory ProgramDay({
    required int dayNumber,
    required String name,
    required String description,
    required SessionModel session,
  }) = _ProgramDay;

  factory ProgramDay.fromJson(Map<String, dynamic> json) =>
      _$ProgramDayFromJson(json);
}

@freezed
class ProgramWeek with _$ProgramWeek {
  const factory ProgramWeek({
    required int weekNumber,
    required String name,
    required String description,
    required List<ProgramDay> days,
  }) = _ProgramWeek;

  factory ProgramWeek.fromJson(Map<String, dynamic> json) =>
      _$ProgramWeekFromJson(json);
}

@freezed
class TrainingProgram with _$TrainingProgram {
  const factory TrainingProgram({
    required String id,
    required String name,
    required String description,
    required String sport,
    required String difficulty,
    required int durationWeeks,
    required List<ProgramWeek> weeks,
    @Default(true) bool isPreset,
  }) = _TrainingProgram;

  factory TrainingProgram.fromJson(Map<String, dynamic> json) =>
      _$TrainingProgramFromJson(json);
}

extension TrainingProgramX on TrainingProgram {
  int get totalDays =>
      weeks.fold(0, (acc, week) => acc + week.days.length);

  ProgramDay? dayAt(int week, int day) {
    if (week < 1 || week > weeks.length) return null;
    final w = weeks[week - 1];
    if (day < 1 || day > w.days.length) return null;
    return w.days[day - 1];
  }
}
