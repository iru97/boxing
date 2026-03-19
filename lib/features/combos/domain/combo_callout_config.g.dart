// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_callout_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComboCalloutConfigImpl _$$ComboCalloutConfigImplFromJson(
  Map<String, dynamic> json,
) => _$ComboCalloutConfigImpl(
  enabled: json['enabled'] as bool? ?? false,
  sport: json['sport'] as String? ?? 'boxing',
  difficulty: json['difficulty'] as String? ?? 'beginner',
  intensity: json['intensity'] as String? ?? 'moderate',
  includeDefense: json['includeDefense'] as bool? ?? true,
  includeFootwork: json['includeFootwork'] as bool? ?? false,
);

Map<String, dynamic> _$$ComboCalloutConfigImplToJson(
  _$ComboCalloutConfigImpl instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'sport': instance.sport,
  'difficulty': instance.difficulty,
  'intensity': instance.intensity,
  'includeDefense': instance.includeDefense,
  'includeFootwork': instance.includeFootwork,
};
