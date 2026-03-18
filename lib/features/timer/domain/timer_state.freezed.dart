// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TimerPhase {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration remaining) warmup,
    required TResult Function(
      int roundNumber,
      Duration remaining,
      bool isWarning,
    )
    work,
    required TResult Function(int afterRound, Duration remaining) rest,
    required TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )
    segment,
    required TResult Function(TimerPhase previousPhase) paused,
    required TResult Function(int totalRounds) completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration remaining)? warmup,
    TResult? Function(int roundNumber, Duration remaining, bool isWarning)?
    work,
    TResult? Function(int afterRound, Duration remaining)? rest,
    TResult? Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult? Function(TimerPhase previousPhase)? paused,
    TResult? Function(int totalRounds)? completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration remaining)? warmup,
    TResult Function(int roundNumber, Duration remaining, bool isWarning)? work,
    TResult Function(int afterRound, Duration remaining)? rest,
    TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult Function(TimerPhase previousPhase)? paused,
    TResult Function(int totalRounds)? completed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerWarmup value) warmup,
    required TResult Function(TimerWork value) work,
    required TResult Function(TimerRest value) rest,
    required TResult Function(TimerSegment value) segment,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerCompleted value) completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerWarmup value)? warmup,
    TResult? Function(TimerWork value)? work,
    TResult? Function(TimerRest value)? rest,
    TResult? Function(TimerSegment value)? segment,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerCompleted value)? completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerWarmup value)? warmup,
    TResult Function(TimerWork value)? work,
    TResult Function(TimerRest value)? rest,
    TResult Function(TimerSegment value)? segment,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerCompleted value)? completed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimerPhaseCopyWith<$Res> {
  factory $TimerPhaseCopyWith(
    TimerPhase value,
    $Res Function(TimerPhase) then,
  ) = _$TimerPhaseCopyWithImpl<$Res, TimerPhase>;
}

/// @nodoc
class _$TimerPhaseCopyWithImpl<$Res, $Val extends TimerPhase>
    implements $TimerPhaseCopyWith<$Res> {
  _$TimerPhaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$TimerIdleImplCopyWith<$Res> {
  factory _$$TimerIdleImplCopyWith(
    _$TimerIdleImpl value,
    $Res Function(_$TimerIdleImpl) then,
  ) = __$$TimerIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$TimerIdleImplCopyWithImpl<$Res>
    extends _$TimerPhaseCopyWithImpl<$Res, _$TimerIdleImpl>
    implements _$$TimerIdleImplCopyWith<$Res> {
  __$$TimerIdleImplCopyWithImpl(
    _$TimerIdleImpl _value,
    $Res Function(_$TimerIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$TimerIdleImpl implements TimerIdle {
  const _$TimerIdleImpl();

  @override
  String toString() {
    return 'TimerPhase.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$TimerIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration remaining) warmup,
    required TResult Function(
      int roundNumber,
      Duration remaining,
      bool isWarning,
    )
    work,
    required TResult Function(int afterRound, Duration remaining) rest,
    required TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )
    segment,
    required TResult Function(TimerPhase previousPhase) paused,
    required TResult Function(int totalRounds) completed,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration remaining)? warmup,
    TResult? Function(int roundNumber, Duration remaining, bool isWarning)?
    work,
    TResult? Function(int afterRound, Duration remaining)? rest,
    TResult? Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult? Function(TimerPhase previousPhase)? paused,
    TResult? Function(int totalRounds)? completed,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration remaining)? warmup,
    TResult Function(int roundNumber, Duration remaining, bool isWarning)? work,
    TResult Function(int afterRound, Duration remaining)? rest,
    TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult Function(TimerPhase previousPhase)? paused,
    TResult Function(int totalRounds)? completed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerWarmup value) warmup,
    required TResult Function(TimerWork value) work,
    required TResult Function(TimerRest value) rest,
    required TResult Function(TimerSegment value) segment,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerCompleted value) completed,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerWarmup value)? warmup,
    TResult? Function(TimerWork value)? work,
    TResult? Function(TimerRest value)? rest,
    TResult? Function(TimerSegment value)? segment,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerCompleted value)? completed,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerWarmup value)? warmup,
    TResult Function(TimerWork value)? work,
    TResult Function(TimerRest value)? rest,
    TResult Function(TimerSegment value)? segment,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class TimerIdle implements TimerPhase {
  const factory TimerIdle() = _$TimerIdleImpl;
}

