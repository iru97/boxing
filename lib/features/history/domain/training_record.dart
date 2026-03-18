import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_record.freezed.dart';
part 'training_record.g.dart';

@freezed
class TrainingRecord with _$TrainingRecord {
  const factory TrainingRecord({
    required String id,
    required String sessionId,
    required String sessionName,
    required DateTime date,
    required int durationCompletedSec,
    required int roundsCompleted,
    required int totalRounds,
    @Default(true) bool completedFully,
  }) = _TrainingRecord;

  factory TrainingRecord.fromJson(Map<String, dynamic> json) =>
      _$TrainingRecordFromJson(json);
}
