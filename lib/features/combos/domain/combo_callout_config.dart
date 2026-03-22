import 'package:freezed_annotation/freezed_annotation.dart';

part 'combo_callout_config.freezed.dart';
part 'combo_callout_config.g.dart';

/// How frequently combos are called out during work phases.
enum ComboIntensity { relaxed, moderate, intense, hurricane }

/// Configuration for combo callouts within a session.
///
/// This is a freezed class because it is embedded in [SessionModel]
/// (which is itself freezed and JSON-serialized to Hive).
@freezed
class ComboCalloutConfig with _$ComboCalloutConfig {
  const factory ComboCalloutConfig({
    @Default(false) bool enabled,
    @Default('boxing') String sport,
    @Default('beginner') String difficulty,
    @Default('moderate') String intensity,
    @Default(true) bool includeDefense,
    @Default(false) bool includeFootwork,
    /// How combos are announced: 'numbers' (fast: "1 2 3") or 'names'
    /// (beginner-friendly: "Jab, Cross, Hook").
    @Default('numbers') String calloutStyle,
    /// Whether motivational interjections play between combos.
    @Default(true) bool enableCoachEncouragement,
  }) = _ComboCalloutConfig;

  factory ComboCalloutConfig.fromJson(Map<String, dynamic> json) =>
      _$ComboCalloutConfigFromJson(json);
}
