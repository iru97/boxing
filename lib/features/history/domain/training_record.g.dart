// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrainingRecordImpl _$$TrainingRecordImplFromJson(Map<String, dynamic> json) =>
    _$TrainingRecordImpl(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      sessionName: json['sessionName'] as String,
      date: DateTime.parse(json['date'] as String),
      durationCompletedSec: (json['durationCompletedSec'] as num).toInt(),
      roundsCompleted: (json['roundsCompleted'] as num).toInt(),
      totalRounds: (json['totalRounds'] as num).toInt(),
      completedFully: json['completedFully'] as bool? ?? true,
      combosCompleted: (json['combosCompleted'] as num?)?.toInt(),
      comboDifficulty: json['comboDifficulty'] as String?,
      comboSport: json['comboSport'] as String?,
    );

Map<String, dynamic> _$$TrainingRecordImplToJson(
  _$TrainingRecordImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'sessionId': instance.sessionId,
  'sessionName': instance.sessionName,
  'date': instance.date.toIso8601String(),
  'durationCompletedSec': instance.durationCompletedSec,
  'roundsCompleted': instance.roundsCompleted,
  'totalRounds': instance.totalRounds,
  'completedFully': instance.completedFully,
  'combosCompleted': instance.combosCompleted,
  'comboDifficulty': instance.comboDifficulty,
  'comboSport': instance.comboSport,
};
