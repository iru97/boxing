// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_checkpoint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimerCheckpoint _$TimerCheckpointFromJson(Map<String, dynamic> json) {
  return _TimerCheckpoint.fromJson(json);
}

/// @nodoc
mixin _$TimerCheckpoint {
  // Which session
  String get sessionId => throw _privateConstructorUsedError;
  String get sessionJson =>
      throw _privateConstructorUsedError; // Engine position
  String get enginePhase =>
      throw _privateConstructorUsedError; // 'warmup' | 'work' | 'segment' | 'rest'
  int get currentRound => throw _privateConstructorUsedError;
  int get currentSegmentIndex => throw _privateConstructorUsedError;
  int get phaseRemainingMs => throw _privateConstructorUsedError;
  int get phaseDurationMs => throw _privateConstructorUsedError;
  int get totalElapsedSec => throw _privateConstructorUsedError;
  bool get warningFired => throw _privateConstructorUsedError;
  bool get waitingForAdvance =>
      throw _privateConstructorUsedError; // Wall-clock anchor
  int get checkpointTimestampMs => throw _privateConstructorUsedError;
  bool get wasPaused => throw _privateConstructorUsedError; // Metadata
  String get sessionName => throw _privateConstructorUsedError;

  /// Serializes this TimerCheckpoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimerCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimerCheckpointCopyWith<TimerCheckpoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerCheckpointCopyWith<$Res> {
  factory $TimerCheckpointCopyWith(
    TimerCheckpoint value,
    $Res Function(TimerCheckpoint) then,
  ) = _$TimerCheckpointCopyWithImpl<$Res, TimerCheckpoint>;
  @useResult
  $Res call({
    String sessionId,
    String sessionJson,
    String enginePhase,
    int currentRound,
    int currentSegmentIndex,
    int phaseRemainingMs,
    int phaseDurationMs,
    int totalElapsedSec,
    bool warningFired,
    bool waitingForAdvance,
    int checkpointTimestampMs,
    bool wasPaused,
    String sessionName,
  });
}

