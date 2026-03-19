import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:boxing/features/combos/domain/combo_callout_config.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
class RoundSegment with _$RoundSegment {
  const factory RoundSegment({
    required String label,
    required int durationSec,
    @Default('') String audioCue, // '' | 'bell_single' | 'bell_double' | 'whistle'
    @Default('work') String color, // 'work' | 'rest' | 'warning' | 'warmup'
  }) = _RoundSegment;

  factory RoundSegment.fromJson(Map<String, dynamic> json) =>
      _$RoundSegmentFromJson(json);
}

@freezed
class RoundTemplate with _$RoundTemplate {
  const RoundTemplate._();
  const factory RoundTemplate({
    required String id,
    required String name,
    required List<RoundSegment> segments,
    @Default(1) int repeatCount,
    @Default(false) bool isPreset,
  }) = _RoundTemplate;

  factory RoundTemplate.fromJson(Map<String, dynamic> json) =>
      _$RoundTemplateFromJson(json);

  List<RoundSegment> get expandedSegments =>
      List.generate(repeatCount, (_) => segments).expand((s) => s).toList();

  int get totalDurationSec =>
      segments.fold(0, (acc, s) => acc + s.durationSec) * repeatCount;
}

@freezed
class RoundOverride with _$RoundOverride {
  const factory RoundOverride({
    required int round,
    required int durationSec,
  }) = _RoundOverride;

  factory RoundOverride.fromJson(Map<String, dynamic> json) =>
      _$RoundOverrideFromJson(json);
}

@freezed
class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String id,
    required String name,
    required int rounds,
    required int roundDurationSec,
    required int restDurationSec,
    @Default(10) int warningTimeSec,
    @Default(0) int warmupDurationSec,
    @Default(true) bool autoAdvance,
    @Default(true) bool keepScreenOn,
    @Default(false) bool voiceAnnounce,
    @Default(false) bool volumeOverride,
    @Default('classic_bell') String soundPack,
    @Default([]) List<RoundOverride> roundOverrides,
    @Default(false) bool isPreset,
    @Default(null) RoundTemplate? roundTemplate,
    @Default({}) Map<int, RoundTemplate> roundTemplateOverrides,
    // Sport-specific fields (Sprint 8)
    @Default(null) String? sport,     // 'boxing' | 'muayThai' | 'mma' | 'bjj' | 'kickboxing' | 'wrestling' | null
    @Default(null) String? category,  // 'competition' | 'training' | 'drills' | 'conditioning' | null
    // Combo callout settings (Sprint 9)
    @Default(null) ComboCalloutConfig? comboConfig,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}

extension SessionModelX on SessionModel {
  Duration get roundDuration => Duration(seconds: roundDurationSec);
  Duration get restDuration => Duration(seconds: restDurationSec);
  Duration get warningTime => Duration(seconds: warningTimeSec);
  Duration get warmupDuration => Duration(seconds: warmupDurationSec);

  bool get hasCompoundRounds =>
      roundTemplate != null || roundTemplateOverrides.isNotEmpty;

  RoundTemplate? templateForRound(int round) {
    return roundTemplateOverrides[round] ?? roundTemplate;
  }

  int durationForRound(int round) {
    for (final override in roundOverrides) {
      if (override.round == round) return override.durationSec;
    }
    return roundDurationSec;
  }

  Duration get totalDuration {
    var total = warmupDurationSec;
    for (var i = 1; i <= rounds; i++) {
      final template = templateForRound(i);
      total += template != null
          ? template.totalDurationSec
          : durationForRound(i);
      if (i < rounds) total += restDurationSec;
    }
    return Duration(seconds: total);
  }
}
