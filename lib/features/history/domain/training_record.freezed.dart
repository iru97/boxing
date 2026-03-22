// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TrainingRecord _$TrainingRecordFromJson(Map<String, dynamic> json) {
  return _TrainingRecord.fromJson(json);
}

/// @nodoc
mixin _$TrainingRecord {
  String get id => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get sessionName => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  int get durationCompletedSec => throw _privateConstructorUsedError;
  int get roundsCompleted => throw _privateConstructorUsedError;
  int get totalRounds => throw _privateConstructorUsedError;
  bool get completedFully => throw _privateConstructorUsedError;
  int? get combosCompleted => throw _privateConstructorUsedError;
  String? get comboDifficulty => throw _privateConstructorUsedError;
  String? get comboSport => throw _privateConstructorUsedError;

  /// Serializes this TrainingRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingRecordCopyWith<TrainingRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingRecordCopyWith<$Res> {
  factory $TrainingRecordCopyWith(
    TrainingRecord value,
    $Res Function(TrainingRecord) then,
  ) = _$TrainingRecordCopyWithImpl<$Res, TrainingRecord>;
  @useResult
  $Res call({
    String id,
    String sessionId,
    String sessionName,
    DateTime date,
    int durationCompletedSec,
    int roundsCompleted,
    int totalRounds,
    bool completedFully,
    int? combosCompleted,
    String? comboDifficulty,
    String? comboSport,
  });
}

/// @nodoc
class _$TrainingRecordCopyWithImpl<$Res, $Val extends TrainingRecord>
    implements $TrainingRecordCopyWith<$Res> {
  _$TrainingRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? sessionName = null,
    Object? date = null,
    Object? durationCompletedSec = null,
    Object? roundsCompleted = null,
    Object? totalRounds = null,
    Object? completedFully = null,
    Object? combosCompleted = freezed,
    Object? comboDifficulty = freezed,
    Object? comboSport = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            sessionId:
                null == sessionId
                    ? _value.sessionId
                    : sessionId // ignore: cast_nullable_to_non_nullable
                        as String,
            sessionName:
                null == sessionName
                    ? _value.sessionName
                    : sessionName // ignore: cast_nullable_to_non_nullable
                        as String,
            date:
                null == date
                    ? _value.date
                    : date // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            durationCompletedSec:
                null == durationCompletedSec
                    ? _value.durationCompletedSec
                    : durationCompletedSec // ignore: cast_nullable_to_non_nullable
                        as int,
            roundsCompleted:
                null == roundsCompleted
                    ? _value.roundsCompleted
                    : roundsCompleted // ignore: cast_nullable_to_non_nullable
                        as int,
            totalRounds:
                null == totalRounds
                    ? _value.totalRounds
                    : totalRounds // ignore: cast_nullable_to_non_nullable
                        as int,
            completedFully:
                null == completedFully
                    ? _value.completedFully
                    : completedFully // ignore: cast_nullable_to_non_nullable
                        as bool,
            combosCompleted:
                freezed == combosCompleted
                    ? _value.combosCompleted
                    : combosCompleted // ignore: cast_nullable_to_non_nullable
                        as int?,
            comboDifficulty:
                freezed == comboDifficulty
                    ? _value.comboDifficulty
                    : comboDifficulty // ignore: cast_nullable_to_non_nullable
                        as String?,
            comboSport:
                freezed == comboSport
                    ? _value.comboSport
                    : comboSport // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TrainingRecordImplCopyWith<$Res>
    implements $TrainingRecordCopyWith<$Res> {
  factory _$$TrainingRecordImplCopyWith(
    _$TrainingRecordImpl value,
    $Res Function(_$TrainingRecordImpl) then,
  ) = __$$TrainingRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sessionId,
    String sessionName,
    DateTime date,
    int durationCompletedSec,
    int roundsCompleted,
    int totalRounds,
    bool completedFully,
    int? combosCompleted,
    String? comboDifficulty,
    String? comboSport,
  });
}

