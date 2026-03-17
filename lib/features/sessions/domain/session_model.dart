import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

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
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}

extension SessionModelX on SessionModel {
  Duration get roundDuration => Duration(seconds: roundDurationSec);
  Duration get restDuration => Duration(seconds: restDurationSec);
  Duration get warningTime => Duration(seconds: warningTimeSec);
  Duration get warmupDuration => Duration(seconds: warmupDurationSec);

  int durationForRound(int round) {
    for (final override in roundOverrides) {
      if (override.round == round) return override.durationSec;
    }
    return roundDurationSec;
  }

  Duration get totalDuration {
    var total = warmupDurationSec;
    for (var i = 1; i <= rounds; i++) {
      total += durationForRound(i);
      if (i < rounds) total += restDurationSec;
    }
    return Duration(seconds: total);
  }
}
