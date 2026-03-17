// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
    };
