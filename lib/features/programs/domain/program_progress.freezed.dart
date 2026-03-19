// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'program_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProgramProgress _$ProgramProgressFromJson(Map<String, dynamic> json) {
  return _ProgramProgress.fromJson(json);
}

/// @nodoc
mixin _$ProgramProgress {
  String get programId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  Map<String, DateTime> get completedDays => throw _privateConstructorUsedError;

  /// Serializes this ProgramProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgramProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgramProgressCopyWith<ProgramProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgramProgressCopyWith<$Res> {
  factory $ProgramProgressCopyWith(
    ProgramProgress value,
    $Res Function(ProgramProgress) then,
  ) = _$ProgramProgressCopyWithImpl<$Res, ProgramProgress>;
  @useResult
  $Res call({
    String programId,
    DateTime startedAt,
    Map<String, DateTime> completedDays,
  });
}

/// @nodoc
class _$ProgramProgressCopyWithImpl<$Res, $Val extends ProgramProgress>
    implements $ProgramProgressCopyWith<$Res> {
  _$ProgramProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgramProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? programId = null,
    Object? startedAt = null,
    Object? completedDays = null,
  }) {
    return _then(
      _value.copyWith(
            programId:
                null == programId
                    ? _value.programId
                    : programId // ignore: cast_nullable_to_non_nullable
                        as String,
            startedAt:
                null == startedAt
                    ? _value.startedAt
                    : startedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            completedDays:
                null == completedDays
                    ? _value.completedDays
                    : completedDays // ignore: cast_nullable_to_non_nullable
                        as Map<String, DateTime>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProgramProgressImplCopyWith<$Res>
    implements $ProgramProgressCopyWith<$Res> {
  factory _$$ProgramProgressImplCopyWith(
    _$ProgramProgressImpl value,
    $Res Function(_$ProgramProgressImpl) then,
  ) = __$$ProgramProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String programId,
    DateTime startedAt,
    Map<String, DateTime> completedDays,
  });
}

/// @nodoc
class __$$ProgramProgressImplCopyWithImpl<$Res>
    extends _$ProgramProgressCopyWithImpl<$Res, _$ProgramProgressImpl>
    implements _$$ProgramProgressImplCopyWith<$Res> {
  __$$ProgramProgressImplCopyWithImpl(
    _$ProgramProgressImpl _value,
    $Res Function(_$ProgramProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProgramProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? programId = null,
    Object? startedAt = null,
    Object? completedDays = null,
  }) {
    return _then(
      _$ProgramProgressImpl(
        programId:
            null == programId
                ? _value.programId
                : programId // ignore: cast_nullable_to_non_nullable
                    as String,
        startedAt:
            null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        completedDays:
            null == completedDays
                ? _value._completedDays
                : completedDays // ignore: cast_nullable_to_non_nullable
                    as Map<String, DateTime>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgramProgressImpl extends _ProgramProgress {
  const _$ProgramProgressImpl({
    required this.programId,
    required this.startedAt,
    final Map<String, DateTime> completedDays = const {},
  }) : _completedDays = completedDays,
       super._();

  factory _$ProgramProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgramProgressImplFromJson(json);

  @override
  final String programId;
  @override
  final DateTime startedAt;
  final Map<String, DateTime> _completedDays;
  @override
  @JsonKey()
  Map<String, DateTime> get completedDays {
    if (_completedDays is EqualUnmodifiableMapView) return _completedDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_completedDays);
  }

  @override
  String toString() {
    return 'ProgramProgress(programId: $programId, startedAt: $startedAt, completedDays: $completedDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgramProgressImpl &&
            (identical(other.programId, programId) ||
                other.programId == programId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            const DeepCollectionEquality().equals(
              other._completedDays,
              _completedDays,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    programId,
    startedAt,
    const DeepCollectionEquality().hash(_completedDays),
  );

  /// Create a copy of ProgramProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgramProgressImplCopyWith<_$ProgramProgressImpl> get copyWith =>
      __$$ProgramProgressImplCopyWithImpl<_$ProgramProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgramProgressImplToJson(this);
  }
}

abstract class _ProgramProgress extends ProgramProgress {
  const factory _ProgramProgress({
    required final String programId,
    required final DateTime startedAt,
    final Map<String, DateTime> completedDays,
  }) = _$ProgramProgressImpl;
  const _ProgramProgress._() : super._();

  factory _ProgramProgress.fromJson(Map<String, dynamic> json) =
      _$ProgramProgressImpl.fromJson;

  @override
  String get programId;
  @override
  DateTime get startedAt;
  @override
  Map<String, DateTime> get completedDays;

  /// Create a copy of ProgramProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgramProgressImplCopyWith<_$ProgramProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
