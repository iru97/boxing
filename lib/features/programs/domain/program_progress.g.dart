// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgramProgressImpl _$$ProgramProgressImplFromJson(
  Map<String, dynamic> json,
) => _$ProgramProgressImpl(
  programId: json['programId'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  completedDays:
      (json['completedDays'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, DateTime.parse(e as String)),
      ) ??
      const {},
);

Map<String, dynamic> _$$ProgramProgressImplToJson(
  _$ProgramProgressImpl instance,
) => <String, dynamic>{
  'programId': instance.programId,
  'startedAt': instance.startedAt.toIso8601String(),
  'completedDays': instance.completedDays.map(
    (k, e) => MapEntry(k, e.toIso8601String()),
  ),
};
