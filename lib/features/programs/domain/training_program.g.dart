// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_program.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProgramDayImpl _$$ProgramDayImplFromJson(Map<String, dynamic> json) =>
    _$ProgramDayImpl(
      dayNumber: (json['dayNumber'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      session: SessionModel.fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProgramDayImplToJson(_$ProgramDayImpl instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'name': instance.name,
      'description': instance.description,
      'session': instance.session,
    };

_$ProgramWeekImpl _$$ProgramWeekImplFromJson(Map<String, dynamic> json) =>
    _$ProgramWeekImpl(
      weekNumber: (json['weekNumber'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      days:
          (json['days'] as List<dynamic>)
              .map((e) => ProgramDay.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$ProgramWeekImplToJson(_$ProgramWeekImpl instance) =>
    <String, dynamic>{
      'weekNumber': instance.weekNumber,
      'name': instance.name,
      'description': instance.description,
      'days': instance.days,
    };

_$TrainingProgramImpl _$$TrainingProgramImplFromJson(
  Map<String, dynamic> json,
) => _$TrainingProgramImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  sport: json['sport'] as String,
  difficulty: json['difficulty'] as String,
  durationWeeks: (json['durationWeeks'] as num).toInt(),
  weeks:
      (json['weeks'] as List<dynamic>)
          .map((e) => ProgramWeek.fromJson(e as Map<String, dynamic>))
          .toList(),
  isPreset: json['isPreset'] as bool? ?? true,
);

Map<String, dynamic> _$$TrainingProgramImplToJson(
  _$TrainingProgramImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'sport': instance.sport,
  'difficulty': instance.difficulty,
  'durationWeeks': instance.durationWeeks,
  'weeks': instance.weeks,
  'isPreset': instance.isPreset,
};
