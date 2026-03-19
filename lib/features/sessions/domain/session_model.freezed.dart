// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoundSegment _$RoundSegmentFromJson(Map<String, dynamic> json) {
  return _RoundSegment.fromJson(json);
}

/// @nodoc
mixin _$RoundSegment {
  String get label => throw _privateConstructorUsedError;
  int get durationSec => throw _privateConstructorUsedError;
  String get audioCue =>
      throw _privateConstructorUsedError; // '' | 'bell_single' | 'bell_double' | 'whistle'
  String get color => throw _privateConstructorUsedError;

  /// Serializes this RoundSegment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoundSegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoundSegmentCopyWith<RoundSegment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoundSegmentCopyWith<$Res> {
  factory $RoundSegmentCopyWith(
    RoundSegment value,
    $Res Function(RoundSegment) then,
  ) = _$RoundSegmentCopyWithImpl<$Res, RoundSegment>;
  @useResult
  $Res call({String label, int durationSec, String audioCue, String color});
}

/// @nodoc
class _$RoundSegmentCopyWithImpl<$Res, $Val extends RoundSegment>
    implements $RoundSegmentCopyWith<$Res> {
  _$RoundSegmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoundSegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? durationSec = null,
    Object? audioCue = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            label:
                null == label
                    ? _value.label
                    : label // ignore: cast_nullable_to_non_nullable
                        as String,
            durationSec:
                null == durationSec
                    ? _value.durationSec
                    : durationSec // ignore: cast_nullable_to_non_nullable
                        as int,
            audioCue:
                null == audioCue
                    ? _value.audioCue
                    : audioCue // ignore: cast_nullable_to_non_nullable
                        as String,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoundSegmentImplCopyWith<$Res>
    implements $RoundSegmentCopyWith<$Res> {
  factory _$$RoundSegmentImplCopyWith(
    _$RoundSegmentImpl value,
    $Res Function(_$RoundSegmentImpl) then,
  ) = __$$RoundSegmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, int durationSec, String audioCue, String color});
}