/// @nodoc
class __$$TrainingRecordImplCopyWithImpl<$Res>
    extends _$TrainingRecordCopyWithImpl<$Res, _$TrainingRecordImpl>
    implements _$$TrainingRecordImplCopyWith<$Res> {
  __$$TrainingRecordImplCopyWithImpl(
    _$TrainingRecordImpl _value,
    $Res Function(_$TrainingRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrainingRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? sessionName = null,
    Object? date = null,
    Object? durationCompletedSec = null,
    Object? roundsCompleted = null,
    Object? totalRounds = null,
    Object? completedFully = null,
    Object? combosCompleted = freezed,
    Object? comboDifficulty = freezed,
    Object? comboSport = freezed,
  }) {
    return _then(
      _$TrainingRecordImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        sessionId:
            null == sessionId
                ? _value.sessionId
                : sessionId // ignore: cast_nullable_to_non_nullable
                    as String,
        sessionName:
            null == sessionName
                ? _value.sessionName
                : sessionName // ignore: cast_nullable_to_non_nullable
                    as String,
        date:
            null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        durationCompletedSec:
            null == durationCompletedSec
                ? _value.durationCompletedSec
                : durationCompletedSec // ignore: cast_nullable_to_non_nullable
                    as int,
        roundsCompleted:
            null == roundsCompleted
                ? _value.roundsCompleted
                : roundsCompleted // ignore: cast_nullable_to_non_nullable
                    as int,
        totalRounds:
            null == totalRounds
                ? _value.totalRounds
                : totalRounds // ignore: cast_nullable_to_non_nullable
                    as int,
        completedFully:
            null == completedFully
                ? _value.completedFully
                : completedFully // ignore: cast_nullable_to_non_nullable
                    as bool,
        combosCompleted:
            freezed == combosCompleted
                ? _value.combosCompleted
                : combosCompleted // ignore: cast_nullable_to_non_nullable
                    as int?,
        comboDifficulty:
            freezed == comboDifficulty
                ? _value.comboDifficulty
                : comboDifficulty // ignore: cast_nullable_to_non_nullable
                    as String?,
        comboSport:
            freezed == comboSport
                ? _value.comboSport
                : comboSport // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainingRecordImpl implements _TrainingRecord {
  const _$TrainingRecordImpl({
    required this.id,
    required this.sessionId,
    required this.sessionName,
    required this.date,
    required this.durationCompletedSec,
    required this.roundsCompleted,
    required this.totalRounds,
    this.completedFully = true,
    this.combosCompleted,
    this.comboDifficulty,
    this.comboSport,
  });

  factory _$TrainingRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingRecordImplFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String sessionName;
  @override
  final DateTime date;
  @override
  final int durationCompletedSec;
  @override
  final int roundsCompleted;
  @override
  final int totalRounds;
  @override
  @JsonKey()
  final bool completedFully;
  @override
  final int? combosCompleted;
  @override
  final String? comboDifficulty;
  @override
  final String? comboSport;

  @override
  String toString() {
    return 'TrainingRecord(id: $id, sessionId: $sessionId, sessionName: $sessionName, date: $date, durationCompletedSec: $durationCompletedSec, roundsCompleted: $roundsCompleted, totalRounds: $totalRounds, completedFully: $completedFully, combosCompleted: $combosCompleted, comboDifficulty: $comboDifficulty, comboSport: $comboSport)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionName, sessionName) ||
                other.sessionName == sessionName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.durationCompletedSec, durationCompletedSec) ||
                other.durationCompletedSec == durationCompletedSec) &&
            (identical(other.roundsCompleted, roundsCompleted) ||
                other.roundsCompleted == roundsCompleted) &&
            (identical(other.totalRounds, totalRounds) ||
                other.totalRounds == totalRounds) &&
            (identical(other.completedFully, completedFully) ||
                other.completedFully == completedFully) &&
            (identical(other.combosCompleted, combosCompleted) ||
                other.combosCompleted == combosCompleted) &&
            (identical(other.comboDifficulty, comboDifficulty) ||
                other.comboDifficulty == comboDifficulty) &&
            (identical(other.comboSport, comboSport) ||
                other.comboSport == comboSport));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sessionId,
    sessionName,
    date,
    durationCompletedSec,
    roundsCompleted,
    totalRounds,
    completedFully,
    combosCompleted,
    comboDifficulty,
    comboSport,
  );

  /// Create a copy of TrainingRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingRecordImplCopyWith<_$TrainingRecordImpl> get copyWith =>
      __$$TrainingRecordImplCopyWithImpl<_$TrainingRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingRecordImplToJson(this);
  }
}

abstract class _TrainingRecord implements TrainingRecord {
  const factory _TrainingRecord({
    required final String id,
    required final String sessionId,
    required final String sessionName,
    required final DateTime date,
    required final int durationCompletedSec,
    required final int roundsCompleted,
    required final int totalRounds,
    final bool completedFully,
    final int? combosCompleted,
    final String? comboDifficulty,
    final String? comboSport,
  }) = _$TrainingRecordImpl;

  factory _TrainingRecord.fromJson(Map<String, dynamic> json) =
      _$TrainingRecordImpl.fromJson;

  @override
  String get id;
  @override
  String get sessionId;
  @override
  String get sessionName;
  @override
  DateTime get date;
  @override
  int get durationCompletedSec;
  @override
  int get roundsCompleted;
  @override
  int get totalRounds;
  @override
  bool get completedFully;
  @override
  int? get combosCompleted;
  @override
  String? get comboDifficulty;
  @override
  String? get comboSport;

  /// Create a copy of TrainingRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingRecordImplCopyWith<_$TrainingRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