/// @nodoc
abstract class _$$TimerWarmupImplCopyWith<$Res> {
  factory _$$TimerWarmupImplCopyWith(
    _$TimerWarmupImpl value,
    $Res Function(_$TimerWarmupImpl) then,
  ) = __$$TimerWarmupImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Duration remaining});
}

/// @nodoc
class __$$TimerWarmupImplCopyWithImpl<$Res>
    extends _$TimerPhaseCopyWithImpl<$Res, _$TimerWarmupImpl>
    implements _$$TimerWarmupImplCopyWith<$Res> {
  __$$TimerWarmupImplCopyWithImpl(
    _$TimerWarmupImpl _value,
    $Res Function(_$TimerWarmupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? remaining = null}) {
    return _then(
      _$TimerWarmupImpl(
        remaining:
            null == remaining
                ? _value.remaining
                : remaining // ignore: cast_nullable_to_non_nullable
                    as Duration,
      ),
    );
  }
}

/// @nodoc

class _$TimerWarmupImpl implements TimerWarmup {
  const _$TimerWarmupImpl({required this.remaining});

  @override
  final Duration remaining;

  @override
  String toString() {
    return 'TimerPhase.warmup(remaining: $remaining)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerWarmupImpl &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining));
  }

  @override
  int get hashCode => Object.hash(runtimeType, remaining);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerWarmupImplCopyWith<_$TimerWarmupImpl> get copyWith =>
      __$$TimerWarmupImplCopyWithImpl<_$TimerWarmupImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration remaining) warmup,
    required TResult Function(
      int roundNumber,
      Duration remaining,
      bool isWarning,
    )
    work,
    required TResult Function(int afterRound, Duration remaining) rest,
    required TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )
    segment,
    required TResult Function(TimerPhase previousPhase) paused,
    required TResult Function(int totalRounds) completed,
  }) {
    return warmup(remaining);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration remaining)? warmup,
    TResult? Function(int roundNumber, Duration remaining, bool isWarning)?
    work,
    TResult? Function(int afterRound, Duration remaining)? rest,
    TResult? Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult? Function(TimerPhase previousPhase)? paused,
    TResult? Function(int totalRounds)? completed,
  }) {
    return warmup?.call(remaining);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration remaining)? warmup,
    TResult Function(int roundNumber, Duration remaining, bool isWarning)? work,
    TResult Function(int afterRound, Duration remaining)? rest,
    TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult Function(TimerPhase previousPhase)? paused,
    TResult Function(int totalRounds)? completed,
    required TResult orElse(),
  }) {
    if (warmup != null) {
      return warmup(remaining);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerWarmup value) warmup,
    required TResult Function(TimerWork value) work,
    required TResult Function(TimerRest value) rest,
    required TResult Function(TimerSegment value) segment,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerCompleted value) completed,
  }) {
    return warmup(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerWarmup value)? warmup,
    TResult? Function(TimerWork value)? work,
    TResult? Function(TimerRest value)? rest,
    TResult? Function(TimerSegment value)? segment,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerCompleted value)? completed,
  }) {
    return warmup?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerWarmup value)? warmup,
    TResult Function(TimerWork value)? work,
    TResult Function(TimerRest value)? rest,
    TResult Function(TimerSegment value)? segment,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (warmup != null) {
      return warmup(this);
    }
    return orElse();
  }
}

abstract class TimerWarmup implements TimerPhase {
  const factory TimerWarmup({required final Duration remaining}) =
      _$TimerWarmupImpl;

  Duration get remaining;

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerWarmupImplCopyWith<_$TimerWarmupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerWorkImplCopyWith<$Res> {
  factory _$$TimerWorkImplCopyWith(
    _$TimerWorkImpl value,
    $Res Function(_$TimerWorkImpl) then,
  ) = __$$TimerWorkImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int roundNumber, Duration remaining, bool isWarning});
}

