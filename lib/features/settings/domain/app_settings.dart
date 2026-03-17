import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    // Timer defaults
    @Default(0) int defaultWarmupSec,
    @Default(10) int defaultWarningSec,
    @Default(true) bool defaultAutoAdvance,
    @Default(true) bool defaultKeepScreenOn,
    @Default(true) bool resumeCountdown,

    // Audio
    @Default('classic_bell') String defaultSoundPack,
    @Default(false) bool volumeOverride,
    @Default(true) bool hapticFeedback,

    // Display
    @Default('dark') String themeMode, // dark, light, system
    @Default(false) bool tapToPause,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
