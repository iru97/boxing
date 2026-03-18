// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) {
  return _AppSettings.fromJson(json);
}

/// @nodoc
mixin _$AppSettings {
  // Timer defaults
  int get defaultWarmupSec => throw _privateConstructorUsedError;
  int get defaultWarningSec => throw _privateConstructorUsedError;
  bool get defaultAutoAdvance => throw _privateConstructorUsedError;
  bool get defaultKeepScreenOn => throw _privateConstructorUsedError;
  bool get resumeCountdown => throw _privateConstructorUsedError; // Audio
  String get defaultSoundPack => throw _privateConstructorUsedError;
  bool get volumeOverride => throw _privateConstructorUsedError;
  bool get hapticFeedback => throw _privateConstructorUsedError; // Display
  String get themeMode =>
      throw _privateConstructorUsedError; // dark, light, system
  String get locale => throw _privateConstructorUsedError; // system, en, es, pt
  bool get tapToPause => throw _privateConstructorUsedError;

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppSettingsCopyWith<AppSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppSettingsCopyWith<$Res> {
  factory $AppSettingsCopyWith(
    AppSettings value,
    $Res Function(AppSettings) then,
  ) = _$AppSettingsCopyWithImpl<$Res, AppSettings>;
  @useResult
  $Res call({
    int defaultWarmupSec,
    int defaultWarningSec,
    bool defaultAutoAdvance,
    bool defaultKeepScreenOn,
    bool resumeCountdown,
    String defaultSoundPack,
    bool volumeOverride,
    bool hapticFeedback,
    String themeMode,
    String locale,
    bool tapToPause,
  });
}

/// @nodoc
class _$AppSettingsCopyWithImpl<$Res, $Val extends AppSettings>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultWarmupSec = null,
    Object? defaultWarningSec = null,
    Object? defaultAutoAdvance = null,
    Object? defaultKeepScreenOn = null,
    Object? resumeCountdown = null,
    Object? defaultSoundPack = null,
    Object? volumeOverride = null,
    Object? hapticFeedback = null,
    Object? themeMode = null,
    Object? locale = null,
    Object? tapToPause = null,
  }) {
    return _then(
      _value.copyWith(
            defaultWarmupSec:
                null == defaultWarmupSec
                    ? _value.defaultWarmupSec
                    : defaultWarmupSec // ignore: cast_nullable_to_non_nullable
                        as int,
            defaultWarningSec:
                null == defaultWarningSec
                    ? _value.defaultWarningSec
                    : defaultWarningSec // ignore: cast_nullable_to_non_nullable
                        as int,
            defaultAutoAdvance:
                null == defaultAutoAdvance
                    ? _value.defaultAutoAdvance
                    : defaultAutoAdvance // ignore: cast_nullable_to_non_nullable
                        as bool,
            defaultKeepScreenOn:
                null == defaultKeepScreenOn
                    ? _value.defaultKeepScreenOn
                    : defaultKeepScreenOn // ignore: cast_nullable_to_non_nullable
                        as bool,
            resumeCountdown:
                null == resumeCountdown
                    ? _value.resumeCountdown
                    : resumeCountdown // ignore: cast_nullable_to_non_nullable
                        as bool,
            defaultSoundPack:
                null == defaultSoundPack
                    ? _value.defaultSoundPack
                    : defaultSoundPack // ignore: cast_nullable_to_non_nullable
                        as String,
            volumeOverride:
                null == volumeOverride
                    ? _value.volumeOverride
                    : volumeOverride // ignore: cast_nullable_to_non_nullable
                        as bool,
            hapticFeedback:
                null == hapticFeedback
                    ? _value.hapticFeedback
                    : hapticFeedback // ignore: cast_nullable_to_non_nullable
                        as bool,
            themeMode:
                null == themeMode
                    ? _value.themeMode
                    : themeMode // ignore: cast_nullable_to_non_nullable
                        as String,
            locale:
                null == locale
                    ? _value.locale
                    : locale // ignore: cast_nullable_to_non_nullable
                        as String,
            tapToPause:
                null == tapToPause
                    ? _value.tapToPause
                    : tapToPause // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AppSettingsImplCopyWith<$Res>
    implements $AppSettingsCopyWith<$Res> {
  factory _$$AppSettingsImplCopyWith(
    _$AppSettingsImpl value,
    $Res Function(_$AppSettingsImpl) then,
  ) = __$$AppSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int defaultWarmupSec,
    int defaultWarningSec,
    bool defaultAutoAdvance,
    bool defaultKeepScreenOn,
    bool resumeCountdown,
    String defaultSoundPack,
    bool volumeOverride,
    bool hapticFeedback,
    String themeMode,
    String locale,
    bool tapToPause,
  });
}

/// @nodoc
class __$$AppSettingsImplCopyWithImpl<$Res>
    extends _$AppSettingsCopyWithImpl<$Res, _$AppSettingsImpl>
    implements _$$AppSettingsImplCopyWith<$Res> {
  __$$AppSettingsImplCopyWithImpl(
    _$AppSettingsImpl _value,
    $Res Function(_$AppSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? defaultWarmupSec = null,
    Object? defaultWarningSec = null,
    Object? defaultAutoAdvance = null,
    Object? defaultKeepScreenOn = null,
    Object? resumeCountdown = null,
    Object? defaultSoundPack = null,
    Object? volumeOverride = null,
    Object? hapticFeedback = null,
    Object? themeMode = null,
    Object? locale = null,
    Object? tapToPause = null,
  }) {
    return _then(
      _$AppSettingsImpl(
        defaultWarmupSec:
            null == defaultWarmupSec
                ? _value.defaultWarmupSec
                : defaultWarmupSec // ignore: cast_nullable_to_non_nullable
                    as int,
        defaultWarningSec:
            null == defaultWarningSec
                ? _value.defaultWarningSec
                : defaultWarningSec // ignore: cast_nullable_to_non_nullable
                    as int,
        defaultAutoAdvance:
            null == defaultAutoAdvance
                ? _value.defaultAutoAdvance
                : defaultAutoAdvance // ignore: cast_nullable_to_non_nullable
                    as bool,
        defaultKeepScreenOn:
            null == defaultKeepScreenOn
                ? _value.defaultKeepScreenOn
                : defaultKeepScreenOn // ignore: cast_nullable_to_non_nullable
                    as bool,
        resumeCountdown:
            null == resumeCountdown
                ? _value.resumeCountdown
                : resumeCountdown // ignore: cast_nullable_to_non_nullable
                    as bool,
        defaultSoundPack:
            null == defaultSoundPack
                ? _value.defaultSoundPack
                : defaultSoundPack // ignore: cast_nullable_to_non_nullable
                    as String,
        volumeOverride:
            null == volumeOverride
                ? _value.volumeOverride
                : volumeOverride // ignore: cast_nullable_to_non_nullable
                    as bool,
        hapticFeedback:
            null == hapticFeedback
                ? _value.hapticFeedback
                : hapticFeedback // ignore: cast_nullable_to_non_nullable
                    as bool,
        themeMode:
            null == themeMode
                ? _value.themeMode
                : themeMode // ignore: cast_nullable_to_non_nullable
                    as String,
        locale:
            null == locale
                ? _value.locale
                : locale // ignore: cast_nullable_to_non_nullable
                    as String,
        tapToPause:
            null == tapToPause
                ? _value.tapToPause
                : tapToPause // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AppSettingsImpl implements _AppSettings {
  const _$AppSettingsImpl({
    this.defaultWarmupSec = 0,
    this.defaultWarningSec = 10,
    this.defaultAutoAdvance = true,
    this.defaultKeepScreenOn = true,
    this.resumeCountdown = true,
    this.defaultSoundPack = 'classic_bell',
    this.volumeOverride = false,
    this.hapticFeedback = true,
    this.themeMode = 'dark',
    this.locale = 'system',
    this.tapToPause = false,
  });

  factory _$AppSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppSettingsImplFromJson(json);

  // Timer defaults
  @override
  @JsonKey()
  final int defaultWarmupSec;
  @override
  @JsonKey()
  final int defaultWarningSec;
  @override
  @JsonKey()
  final bool defaultAutoAdvance;
  @override
  @JsonKey()
  final bool defaultKeepScreenOn;
  @override
  @JsonKey()
  final bool resumeCountdown;
  // Audio
  @override
  @JsonKey()
  final String defaultSoundPack;
  @override
  @JsonKey()
  final bool volumeOverride;
  @override
  @JsonKey()
  final bool hapticFeedback;
  // Display
  @override
  @JsonKey()
  final String themeMode;
  // dark, light, system
  @override
  @JsonKey()
  final String locale;
  // system, en, es, pt
  @override
  @JsonKey()
  final bool tapToPause;

  @override
  String toString() {
    return 'AppSettings(defaultWarmupSec: $defaultWarmupSec, defaultWarningSec: $defaultWarningSec, defaultAutoAdvance: $defaultAutoAdvance, defaultKeepScreenOn: $defaultKeepScreenOn, resumeCountdown: $resumeCountdown, defaultSoundPack: $defaultSoundPack, volumeOverride: $volumeOverride, hapticFeedback: $hapticFeedback, themeMode: $themeMode, locale: $locale, tapToPause: $tapToPause)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppSettingsImpl &&
            (identical(other.defaultWarmupSec, defaultWarmupSec) ||
                other.defaultWarmupSec == defaultWarmupSec) &&
            (identical(other.defaultWarningSec, defaultWarningSec) ||
                other.defaultWarningSec == defaultWarningSec) &&
            (identical(other.defaultAutoAdvance, defaultAutoAdvance) ||
                other.defaultAutoAdvance == defaultAutoAdvance) &&
            (identical(other.defaultKeepScreenOn, defaultKeepScreenOn) ||
                other.defaultKeepScreenOn == defaultKeepScreenOn) &&
            (identical(other.resumeCountdown, resumeCountdown) ||
                other.resumeCountdown == resumeCountdown) &&
            (identical(other.defaultSoundPack, defaultSoundPack) ||
                other.defaultSoundPack == defaultSoundPack) &&
            (identical(other.volumeOverride, volumeOverride) ||
                other.volumeOverride == volumeOverride) &&
            (identical(other.hapticFeedback, hapticFeedback) ||
                other.hapticFeedback == hapticFeedback) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.tapToPause, tapToPause) ||
                other.tapToPause == tapToPause));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    defaultWarmupSec,
    defaultWarningSec,
    defaultAutoAdvance,
    defaultKeepScreenOn,
    resumeCountdown,
    defaultSoundPack,
    volumeOverride,
    hapticFeedback,
    themeMode,
    locale,
    tapToPause,
  );

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      __$$AppSettingsImplCopyWithImpl<_$AppSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppSettingsImplToJson(this);
  }
}

abstract class _AppSettings implements AppSettings {
  const factory _AppSettings({
    final int defaultWarmupSec,
    final int defaultWarningSec,
    final bool defaultAutoAdvance,
    final bool defaultKeepScreenOn,
    final bool resumeCountdown,
    final String defaultSoundPack,
    final bool volumeOverride,
    final bool hapticFeedback,
    final String themeMode,
    final String locale,
    final bool tapToPause,
  }) = _$AppSettingsImpl;

  factory _AppSettings.fromJson(Map<String, dynamic> json) =
      _$AppSettingsImpl.fromJson;

  // Timer defaults
  @override
  int get defaultWarmupSec;
  @override
  int get defaultWarningSec;
  @override
  bool get defaultAutoAdvance;
  @override
  bool get defaultKeepScreenOn;
  @override
  bool get resumeCountdown; // Audio
  @override
  String get defaultSoundPack;
  @override
  bool get volumeOverride;
  @override
  bool get hapticFeedback; // Display
  @override
  String get themeMode; // dark, light, system
  @override
  String get locale; // system, en, es, pt
  @override
  bool get tapToPause;

  /// Create a copy of AppSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppSettingsImplCopyWith<_$AppSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
