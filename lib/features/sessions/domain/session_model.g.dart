// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoundSegmentImpl _$$RoundSegmentImplFromJson(Map<String, dynamic> json) =>
    _$RoundSegmentImpl(
      label: json['label'] as String,
      durationSec: (json['durationSec'] as num).toInt(),
      audioCue: json['audioCue'] as String? ?? '',
      color: json['color'] as String? ?? 'work',
    );

Map<String, dynamic> _$$RoundSegmentImplToJson(_$RoundSegmentImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'durationSec': instance.durationSec,
      'audioCue': instance.audioCue,
      'color': instance.color,
    };

_$RoundTemplateImpl _$$RoundTemplateImplFromJson(Map<String, dynamic> json) =>
    _$RoundTemplateImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      segments:
          (json['segments'] as List<dynamic>)
              .map((e) => RoundSegment.fromJson(e as Map<String, dynamic>))
              .toList(),
      repeatCount: (json['repeatCount'] as num?)?.toInt() ?? 1,
      isPreset: json['isPreset'] as bool? ?? false,
    );

Map<String, dynamic> _$$RoundTemplateImplToJson(_$RoundTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'segments': instance.segments,
      'repeatCount': instance.repeatCount,
      'isPreset': instance.isPreset,
    };

_$RoundOverrideImpl _$$RoundOverrideImplFromJson(Map<String, dynamic> json) =>
    _$RoundOverrideImpl(
      round: (json['round'] as num).toInt(),
      durationSec: (json['durationSec'] as num).toInt(),
    );

Map<String, dynamic> _$$RoundOverrideImplToJson(_$RoundOverrideImpl instance) =>
    <String, dynamic>{
      'round': instance.round,
      'durationSec': instance.durationSec,
    };

_$SessionModelImpl _$$SessionModelImplFromJson(Map<String, dynamic> json) =>
    _$SessionModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      rounds: (json['rounds'] as num).toInt(),
      roundDurationSec: (json['roundDurationSec'] as num).toInt(),
      restDurationSec: (json['restDurationSec'] as num).toInt(),
      warningTimeSec: (json['warningTimeSec'] as num?)?.toInt() ?? 10,
      warmupDurationSec: (json['warmupDurationSec'] as num?)?.toInt() ?? 0,
      autoAdvance: json['autoAdvance'] as bool? ?? true,
      keepScreenOn: json['keepScreenOn'] as bool? ?? true,
      voiceAnnounce: json['voiceAnnounce'] as bool? ?? false,
      volumeOverride: json['volumeOverride'] as bool? ?? false,
      soundPack: json['soundPack'] as String? ?? 'classic_bell',
      roundOverrides:
          (json['roundOverrides'] as List<dynamic>?)
              ?.map((e) => RoundOverride.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isPreset: json['isPreset'] as bool? ?? false,
      roundTemplate:
          json['roundTemplate'] == null
              ? null
              : RoundTemplate.fromJson(
                json['roundTemplate'] as Map<String, dynamic>,
              ),
      roundTemplateOverrides:
          (json['roundTemplateOverrides'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              int.parse(k),
              RoundTemplate.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const {},
      sport: json['sport'] as String? ?? null,
      category: json['category'] as String? ?? null,
      comboConfig:
          json['comboConfig'] == null
              ? null
              : ComboCalloutConfig.fromJson(
                json['comboConfig'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$$SessionModelImplToJson(_$SessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rounds': instance.rounds,
      'roundDurationSec': instance.roundDurationSec,
      'restDurationSec': instance.restDurationSec,
      'warningTimeSec': instance.warningTimeSec,
      'warmupDurationSec': instance.warmupDurationSec,
      'autoAdvance': instance.autoAdvance,
      'keepScreenOn': instance.keepScreenOn,
      'voiceAnnounce': instance.voiceAnnounce,
      'volumeOverride': instance.volumeOverride,
      'soundPack': instance.soundPack,
      'roundOverrides': instance.roundOverrides,
      'isPreset': instance.isPreset,
      'roundTemplate': instance.roundTemplate,
      'roundTemplateOverrides': instance.roundTemplateOverrides.map(
        (k, e) => MapEntry(k.toString(), e),
      ),
      'sport': instance.sport,
      'category': instance.category,
      'comboConfig': instance.comboConfig,
    };