/// @nodoc
class __$$TimerWorkImplCopyWithImpl<$Res>
    extends _$TimerPhaseCopyWithImpl<$Res, _$TimerWorkImpl>
    implements _$$TimerWorkImplCopyWith<$Res> {
  __$$TimerWorkImplCopyWithImpl(
    _$TimerWorkImpl _value,
    $Res Function(_$TimerWorkImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? remaining = null,
    Object? isWarning = null,
  }) {
    return _then(
      _$TimerWorkImpl(
        roundNumber:
            null == roundNumber
                ? _value.roundNumber
                : roundNumber // ignore: cast_nullable_to_non_nullable
                    as int,
        remaining:
            null == remaining
                ? _value.remaining
                : remaining // ignore: cast_nullable_to_non_nullable
                    as Duration,
        isWarning:
            null == isWarning
                ? _value.isWarning
                : isWarning // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$TimerWorkImpl implements TimerWork {
  const _$TimerWorkImpl({
    required this.roundNumber,
    required this.remaining,
    required this.isWarning,
  });

  @override
  final int roundNumber;
  @override
  final Duration remaining;
  @override
  final bool isWarning;

  @override
  String toString() {
    return 'TimerPhase.work(roundNumber: $roundNumber, remaining: $remaining, isWarning: $isWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerWorkImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.isWarning, isWarning) ||
                other.isWarning == isWarning));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, roundNumber, remaining, isWarning);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerWorkImplCopyWith<_$TimerWorkImpl> get copyWith =>
      __$$TimerWorkImplCopyWithImpl<_$TimerWorkImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration remaining) warmup,
    required TResult Function(
      int roundNumber,
      Duration remaining,
      bool isWarning,
    )
    work,
    required TResult Function(int afterRound, Duration remaining) rest,
    required TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )
    segment,
    required TResult Function(TimerPhase previousPhase) paused,
    required TResult Function(int totalRounds) completed,
  }) {
    return work(roundNumber, remaining, isWarning);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration remaining)? warmup,
    TResult? Function(int roundNumber, Duration remaining, bool isWarning)?
    work,
    TResult? Function(int afterRound, Duration remaining)? rest,
    TResult? Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult? Function(TimerPhase previousPhase)? paused,
    TResult? Function(int totalRounds)? completed,
  }) {
    return work?.call(roundNumber, remaining, isWarning);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration remaining)? warmup,
    TResult Function(int roundNumber, Duration remaining, bool isWarning)? work,
    TResult Function(int afterRound, Duration remaining)? rest,
    TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult Function(TimerPhase previousPhase)? paused,
    TResult Function(int totalRounds)? completed,
    required TResult orElse(),
  }) {
    if (work != null) {
      return work(roundNumber, remaining, isWarning);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerWarmup value) warmup,
    required TResult Function(TimerWork value) work,
    required TResult Function(TimerRest value) rest,
    required TResult Function(TimerSegment value) segment,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerCompleted value) completed,
  }) {
    return work(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerWarmup value)? warmup,
    TResult? Function(TimerWork value)? work,
    TResult? Function(TimerRest value)? rest,
    TResult? Function(TimerSegment value)? segment,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerCompleted value)? completed,
  }) {
    return work?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerWarmup value)? warmup,
    TResult Function(TimerWork value)? work,
    TResult Function(TimerRest value)? rest,
    TResult Function(TimerSegment value)? segment,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (work != null) {
      return work(this);
    }
    return orElse();
  }
}

abstract class TimerWork implements TimerPhase {
  const factory TimerWork({
    required final int roundNumber,
    required final Duration remaining,
    required final bool isWarning,
  }) = _$TimerWorkImpl;

  int get roundNumber;
  Duration get remaining;
  bool get isWarning;

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerWorkImplCopyWith<_$TimerWorkImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerRestImplCopyWith<$Res> {
  factory _$$TimerRestImplCopyWith(
    _$TimerRestImpl value,
    $Res Function(_$TimerRestImpl) then,
  ) = __$$TimerRestImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int afterRound, Duration remaining});
}