/// @nodoc
class _$TimerCheckpointCopyWithImpl<$Res, $Val extends TimerCheckpoint>
    implements $TimerCheckpointCopyWith<$Res> {
  _$TimerCheckpointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimerCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionJson = null,
    Object? enginePhase = null,
    Object? currentRound = null,
    Object? currentSegmentIndex = null,
    Object? phaseRemainingMs = null,
    Object? phaseDurationMs = null,
    Object? totalElapsedSec = null,
    Object? warningFired = null,
    Object? waitingForAdvance = null,
    Object? checkpointTimestampMs = null,
    Object? wasPaused = null,
    Object? sessionName = null,
  }) {
    return _then(
      _value.copyWith(
            sessionId:
                null == sessionId
                    ? _value.sessionId
                    : sessionId // ignore: cast_nullable_to_non_nullable
                        as String,
            sessionJson:
                null == sessionJson
                    ? _value.sessionJson
                    : sessionJson // ignore: cast_nullable_to_non_nullable
                        as String,
            enginePhase:
                null == enginePhase
                    ? _value.enginePhase
                    : enginePhase // ignore: cast_nullable_to_non_nullable
                        as String,
            currentRound:
                null == currentRound
                    ? _value.currentRound
                    : currentRound // ignore: cast_nullable_to_non_nullable
                        as int,
            currentSegmentIndex:
                null == currentSegmentIndex
                    ? _value.currentSegmentIndex
                    : currentSegmentIndex // ignore: cast_nullable_to_non_nullable
                        as int,
            phaseRemainingMs:
                null == phaseRemainingMs
                    ? _value.phaseRemainingMs
                    : phaseRemainingMs // ignore: cast_nullable_to_non_nullable
                        as int,
            phaseDurationMs:
                null == phaseDurationMs
                    ? _value.phaseDurationMs
                    : phaseDurationMs // ignore: cast_nullable_to_non_nullable
                        as int,
            totalElapsedSec:
                null == totalElapsedSec
                    ? _value.totalElapsedSec
                    : totalElapsedSec // ignore: cast_nullable_to_non_nullable
                        as int,
            warningFired:
                null == warningFired
                    ? _value.warningFired
                    : warningFired // ignore: cast_nullable_to_non_nullable
                        as bool,
            waitingForAdvance:
                null == waitingForAdvance
                    ? _value.waitingForAdvance
                    : waitingForAdvance // ignore: cast_nullable_to_non_nullable
                        as bool,
            checkpointTimestampMs:
                null == checkpointTimestampMs
                    ? _value.checkpointTimestampMs
                    : checkpointTimestampMs // ignore: cast_nullable_to_non_nullable
                        as int,
            wasPaused:
                null == wasPaused
                    ? _value.wasPaused
                    : wasPaused // ignore: cast_nullable_to_non_nullable
                        as bool,
            sessionName:
                null == sessionName
                    ? _value.sessionName
                    : sessionName // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimerCheckpointImplCopyWith<$Res>
    implements $TimerCheckpointCopyWith<$Res> {
  factory _$$TimerCheckpointImplCopyWith(
    _$TimerCheckpointImpl value,
    $Res Function(_$TimerCheckpointImpl) then,
  ) = __$$TimerCheckpointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sessionId,
    String sessionJson,
    String enginePhase,
    int currentRound,
    int currentSegmentIndex,
    int phaseRemainingMs,
    int phaseDurationMs,
    int totalElapsedSec,
    bool warningFired,
    bool waitingForAdvance,
    int checkpointTimestampMs,
    bool wasPaused,
    String sessionName,
  });
}

/// @nodoc
class __$$TimerCheckpointImplCopyWithImpl<$Res>
    extends _$TimerCheckpointCopyWithImpl<$Res, _$TimerCheckpointImpl>
    implements _$$TimerCheckpointImplCopyWith<$Res> {
  __$$TimerCheckpointImplCopyWithImpl(
    _$TimerCheckpointImpl _value,
    $Res Function(_$TimerCheckpointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? sessionJson = null,
    Object? enginePhase = null,
    Object? currentRound = null,
    Object? currentSegmentIndex = null,
    Object? phaseRemainingMs = null,
    Object? phaseDurationMs = null,
    Object? totalElapsedSec = null,
    Object? warningFired = null,
    Object? waitingForAdvance = null,
    Object? checkpointTimestampMs = null,
    Object? wasPaused = null,
    Object? sessionName = null,
  }) {
    return _then(
      _$TimerCheckpointImpl(
        sessionId:
            null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                    as String,
        sessionJson:
            null == sessionJson
                ? _value.sessionJson
                : sessionJson // ignore: cast_nullable_to_non_nullable
                    as String,
        enginePhase:
            null == enginePhase
                ? _value.enginePhase
                : enginePhase // ignore: cast_nullable_to_non_nullable
                    as String,
        currentRound:
            null == currentRound
                ? _value.currentRound
                : currentRound // ignore: cast_nullable_to_non_nullable
                    as int,
        currentSegmentIndex:
            null == currentSegmentIndex
                ? _value.currentSegmentIndex
                : currentSegmentIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        phaseRemainingMs:
            null == phaseRemainingMs
                ? _value.phaseRemainingMs
                : phaseRemainingMs // ignore: cast_nullable_to_non_nullable
                    as int,
        phaseDurationMs:
            null == phaseDurationMs
                ? _value.phaseDurationMs
                : phaseDurationMs // ignore: cast_nullable_to_non_nullable
                    as int,
        totalElapsedSec:
            null == totalElapsedSec
                ? _value.totalElapsedSec
                : totalElapsedSec // ignore: cast_nullable_to_non_nullable
                    as int,
        warningFired:
            null == warningFired
                ? _value.warningFired
                : warningFired // ignore: cast_nullable_to_non_nullable
                    as bool,
        waitingForAdvance:
            null == waitingForAdvance
                ? _value.waitingForAdvance
                : waitingForAdvance // ignore: cast_nullable_to_non_nullable
                    as bool,
        checkpointTimestampMs:
            null == checkpointTimestampMs
                ? _value.checkpointTimestampMs
                : checkpointTimestampMs // ignore: cast_nullable_to_non_nullable
                    as int,
        wasPaused:
            null == wasPaused
                ? _value.wasPaused
                : wasPaused // ignore: cast_nullable_to_non_nullable
                    as bool,
        sessionName:
            null == sessionName
                ? _value.sessionName
                : sessionName // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimerCheckpointImpl implements _TimerCheckpoint {
  const _$TimerCheckpointImpl({
    required this.sessionId,
    required this.sessionJson,
    required this.enginePhase,
    required this.currentRound,
    required this.currentSegmentIndex,
    required this.phaseRemainingMs,
    required this.phaseDurationMs,
    required this.totalElapsedSec,
    required this.warningFired,
    required this.waitingForAdvance,
    required this.checkpointTimestampMs,
    required this.wasPaused,
    required this.sessionName,
  });

  factory _$TimerCheckpointImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimerCheckpointImplFromJson(json);

  // Which session
  @override
  final String sessionId;
  @override
  final String sessionJson;
  // Engine position
  @override
  final String enginePhase;
  // 'warmup' | 'work' | 'segment' | 'rest'
  @override
  final int currentRound;
  @override
  final int currentSegmentIndex;
  @override
  final int phaseRemainingMs;
  @override
  final int phaseDurationMs;
  @override
  final int totalElapsedSec;
  @override
  final bool warningFired;
  @override
  final bool waitingForAdvance;
  // Wall-clock anchor
  @override
  final int checkpointTimestampMs;
  @override
  final bool wasPaused;
  // Metadata
  @override
  final String sessionName;

  @override
  String toString() {
    return 'TimerCheckpoint(sessionId: $sessionId, sessionJson: $sessionJson, enginePhase: $enginePhase, currentRound: $currentRound, currentSegmentIndex: $currentSegmentIndex, phaseRemainingMs: $phaseRemainingMs, phaseDurationMs: $phaseDurationMs, totalElapsedSec: $totalElapsedSec, warningFired: $warningFired, waitingForAdvance: $waitingForAdvance, checkpointTimestampMs: $checkpointTimestampMs, wasPaused: $wasPaused, sessionName: $sessionName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerCheckpointImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionJson, sessionJson) ||
                other.sessionJson == sessionJson) &&
            (identical(other.enginePhase, enginePhase) ||
                other.enginePhase == enginePhase) &&
            (identical(other.currentRound, currentRound) ||
                other.currentRound == currentRound) &&
            (identical(other.currentSegmentIndex, currentSegmentIndex) ||
                other.currentSegmentIndex == currentSegmentIndex) &&
            (identical(other.phaseRemainingMs, phaseRemainingMs) ||
                other.phaseRemainingMs == phaseRemainingMs) &&
            (identical(other.phaseDurationMs, phaseDurationMs) ||
                other.phaseDurationMs == phaseDurationMs) &&
            (identical(other.totalElapsedSec, totalElapsedSec) ||
                other.totalElapsedSec == totalElapsedSec) &&
            (identical(other.warningFired, warningFired) ||
                other.warningFired == warningFired) &&
            (identical(other.waitingForAdvance, waitingForAdvance) ||
                other.waitingForAdvance == waitingForAdvance) &&
            (identical(other.checkpointTimestampMs, checkpointTimestampMs) ||
                other.checkpointTimestampMs == checkpointTimestampMs) &&
            (identical(other.wasPaused, wasPaused) ||
                other.wasPaused == wasPaused) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    sessionId,
    sessionJson,
    enginePhase,
    currentRound,
    currentSegmentIndex,
    phaseRemainingMs,
    phaseDurationMs,
    totalElapsedSec,
    warningFired,
    waitingForAdvance,
    checkpointTimestampMs,
    wasPaused,
    sessionName,
  );

  /// Create a copy of TimerCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerCheckpointImplCopyWith<_$TimerCheckpointImpl> get copyWith =>
      __$$TimerCheckpointImplCopyWithImpl<_$TimerCheckpointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TimerCheckpointImplToJson(this);
  }
}

abstract class _TimerCheckpoint implements TimerCheckpoint {
  const factory _TimerCheckpoint({
    required final String sessionId,
    required final String sessionJson,
    required final String enginePhase,
    required final int currentRound,
    required final int currentSegmentIndex,
    required final int phaseRemainingMs,
    required final int phaseDurationMs,
    required final int totalElapsedSec,
    required final bool warningFired,
    required final bool waitingForAdvance,
    required final int checkpointTimestampMs,
    required final bool wasPaused,
    required final String sessionName,
  }) = _$TimerCheckpointImpl;

  factory _TimerCheckpoint.fromJson(Map<String, dynamic> json) =
      _$TimerCheckpointImpl.fromJson;

  // Which session
  @override
  String get sessionId;
  @override
  String get sessionJson; // Engine position
  @override
  String get enginePhase; // 'warmup' | 'work' | 'segment' | 'rest'
  @override
  int get currentRound;
  @override
  int get currentSegmentIndex;
  @override
  int get phaseRemainingMs;
  @override
  int get phaseDurationMs;
  @override
  int get totalElapsedSec;
  @override
  bool get warningFired;
  @override
  bool get waitingForAdvance; // Wall-clock anchor
  @override
  int get checkpointTimestampMs;
  @override
  bool get wasPaused; // Metadata
  @override
  String get sessionName;

  /// Create a copy of TimerCheckpoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerCheckpointImplCopyWith<_$TimerCheckpointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
