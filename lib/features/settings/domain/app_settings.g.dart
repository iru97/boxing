// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppSettingsImpl _$$AppSettingsImplFromJson(Map<String, dynamic> json) =>
    _$AppSettingsImpl(
      defaultWarmupSec: (json['defaultWarmupSec'] as num?)?.toInt() ?? 0,
      defaultWarningSec: (json['defaultWarningSec'] as num?)?.toInt() ?? 10,
      defaultAutoAdvance: json['defaultAutoAdvance'] as bool? ?? true,
      defaultKeepScreenOn: json['defaultKeepScreenOn'] as bool? ?? true,
      resumeCountdown: json['resumeCountdown'] as bool? ?? true,
      defaultSoundPack: json['defaultSoundPack'] as String? ?? 'classic_bell',
      volumeOverride: json['volumeOverride'] as bool? ?? false,
      hapticFeedback: json['hapticFeedback'] as bool? ?? true,
      themeMode: json['themeMode'] as String? ?? 'dark',
      locale: json['locale'] as String? ?? 'system',
      tapToPause: json['tapToPause'] as bool? ?? false,
      isAdFree: json['isAdFree'] as bool? ?? false,
    );

Map<String, dynamic> _$$AppSettingsImplToJson(_$AppSettingsImpl instance) =>
    <String, dynamic>{
      'defaultWarmupSec': instance.defaultWarmupSec,
      'defaultWarningSec': instance.defaultWarningSec,
      'defaultAutoAdvance': instance.defaultAutoAdvance,
      'defaultKeepScreenOn': instance.defaultKeepScreenOn,
      'resumeCountdown': instance.resumeCountdown,
      'defaultSoundPack': instance.defaultSoundPack,
      'volumeOverride': instance.volumeOverride,
      'hapticFeedback': instance.hapticFeedback,
      'themeMode': instance.themeMode,
      'locale': instance.locale,
      'tapToPause': instance.tapToPause,
      'isAdFree': instance.isAdFree,
    };