/// @nodoc
class __$$TimerRestImplCopyWithImpl<$Res>
    extends _$TimerPhaseCopyWithImpl<$Res, _$TimerRestImpl>
    implements _$$TimerRestImplCopyWith<$Res> {
  __$$TimerRestImplCopyWithImpl(
    _$TimerRestImpl _value,
    $Res Function(_$TimerRestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? afterRound = null, Object? remaining = null}) {
    return _then(
      _$TimerRestImpl(
        afterRound:
            null == afterRound
                ? _value.afterRound
                : afterRound // ignore: cast_nullable_to_non_nullable
                    as int,
        remaining:
            null == remaining
                ? _value.remaining
                : remaining // ignore: cast_nullable_to_non_nullable
                    as Duration,
      ),
    );
  }
}

/// @nodoc

class _$TimerRestImpl implements TimerRest {
  const _$TimerRestImpl({required this.afterRound, required this.remaining});

  @override
  final int afterRound;
  @override
  final Duration remaining;

  @override
  String toString() {
    return 'TimerPhase.rest(afterRound: $afterRound, remaining: $remaining)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerRestImpl &&
            (identical(other.afterRound, afterRound) ||
                other.afterRound == afterRound) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining));
  }

  @override
  int get hashCode => Object.hash(runtimeType, afterRound, remaining);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerRestImplCopyWith<_$TimerRestImpl> get copyWith =>
      __$$TimerRestImplCopyWithImpl<_$TimerRestImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration remaining) warmup,
    required TResult Function(
      int roundNumber,
      Duration remaining,
      bool isWarning,
    )
    work,
    required TResult Function(int afterRound, Duration remaining) rest,
    required TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )
    segment,
    required TResult Function(TimerPhase previousPhase) paused,
    required TResult Function(int totalRounds) completed,
  }) {
    return rest(afterRound, remaining);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration remaining)? warmup,
    TResult? Function(int roundNumber, Duration remaining, bool isWarning)?
    work,
    TResult? Function(int afterRound, Duration remaining)? rest,
    TResult? Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult? Function(TimerPhase previousPhase)? paused,
    TResult? Function(int totalRounds)? completed,
  }) {
    return rest?.call(afterRound, remaining);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration remaining)? warmup,
    TResult Function(int roundNumber, Duration remaining, bool isWarning)? work,
    TResult Function(int afterRound, Duration remaining)? rest,
    TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult Function(TimerPhase previousPhase)? paused,
    TResult Function(int totalRounds)? completed,
    required TResult orElse(),
  }) {
    if (rest != null) {
      return rest(afterRound, remaining);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerWarmup value) warmup,
    required TResult Function(TimerWork value) work,
    required TResult Function(TimerRest value) rest,
    required TResult Function(TimerSegment value) segment,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerCompleted value) completed,
  }) {
    return rest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerWarmup value)? warmup,
    TResult? Function(TimerWork value)? work,
    TResult? Function(TimerRest value)? rest,
    TResult? Function(TimerSegment value)? segment,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerCompleted value)? completed,
  }) {
    return rest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerWarmup value)? warmup,
    TResult Function(TimerWork value)? work,
    TResult Function(TimerRest value)? rest,
    TResult Function(TimerSegment value)? segment,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (rest != null) {
      return rest(this);
    }
    return orElse();
  }
}

abstract class TimerRest implements TimerPhase {
  const factory TimerRest({
    required final int afterRound,
    required final Duration remaining,
  }) = _$TimerRestImpl;

  int get afterRound;
  Duration get remaining;

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerRestImplCopyWith<_$TimerRestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerSegmentImplCopyWith<$Res> {
  factory _$$TimerSegmentImplCopyWith(
    _$TimerSegmentImpl value,
    $Res Function(_$TimerSegmentImpl) then,
  ) = __$$TimerSegmentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    int roundNumber,
    int segmentIndex,
    int totalSegments,
    String segmentLabel,
    Duration remaining,
    bool isWarning,
  });
}