/// @nodoc
class __$$RoundSegmentImplCopyWithImpl<$Res>
    extends _$RoundSegmentCopyWithImpl<$Res, _$RoundSegmentImpl>
    implements _$$RoundSegmentImplCopyWith<$Res> {
  __$$RoundSegmentImplCopyWithImpl(
    _$RoundSegmentImpl _value,
    $Res Function(_$RoundSegmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoundSegment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? durationSec = null,
    Object? audioCue = null,
    Object? color = null,
  }) {
    return _then(
      _$RoundSegmentImpl(
        label:
            null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                    as String,
        durationSec:
            null == durationSec
                ? _value.durationSec
                : durationSec // ignore: cast_nullable_to_non_nullable
                    as int,
        audioCue:
            null == audioCue
                ? _value.audioCue
                : audioCue // ignore: cast_nullable_to_non_nullable
                    as String,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoundSegmentImpl implements _RoundSegment {
  const _$RoundSegmentImpl({
    required this.label,
    required this.durationSec,
    this.audioCue = '',
    this.color = 'work',
  });

  factory _$RoundSegmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoundSegmentImplFromJson(json);

  @override
  final String label;
  @override
  final int durationSec;
  @override
  @JsonKey()
  final String audioCue;
  // '' | 'bell_single' | 'bell_double' | 'whistle'
  @override
  @JsonKey()
  final String color;

  @override
  String toString() {
    return 'RoundSegment(label: $label, durationSec: $durationSec, audioCue: $audioCue, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundSegmentImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec) &&
            (identical(other.audioCue, audioCue) ||
                other.audioCue == audioCue) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, label, durationSec, audioCue, color);

  /// Create a copy of RoundSegment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundSegmentImplCopyWith<_$RoundSegmentImpl> get copyWith =>
      __$$RoundSegmentImplCopyWithImpl<_$RoundSegmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoundSegmentImplToJson(this);
  }
}

abstract class _RoundSegment implements RoundSegment {
  const factory _RoundSegment({
    required final String label,
    required final int durationSec,
    final String audioCue,
    final String color,
  }) = _$RoundSegmentImpl;

  factory _RoundSegment.fromJson(Map<String, dynamic> json) =
      _$RoundSegmentImpl.fromJson;

  @override
  String get label;
  @override
  int get durationSec;
  @override
  String get audioCue; // '' | 'bell_single' | 'bell_double' | 'whistle'
  @override
  String get color;

  /// Create a copy of RoundSegment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoundSegmentImplCopyWith<_$RoundSegmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoundTemplate _$RoundTemplateFromJson(Map<String, dynamic> json) {
  return _RoundTemplate.fromJson(json);
}

/// @nodoc
mixin _$RoundTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<RoundSegment> get segments => throw _privateConstructorUsedError;
  int get repeatCount => throw _privateConstructorUsedError;
  bool get isPreset => throw _privateConstructorUsedError;

  /// Serializes this RoundTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoundTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoundTemplateCopyWith<RoundTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoundTemplateCopyWith<$Res> {
  factory $RoundTemplateCopyWith(
    RoundTemplate value,
    $Res Function(RoundTemplate) then,
  ) = _$RoundTemplateCopyWithImpl<$Res, RoundTemplate>;
  @useResult
  $Res call({
    String id,
    String name,
    List<RoundSegment> segments,
    int repeatCount,
    bool isPreset,
  });
}

/// @nodoc
class _$RoundTemplateCopyWithImpl<$Res, $Val extends RoundTemplate>
    implements $RoundTemplateCopyWith<$Res> {
  _$RoundTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoundTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? segments = null,
    Object? repeatCount = null,
    Object? isPreset = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            segments:
                null == segments
                    ? _value.segments
                    : segments // ignore: cast_nullable_to_non_nullable
                        as List<RoundSegment>,
            repeatCount:
                null == repeatCount
                    ? _value.repeatCount
                    : repeatCount // ignore: cast_nullable_to_non_nullable
                        as int,
            isPreset:
                null == isPreset
                    ? _value.isPreset
                    : isPreset // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoundTemplateImplCopyWith<$Res>
    implements $RoundTemplateCopyWith<$Res> {
  factory _$$RoundTemplateImplCopyWith(
    _$RoundTemplateImpl value,
    $Res Function(_$RoundTemplateImpl) then,
  ) = __$$RoundTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    List<RoundSegment> segments,
    int repeatCount,
    bool isPreset,
  });
}

/// @nodoc
class __$$RoundTemplateImplCopyWithImpl<$Res>
    extends _$RoundTemplateCopyWithImpl<$Res, _$RoundTemplateImpl>
    implements _$$RoundTemplateImplCopyWith<$Res> {
  __$$RoundTemplateImplCopyWithImpl(
    _$RoundTemplateImpl _value,
    $Res Function(_$RoundTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoundTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? segments = null,
    Object? repeatCount = null,
    Object? isPreset = null,
  }) {
    return _then(
      _$RoundTemplateImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        segments:
            null == segments
                ? _value._segments
                : segments // ignore: cast_nullable_to_non_nullable
                    as List<RoundSegment>,
        repeatCount:
            null == repeatCount
                ? _value.repeatCount
                : repeatCount // ignore: cast_nullable_to_non_nullable
                    as int,
        isPreset:
            null == isPreset
                ? _value.isPreset
                : isPreset // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoundTemplateImpl extends _RoundTemplate {
  const _$RoundTemplateImpl({
    required this.id,
    required this.name,
    required final List<RoundSegment> segments,
    this.repeatCount = 1,
    this.isPreset = false,
  }) : _segments = segments,
       super._();

  factory _$RoundTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoundTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final List<RoundSegment> _segments;
  @override
  List<RoundSegment> get segments {
    if (_segments is EqualUnmodifiableListView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_segments);
  }

  @override
  @JsonKey()
  final int repeatCount;
  @override
  @JsonKey()
  final bool isPreset;

  @override
  String toString() {
    return 'RoundTemplate(id: $id, name: $name, segments: $segments, repeatCount: $repeatCount, isPreset: $isPreset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._segments, _segments) &&
            (identical(other.repeatCount, repeatCount) ||
                other.repeatCount == repeatCount) &&
            (identical(other.isPreset, isPreset) ||
                other.isPreset == isPreset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    const DeepCollectionEquality().hash(_segments),
    repeatCount,
    isPreset,
  );

  /// Create a copy of RoundTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundTemplateImplCopyWith<_$RoundTemplateImpl> get copyWith =>
      __$$RoundTemplateImplCopyWithImpl<_$RoundTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoundTemplateImplToJson(this);
  }
}

abstract class _RoundTemplate extends RoundTemplate {
  const factory _RoundTemplate({
    required final String id,
    required final String name,
    required final List<RoundSegment> segments,
    final int repeatCount,
    final bool isPreset,
  }) = _$RoundTemplateImpl;
  const _RoundTemplate._() : super._();

  factory _RoundTemplate.fromJson(Map<String, dynamic> json) =
      _$RoundTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  List<RoundSegment> get segments;
  @override
  int get repeatCount;
  @override
  bool get isPreset;

  /// Create a copy of RoundTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoundTemplateImplCopyWith<_$RoundTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoundOverride _$RoundOverrideFromJson(Map<String, dynamic> json) {
  return _RoundOverride.fromJson(json);
}

/// @nodoc
mixin _$RoundOverride {
  int get round => throw _privateConstructorUsedError;
  int get durationSec => throw _privateConstructorUsedError;

  /// Serializes this RoundOverride to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoundOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoundOverrideCopyWith<RoundOverride> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoundOverrideCopyWith<$Res> {
  factory $RoundOverrideCopyWith(
    RoundOverride value,
    $Res Function(RoundOverride) then,
  ) = _$RoundOverrideCopyWithImpl<$Res, RoundOverride>;
  @useResult
  $Res call({int round, int durationSec});
}

/// @nodoc
class _$RoundOverrideCopyWithImpl<$Res, $Val extends RoundOverride>
    implements $RoundOverrideCopyWith<$Res> {
  _$RoundOverrideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoundOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? round = null, Object? durationSec = null}) {
    return _then(
      _value.copyWith(
            round:
                null == round
                    ? _value.round
                    : round // ignore: cast_nullable_to_non_nullable
                        as int,
            durationSec:
                null == durationSec
                    ? _value.durationSec
                    : durationSec // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoundOverrideImplCopyWith<$Res>
    implements $RoundOverrideCopyWith<$Res> {
  factory _$$RoundOverrideImplCopyWith(
    _$RoundOverrideImpl value,
    $Res Function(_$RoundOverrideImpl) then,
  ) = __$$RoundOverrideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int round, int durationSec});
}

/// @nodoc
class __$$RoundOverrideImplCopyWithImpl<$Res>
    extends _$RoundOverrideCopyWithImpl<$Res, _$RoundOverrideImpl>
    implements _$$RoundOverrideImplCopyWith<$Res> {
  __$$RoundOverrideImplCopyWithImpl(
    _$RoundOverrideImpl _value,
    $Res Function(_$RoundOverrideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoundOverride
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? round = null, Object? durationSec = null}) {
    return _then(
      _$RoundOverrideImpl(
        round:
            null == round
                ? _value.round
                : round // ignore: cast_nullable_to_non_nullable
                    as int,
        durationSec:
            null == durationSec
                ? _value.durationSec
                : durationSec // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoundOverrideImpl implements _RoundOverride {
  const _$RoundOverrideImpl({required this.round, required this.durationSec});

  factory _$RoundOverrideImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoundOverrideImplFromJson(json);

  @override
  final int round;
  @override
  final int durationSec;

  @override
  String toString() {
    return 'RoundOverride(round: $round, durationSec: $durationSec)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundOverrideImpl &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, round, durationSec);

  /// Create a copy of RoundOverride
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundOverrideImplCopyWith<_$RoundOverrideImpl> get copyWith =>
      __$$RoundOverrideImplCopyWithImpl<_$RoundOverrideImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoundOverrideImplToJson(this);
  }
}

abstract class _RoundOverride implements RoundOverride {
  const factory _RoundOverride({
    required final int round,
    required final int durationSec,
  }) = _$RoundOverrideImpl;

  factory _RoundOverride.fromJson(Map<String, dynamic> json) =
      _$RoundOverrideImpl.fromJson;

  @override
  int get round;
  @override
  int get durationSec;

  /// Create a copy of RoundOverride
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoundOverrideImplCopyWith<_$RoundOverrideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) {
  return _SessionModel.fromJson(json);
}

/// @nodoc
mixin _$SessionModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get rounds => throw _privateConstructorUsedError;
  int get roundDurationSec => throw _privateConstructorUsedError;
  int get restDurationSec => throw _privateConstructorUsedError;
  int get warningTimeSec => throw _privateConstructorUsedError;
  int get warmupDurationSec => throw _privateConstructorUsedError;
  bool get autoAdvance => throw _privateConstructorUsedError;
  bool get keepScreenOn => throw _privateConstructorUsedError;
  bool get voiceAnnounce => throw _privateConstructorUsedError;
  bool get volumeOverride => throw _privateConstructorUsedError;
  String get soundPack => throw _privateConstructorUsedError;
  List<RoundOverride> get roundOverrides => throw _privateConstructorUsedError;
  bool get isPreset => throw _privateConstructorUsedError;
  RoundTemplate? get roundTemplate => throw _privateConstructorUsedError;
  Map<int, RoundTemplate> get roundTemplateOverrides =>
      throw _privateConstructorUsedError; // Sport-specific fields (Sprint 8)
  String? get sport =>
      throw _privateConstructorUsedError; // 'boxing' | 'muayThai' | 'mma' | 'bjj' | 'kickboxing' | 'wrestling' | null
  String? get category => throw _privateConstructorUsedError;

  /// Serializes this SessionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionModelCopyWith<SessionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionModelCopyWith<$Res> {
  factory $SessionModelCopyWith(
    SessionModel value,
    $Res Function(SessionModel) then,
  ) = _$SessionModelCopyWithImpl<$Res, SessionModel>;
  @useResult
  $Res call({
    String id,
    String name,
    int rounds,
    int roundDurationSec,
    int restDurationSec,
    int warningTimeSec,
    int warmupDurationSec,
    bool autoAdvance,
    bool keepScreenOn,
    bool voiceAnnounce,
    bool volumeOverride,
    String soundPack,
    List<RoundOverride> roundOverrides,
    bool isPreset,
    RoundTemplate? roundTemplate,
    Map<int, RoundTemplate> roundTemplateOverrides,
    String? sport,
    String? category,
  });

  $RoundTemplateCopyWith<$Res>? get roundTemplate;
}

/// @nodoc
class _$SessionModelCopyWithImpl<$Res, $Val extends SessionModel>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rounds = null,
    Object? roundDurationSec = null,
    Object? restDurationSec = null,
    Object? warningTimeSec = null,
    Object? warmupDurationSec = null,
    Object? autoAdvance = null,
    Object? keepScreenOn = null,
    Object? voiceAnnounce = null,
    Object? volumeOverride = null,
    Object? soundPack = null,
    Object? roundOverrides = null,
    Object? isPreset = null,
    Object? roundTemplate = freezed,
    Object? roundTemplateOverrides = null,
    Object? sport = freezed,
    Object? category = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            rounds:
                null == rounds
                    ? _value.rounds
                    : rounds // ignore: cast_nullable_to_non_nullable
                        as int,
            roundDurationSec:
                null == roundDurationSec
                    ? _value.roundDurationSec
                    : roundDurationSec // ignore: cast_nullable_to_non_nullable
                        as int,
            restDurationSec:
                null == restDurationSec
                    ? _value.restDurationSec
                    : restDurationSec // ignore: cast_nullable_to_non_nullable
                        as int,
            warningTimeSec:
                null == warningTimeSec
                    ? _value.warningTimeSec
                    : warningTimeSec // ignore: cast_nullable_to_non_nullable
                        as int,
            warmupDurationSec:
                null == warmupDurationSec
                    ? _value.warmupDurationSec
                    : warmupDurationSec // ignore: cast_nullable_to_non_nullable
                        as int,
            autoAdvance:
                null == autoAdvance
                    ? _value.autoAdvance
                    : autoAdvance // ignore: cast_nullable_to_non_nullable
                        as bool,
            keepScreenOn:
                null == keepScreenOn
                    ? _value.keepScreenOn
                    : keepScreenOn // ignore: cast_nullable_to_non_nullable
                        as bool,
            voiceAnnounce:
                null == voiceAnnounce
                    ? _value.voiceAnnounce
                    : voiceAnnounce // ignore: cast_nullable_to_non_nullable
                        as bool,
            volumeOverride:
                null == volumeOverride
                    ? _value.volumeOverride
                    : volumeOverride // ignore: cast_nullable_to_non_nullable
                        as bool,
            soundPack:
                null == soundPack
                    ? _value.soundPack
                    : soundPack // ignore: cast_nullable_to_non_nullable
                        as String,
            roundOverrides:
                null == roundOverrides
                    ? _value.roundOverrides
                    : roundOverrides // ignore: cast_nullable_to_non_nullable
                        as List<RoundOverride>,
            isPreset:
                null == isPreset
                    ? _value.isPreset
                    : isPreset // ignore: cast_nullable_to_non_nullable
                        as bool,
            roundTemplate:
                freezed == roundTemplate
                    ? _value.roundTemplate
                    : roundTemplate // ignore: cast_nullable_to_non_nullable
                        as RoundTemplate?,
            roundTemplateOverrides:
                null == roundTemplateOverrides
                    ? _value.roundTemplateOverrides
                    : roundTemplateOverrides // ignore: cast_nullable_to_non_nullable
                        as Map<int, RoundTemplate>,
            sport:
                freezed == sport
                    ? _value.sport
                    : sport // ignore: cast_nullable_to_non_nullable
                        as String?,
            category:
                freezed == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RoundTemplateCopyWith<$Res>? get roundTemplate {
    if (_value.roundTemplate == null) {
      return null;
    }

    return $RoundTemplateCopyWith<$Res>(_value.roundTemplate!, (value) {
      return _then(_value.copyWith(roundTemplate: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionModelImplCopyWith<$Res>
    implements $SessionModelCopyWith<$Res> {
  factory _$$SessionModelImplCopyWith(
    _$SessionModelImpl value,
    $Res Function(_$SessionModelImpl) then,
  ) = __$$SessionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int rounds,
    int roundDurationSec,
    int restDurationSec,
    int warningTimeSec,
    int warmupDurationSec,
    bool autoAdvance,
    bool keepScreenOn,
    bool voiceAnnounce,
    bool volumeOverride,
    String soundPack,
    List<RoundOverride> roundOverrides,
    bool isPreset,
    RoundTemplate? roundTemplate,
    Map<int, RoundTemplate> roundTemplateOverrides,
    String? sport,
    String? category,
  });

  @override
  $RoundTemplateCopyWith<$Res>? get roundTemplate;
}

/// @nodoc
class __$$SessionModelImplCopyWithImpl<$Res>
    extends _$SessionModelCopyWithImpl<$Res, _$SessionModelImpl>
    implements _$$SessionModelImplCopyWith<$Res> {
  __$$SessionModelImplCopyWithImpl(
    _$SessionModelImpl _value,
    $Res Function(_$SessionModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? rounds = null,
    Object? roundDurationSec = null,
    Object? restDurationSec = null,
    Object? warningTimeSec = null,
    Object? warmupDurationSec = null,
    Object? autoAdvance = null,
    Object? keepScreenOn = null,
    Object? voiceAnnounce = null,
    Object? volumeOverride = null,
    Object? soundPack = null,
    Object? roundOverrides = null,
    Object? isPreset = null,
    Object? roundTemplate = freezed,
    Object? roundTemplateOverrides = null,
    Object? sport = freezed,
    Object? category = freezed,
  }) {
    return _then(
      _$SessionModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        rounds:
            null == rounds
                ? _value.rounds
                : rounds // ignore: cast_nullable_to_non_nullable
                    as int,
        roundDurationSec:
            null == roundDurationSec
                ? _value.roundDurationSec
                : roundDurationSec // ignore: cast_nullable_to_non_nullable
                    as int,
        restDurationSec:
            null == restDurationSec
                ? _value.restDurationSec
                : restDurationSec // ignore: cast_nullable_to_non_nullable
                    as int,
        warningTimeSec:
            null == warningTimeSec
                ? _value.warningTimeSec
                : warningTimeSec // ignore: cast_nullable_to_non_nullable
                    as int,
        warmupDurationSec:
            null == warmupDurationSec
                ? _value.warmupDurationSec
                : warmupDurationSec // ignore: cast_nullable_to_non_nullable
                    as int,
        autoAdvance:
            null == autoAdvance
                ? _value.autoAdvance
                : autoAdvance // ignore: cast_nullable_to_non_nullable
                    as bool,
        keepScreenOn:
            null == keepScreenOn
                ? _value.keepScreenOn
                : keepScreenOn // ignore: cast_nullable_to_non_nullable
                    as bool,
        voiceAnnounce:
            null == voiceAnnounce
                ? _value.voiceAnnounce
                : voiceAnnounce // ignore: cast_nullable_to_non_nullable
                    as bool,
        volumeOverride:
            null == volumeOverride
                ? _value.volumeOverride
                : volumeOverride // ignore: cast_nullable_to_non_nullable
                    as bool,
        soundPack:
            null == soundPack
                ? _value.soundPack
                : soundPack // ignore: cast_nullable_to_non_nullable
                    as String,
        roundOverrides:
            null == roundOverrides
                ? _value._roundOverrides
                : roundOverrides // ignore: cast_nullable_to_non_nullable
                    as List<RoundOverride>,
        isPreset:
            null == isPreset
                ? _value.isPreset
                : isPreset // ignore: cast_nullable_to_non_nullable
                    as bool,
        roundTemplate:
            freezed == roundTemplate
                ? _value.roundTemplate
                : roundTemplate // ignore: cast_nullable_to_non_nullable
                    as RoundTemplate?,
        roundTemplateOverrides:
            null == roundTemplateOverrides
                ? _value._roundTemplateOverrides
                : roundTemplateOverrides // ignore: cast_nullable_to_non_nullable
                    as Map<int, RoundTemplate>,
        sport:
            freezed == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                    as String?,
        category:
            freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionModelImpl implements _SessionModel {
  const _$SessionModelImpl({
    required this.id,
    required this.name,
    required this.rounds,
    required this.roundDurationSec,
    required this.restDurationSec,
    this.warningTimeSec = 10,
    this.warmupDurationSec = 0,
    this.autoAdvance = true,
    this.keepScreenOn = true,
    this.voiceAnnounce = false,
    this.volumeOverride = false,
    this.soundPack = 'classic_bell',
    final List<RoundOverride> roundOverrides = const [],
    this.isPreset = false,
    this.roundTemplate = null,
    final Map<int, RoundTemplate> roundTemplateOverrides = const {},
    this.sport = null,
    this.category = null,
  }) : _roundOverrides = roundOverrides,
       _roundTemplateOverrides = roundTemplateOverrides;

  factory _$SessionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int rounds;
  @override
  final int roundDurationSec;
  @override
  final int restDurationSec;
  @override
  @JsonKey()
  final int warningTimeSec;
  @override
  @JsonKey()
  final int warmupDurationSec;
  @override
  @JsonKey()
  final bool autoAdvance;
  @override
  @JsonKey()
  final bool keepScreenOn;
  @override
  @JsonKey()
  final bool voiceAnnounce;
  @override
  @JsonKey()
  final bool volumeOverride;
  @override
  @JsonKey()
  final String soundPack;
  final List<RoundOverride> _roundOverrides;
  @override
  @JsonKey()
  List<RoundOverride> get roundOverrides {
    if (_roundOverrides is EqualUnmodifiableListView) return _roundOverrides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roundOverrides);
  }

  @override
  @JsonKey()
  final bool isPreset;
  @override
  @JsonKey()
  final RoundTemplate? roundTemplate;
  final Map<int, RoundTemplate> _roundTemplateOverrides;
  @override
  @JsonKey()
  Map<int, RoundTemplate> get roundTemplateOverrides {
    if (_roundTemplateOverrides is EqualUnmodifiableMapView)
      return _roundTemplateOverrides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_roundTemplateOverrides);
  }

  // Sport-specific fields (Sprint 8)
  @override
  @JsonKey()
  final String? sport;
  // 'boxing' | 'muayThai' | 'mma' | 'bjj' | 'kickboxing' | 'wrestling' | null
  @override
  @JsonKey()
  final String? category;

  @override
  String toString() {
    return 'SessionModel(id: $id, name: $name, rounds: $rounds, roundDurationSec: $roundDurationSec, restDurationSec: $restDurationSec, warningTimeSec: $warningTimeSec, warmupDurationSec: $warmupDurationSec, autoAdvance: $autoAdvance, keepScreenOn: $keepScreenOn, voiceAnnounce: $voiceAnnounce, volumeOverride: $volumeOverride, soundPack: $soundPack, roundOverrides: $roundOverrides, isPreset: $isPreset, roundTemplate: $roundTemplate, roundTemplateOverrides: $roundTemplateOverrides, sport: $sport, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.rounds, rounds) || other.rounds == rounds) &&
            (identical(other.roundDurationSec, roundDurationSec) ||
                other.roundDurationSec == roundDurationSec) &&
            (identical(other.restDurationSec, restDurationSec) ||
                other.restDurationSec == restDurationSec) &&
            (identical(other.warningTimeSec, warningTimeSec) ||
                other.warningTimeSec == warningTimeSec) &&
            (identical(other.warmupDurationSec, warmupDurationSec) ||
                other.warmupDurationSec == warmupDurationSec) &&
            (identical(other.autoAdvance, autoAdvance) ||
                other.autoAdvance == autoAdvance) &&
            (identical(other.keepScreenOn, keepScreenOn) ||
                other.keepScreenOn == keepScreenOn) &&
            (identical(other.voiceAnnounce, voiceAnnounce) ||
                other.voiceAnnounce == voiceAnnounce) &&
            (identical(other.volumeOverride, volumeOverride) ||
                other.volumeOverride == volumeOverride) &&
            (identical(other.soundPack, soundPack) ||
                other.soundPack == soundPack) &&
            const DeepCollectionEquality().equals(
              other._roundOverrides,
              _roundOverrides,
            ) &&
            (identical(other.isPreset, isPreset) ||
                other.isPreset == isPreset) &&
            (identical(other.roundTemplate, roundTemplate) ||
                other.roundTemplate == roundTemplate) &&
            const DeepCollectionEquality().equals(
              other._roundTemplateOverrides,
              _roundTemplateOverrides,
            ) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    rounds,
    roundDurationSec,
    restDurationSec,
    warningTimeSec,
    warmupDurationSec,
    autoAdvance,
    keepScreenOn,
    voiceAnnounce,
    volumeOverride,
    soundPack,
    const DeepCollectionEquality().hash(_roundOverrides),
    isPreset,
    roundTemplate,
    const DeepCollectionEquality().hash(_roundTemplateOverrides),
    sport,
    category,
  );

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      __$$SessionModelImplCopyWithImpl<_$SessionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionModelImplToJson(this);
  }
}

abstract class _SessionModel implements SessionModel {
  const factory _SessionModel({
    required final String id,
    required final String name,
    required final int rounds,
    required final int roundDurationSec,
    required final int restDurationSec,
    final int warningTimeSec,
    final int warmupDurationSec,
    final bool autoAdvance,
    final bool keepScreenOn,
    final bool voiceAnnounce,
    final bool volumeOverride,
    final String soundPack,
    final List<RoundOverride> roundOverrides,
    final bool isPreset,
    final RoundTemplate? roundTemplate,
    final Map<int, RoundTemplate> roundTemplateOverrides,
    final String? sport,
    final String? category,
  }) = _$SessionModelImpl;

  factory _SessionModel.fromJson(Map<String, dynamic> json) =
      _$SessionModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get rounds;
  @override
  int get roundDurationSec;
  @override
  int get restDurationSec;
  @override
  int get warningTimeSec;
  @override
  int get warmupDurationSec;
  @override
  bool get autoAdvance;
  @override
  bool get keepScreenOn;
  @override
  bool get voiceAnnounce;
  @override
  bool get volumeOverride;
  @override
  String get soundPack;
  @override
  List<RoundOverride> get roundOverrides;
  @override
  bool get isPreset;
  @override
  RoundTemplate? get roundTemplate;
  @override
  Map<int, RoundTemplate> get roundTemplateOverrides; // Sport-specific fields (Sprint 8)
  @override
  String? get sport; // 'boxing' | 'muayThai' | 'mma' | 'bjj' | 'kickboxing' | 'wrestling' | null
  @override
  String? get category;

  /// Create a copy of SessionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionModelImplCopyWith<_$SessionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
