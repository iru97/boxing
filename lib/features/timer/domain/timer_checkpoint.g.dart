// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_checkpoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TimerCheckpointImpl _$$TimerCheckpointImplFromJson(
  Map<String, dynamic> json,
) => _$TimerCheckpointImpl(
  sessionId: json['sessionId'] as String,
  sessionJson: json['sessionJson'] as String,
  enginePhase: json['enginePhase'] as String,
  currentRound: (json['currentRound'] as num).toInt(),
  currentSegmentIndex: (json['currentSegmentIndex'] as num).toInt(),
  phaseRemainingMs: (json['phaseRemainingMs'] as num).toInt(),
  phaseDurationMs: (json['phaseDurationMs'] as num).toInt(),
  totalElapsedSec: (json['totalElapsedSec'] as num).toInt(),
  warningFired: json['warningFired'] as bool,
  waitingForAdvance: json['waitingForAdvance'] as bool,
  checkpointTimestampMs: (json['checkpointTimestampMs'] as num).toInt(),
  wasPaused: json['wasPaused'] as bool,
  sessionName: json['sessionName'] as String,
);

Map<String, dynamic> _$$TimerCheckpointImplToJson(
  _$TimerCheckpointImpl instance,
) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'sessionJson': instance.sessionJson,
  'enginePhase': instance.enginePhase,
  'currentRound': instance.currentRound,
  'currentSegmentIndex': instance.currentSegmentIndex,
  'phaseRemainingMs': instance.phaseRemainingMs,
  'phaseDurationMs': instance.phaseDurationMs,
  'totalElapsedSec': instance.totalElapsedSec,
  'warningFired': instance.warningFired,
  'waitingForAdvance': instance.waitingForAdvance,
  'checkpointTimestampMs': instance.checkpointTimestampMs,
  'wasPaused': instance.wasPaused,
  'sessionName': instance.sessionName,
};