/// @nodoc
class __$$TimerSegmentImplCopyWithImpl<$Res>
    extends _$TimerPhaseCopyWithImpl<$Res, _$TimerSegmentImpl>
    implements _$$TimerSegmentImplCopyWith<$Res> {
  __$$TimerSegmentImplCopyWithImpl(
    _$TimerSegmentImpl _value,
    $Res Function(_$TimerSegmentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? segmentIndex = null,
    Object? totalSegments = null,
    Object? segmentLabel = null,
    Object? remaining = null,
    Object? isWarning = null,
  }) {
    return _then(
      _$TimerSegmentImpl(
        roundNumber:
            null == roundNumber
                ? _value.roundNumber
                : roundNumber // ignore: cast_nullable_to_non_nullable
                    as int,
        segmentIndex:
            null == segmentIndex
                ? _value.segmentIndex
                : segmentIndex // ignore: cast_nullable_to_non_nullable
                    as int,
        totalSegments:
            null == totalSegments
                ? _value.totalSegments
                : totalSegments // ignore: cast_nullable_to_non_nullable
                    as int,
        segmentLabel:
            null == segmentLabel
                ? _value.segmentLabel
                : segmentLabel // ignore: cast_nullable_to_non_nullable
                    as String,
        remaining:
            null == remaining
                ? _value.remaining
                : remaining // ignore: cast_nullable_to_non_nullable
                    as Duration,
        isWarning:
            null == isWarning
                ? _value.isWarning
                : isWarning // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$TimerSegmentImpl implements TimerSegment {
  const _$TimerSegmentImpl({
    required this.roundNumber,
    required this.segmentIndex,
    required this.totalSegments,
    required this.segmentLabel,
    required this.remaining,
    required this.isWarning,
  });

  @override
  final int roundNumber;
  @override
  final int segmentIndex;
  @override
  final int totalSegments;
  @override
  final String segmentLabel;
  @override
  final Duration remaining;
  @override
  final bool isWarning;

  @override
  String toString() {
    return 'TimerPhase.segment(roundNumber: $roundNumber, segmentIndex: $segmentIndex, totalSegments: $totalSegments, segmentLabel: $segmentLabel, remaining: $remaining, isWarning: $isWarning)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerSegmentImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.segmentIndex, segmentIndex) ||
                other.segmentIndex == segmentIndex) &&
            (identical(other.totalSegments, totalSegments) ||
                other.totalSegments == totalSegments) &&
            (identical(other.segmentLabel, segmentLabel) ||
                other.segmentLabel == segmentLabel) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.isWarning, isWarning) ||
                other.isWarning == isWarning));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    roundNumber,
    segmentIndex,
    totalSegments,
    segmentLabel,
    remaining,
    isWarning,
  );

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerSegmentImplCopyWith<_$TimerSegmentImpl> get copyWith =>
      __$$TimerSegmentImplCopyWithImpl<_$TimerSegmentImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration remaining) warmup,
    required TResult Function(
      int roundNumber,
      Duration remaining,
      bool isWarning,
    )
    work,
    required TResult Function(int afterRound, Duration remaining) rest,
    required TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )
    segment,
    required TResult Function(TimerPhase previousPhase) paused,
    required TResult Function(int totalRounds) completed,
  }) {
    return segment(
      roundNumber,
      segmentIndex,
      totalSegments,
      segmentLabel,
      remaining,
      isWarning,
    );
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration remaining)? warmup,
    TResult? Function(int roundNumber, Duration remaining, bool isWarning)?
    work,
    TResult? Function(int afterRound, Duration remaining)? rest,
    TResult? Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult? Function(TimerPhase previousPhase)? paused,
    TResult? Function(int totalRounds)? completed,
  }) {
    return segment?.call(
      roundNumber,
      segmentIndex,
      totalSegments,
      segmentLabel,
      remaining,
      isWarning,
    );
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration remaining)? warmup,
    TResult Function(int roundNumber, Duration remaining, bool isWarning)? work,
    TResult Function(int afterRound, Duration remaining)? rest,
    TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult Function(TimerPhase previousPhase)? paused,
    TResult Function(int totalRounds)? completed,
    required TResult orElse(),
  }) {
    if (segment != null) {
      return segment(
        roundNumber,
        segmentIndex,
        totalSegments,
        segmentLabel,
        remaining,
        isWarning,
      );
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerWarmup value) warmup,
    required TResult Function(TimerWork value) work,
    required TResult Function(TimerRest value) rest,
    required TResult Function(TimerSegment value) segment,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerCompleted value) completed,
  }) {
    return segment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerWarmup value)? warmup,
    TResult? Function(TimerWork value)? work,
    TResult? Function(TimerRest value)? rest,
    TResult? Function(TimerSegment value)? segment,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerCompleted value)? completed,
  }) {
    return segment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerWarmup value)? warmup,
    TResult Function(TimerWork value)? work,
    TResult Function(TimerRest value)? rest,
    TResult Function(TimerSegment value)? segment,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (segment != null) {
      return segment(this);
    }
    return orElse();
  }
}

abstract class TimerSegment implements TimerPhase {
  const factory TimerSegment({
    required final int roundNumber,
    required final int segmentIndex,
    required final int totalSegments,
    required final String segmentLabel,
    required final Duration remaining,
    required final bool isWarning,
  }) = _$TimerSegmentImpl;

  int get roundNumber;
  int get segmentIndex;
  int get totalSegments;
  String get segmentLabel;
  Duration get remaining;
  bool get isWarning;

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerSegmentImplCopyWith<_$TimerSegmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerPausedImplCopyWith<$Res> {
  factory _$$TimerPausedImplCopyWith(
    _$TimerPausedImpl value,
    $Res Function(_$TimerPausedImpl) then,
  ) = __$$TimerPausedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TimerPhase previousPhase});

  $TimerPhaseCopyWith<$Res> get previousPhase;
}

/// @nodoc
class __$$TimerPausedImplCopyWithImpl<$Res>
    extends _$TimerPhaseCopyWithImpl<$Res, _$TimerPausedImpl>
    implements _$$TimerPausedImplCopyWith<$Res> {
  __$$TimerPausedImplCopyWithImpl(
    _$TimerPausedImpl _value,
    $Res Function(_$TimerPausedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? previousPhase = null}) {
    return _then(
      _$TimerPausedImpl(
        previousPhase:
            null == previousPhase
                ? _value.previousPhase
                : previousPhase // ignore: cast_nullable_to_non_nullable
                    as TimerPhase,
      ),
    );
  }

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimerPhaseCopyWith<$Res> get previousPhase {
    return $TimerPhaseCopyWith<$Res>(_value.previousPhase, (value) {
      return _then(_value.copyWith(previousPhase: value));
    });
  }
}

/// @nodoc

class _$TimerPausedImpl implements TimerPaused {
  const _$TimerPausedImpl({required this.previousPhase});

  @override
  final TimerPhase previousPhase;

  @override
  String toString() {
    return 'TimerPhase.paused(previousPhase: $previousPhase)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerPausedImpl &&
            (identical(other.previousPhase, previousPhase) ||
                other.previousPhase == previousPhase));
  }

  @override
  int get hashCode => Object.hash(runtimeType, previousPhase);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerPausedImplCopyWith<_$TimerPausedImpl> get copyWith =>
      __$$TimerPausedImplCopyWithImpl<_$TimerPausedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration remaining) warmup,
    required TResult Function(
      int roundNumber,
      Duration remaining,
      bool isWarning,
    )
    work,
    required TResult Function(int afterRound, Duration remaining) rest,
    required TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )
    segment,
    required TResult Function(TimerPhase previousPhase) paused,
    required TResult Function(int totalRounds) completed,
  }) {
    return paused(previousPhase);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration remaining)? warmup,
    TResult? Function(int roundNumber, Duration remaining, bool isWarning)?
    work,
    TResult? Function(int afterRound, Duration remaining)? rest,
    TResult? Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult? Function(TimerPhase previousPhase)? paused,
    TResult? Function(int totalRounds)? completed,
  }) {
    return paused?.call(previousPhase);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration remaining)? warmup,
    TResult Function(int roundNumber, Duration remaining, bool isWarning)? work,
    TResult Function(int afterRound, Duration remaining)? rest,
    TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult Function(TimerPhase previousPhase)? paused,
    TResult Function(int totalRounds)? completed,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(previousPhase);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerWarmup value) warmup,
    required TResult Function(TimerWork value) work,
    required TResult Function(TimerRest value) rest,
    required TResult Function(TimerSegment value) segment,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerCompleted value) completed,
  }) {
    return paused(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerWarmup value)? warmup,
    TResult? Function(TimerWork value)? work,
    TResult? Function(TimerRest value)? rest,
    TResult? Function(TimerSegment value)? segment,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerCompleted value)? completed,
  }) {
    return paused?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerWarmup value)? warmup,
    TResult Function(TimerWork value)? work,
    TResult Function(TimerRest value)? rest,
    TResult Function(TimerSegment value)? segment,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (paused != null) {
      return paused(this);
    }
    return orElse();
  }
}

abstract class TimerPaused implements TimerPhase {
  const factory TimerPaused({required final TimerPhase previousPhase}) =
      _$TimerPausedImpl;

  TimerPhase get previousPhase;

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerPausedImplCopyWith<_$TimerPausedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimerCompletedImplCopyWith<$Res> {
  factory _$$TimerCompletedImplCopyWith(
    _$TimerCompletedImpl value,
    $Res Function(_$TimerCompletedImpl) then,
  ) = __$$TimerCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int totalRounds});
}

/// @nodoc
class __$$TimerCompletedImplCopyWithImpl<$Res>
    extends _$TimerPhaseCopyWithImpl<$Res, _$TimerCompletedImpl>
    implements _$$TimerCompletedImplCopyWith<$Res> {
  __$$TimerCompletedImplCopyWithImpl(
    _$TimerCompletedImpl _value,
    $Res Function(_$TimerCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? totalRounds = null}) {
    return _then(
      _$TimerCompletedImpl(
        totalRounds:
            null == totalRounds
                ? _value.totalRounds
                : totalRounds // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc

class _$TimerCompletedImpl implements TimerCompleted {
  const _$TimerCompletedImpl({required this.totalRounds});

  @override
  final int totalRounds;

  @override
  String toString() {
    return 'TimerPhase.completed(totalRounds: $totalRounds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimerCompletedImpl &&
            (identical(other.totalRounds, totalRounds) ||
                other.totalRounds == totalRounds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalRounds);

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimerCompletedImplCopyWith<_$TimerCompletedImpl> get copyWith =>
      __$$TimerCompletedImplCopyWithImpl<_$TimerCompletedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Duration remaining) warmup,
    required TResult Function(
      int roundNumber,
      Duration remaining,
      bool isWarning,
    )
    work,
    required TResult Function(int afterRound, Duration remaining) rest,
    required TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )
    segment,
    required TResult Function(TimerPhase previousPhase) paused,
    required TResult Function(int totalRounds) completed,
  }) {
    return completed(totalRounds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Duration remaining)? warmup,
    TResult? Function(int roundNumber, Duration remaining, bool isWarning)?
    work,
    TResult? Function(int afterRound, Duration remaining)? rest,
    TResult? Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult? Function(TimerPhase previousPhase)? paused,
    TResult? Function(int totalRounds)? completed,
  }) {
    return completed?.call(totalRounds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Duration remaining)? warmup,
    TResult Function(int roundNumber, Duration remaining, bool isWarning)? work,
    TResult Function(int afterRound, Duration remaining)? rest,
    TResult Function(
      int roundNumber,
      int segmentIndex,
      int totalSegments,
      String segmentLabel,
      Duration remaining,
      bool isWarning,
    )?
    segment,
    TResult Function(TimerPhase previousPhase)? paused,
    TResult Function(int totalRounds)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(totalRounds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TimerIdle value) idle,
    required TResult Function(TimerWarmup value) warmup,
    required TResult Function(TimerWork value) work,
    required TResult Function(TimerRest value) rest,
    required TResult Function(TimerSegment value) segment,
    required TResult Function(TimerPaused value) paused,
    required TResult Function(TimerCompleted value) completed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(TimerIdle value)? idle,
    TResult? Function(TimerWarmup value)? warmup,
    TResult? Function(TimerWork value)? work,
    TResult? Function(TimerRest value)? rest,
    TResult? Function(TimerSegment value)? segment,
    TResult? Function(TimerPaused value)? paused,
    TResult? Function(TimerCompleted value)? completed,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TimerIdle value)? idle,
    TResult Function(TimerWarmup value)? warmup,
    TResult Function(TimerWork value)? work,
    TResult Function(TimerRest value)? rest,
    TResult Function(TimerSegment value)? segment,
    TResult Function(TimerPaused value)? paused,
    TResult Function(TimerCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class TimerCompleted implements TimerPhase {
  const factory TimerCompleted({required final int totalRounds}) =
      _$TimerCompletedImpl;

  int get totalRounds;

  /// Create a copy of TimerPhase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimerCompletedImplCopyWith<_$TimerCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
