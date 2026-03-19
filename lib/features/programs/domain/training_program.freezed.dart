// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_program.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProgramDay _$ProgramDayFromJson(Map<String, dynamic> json) {
  return _ProgramDay.fromJson(json);
}

/// @nodoc
mixin _$ProgramDay {
  int get dayNumber => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  SessionModel get session => throw _privateConstructorUsedError;

  /// Serializes this ProgramDay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgramDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgramDayCopyWith<ProgramDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgramDayCopyWith<$Res> {
  factory $ProgramDayCopyWith(
    ProgramDay value,
    $Res Function(ProgramDay) then,
  ) = _$ProgramDayCopyWithImpl<$Res, ProgramDay>;
  @useResult
  $Res call({
    int dayNumber,
    String name,
    String description,
    SessionModel session,
  });

  $SessionModelCopyWith<$Res> get session;
}

/// @nodoc
class _$ProgramDayCopyWithImpl<$Res, $Val extends ProgramDay>
    implements $ProgramDayCopyWith<$Res> {
  _$ProgramDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgramDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? name = null,
    Object? description = null,
    Object? session = null,
  }) {
    return _then(
      _value.copyWith(
            dayNumber:
                null == dayNumber
                    ? _value.dayNumber
                    : dayNumber // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            session:
                null == session
                    ? _value.session
                    : session // ignore: cast_nullable_to_non_nullable
                        as SessionModel,
          )
          as $Val,
    );
  }

  /// Create a copy of ProgramDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionModelCopyWith<$Res> get session {
    return $SessionModelCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProgramDayImplCopyWith<$Res>
    implements $ProgramDayCopyWith<$Res> {
  factory _$$ProgramDayImplCopyWith(
    _$ProgramDayImpl value,
    $Res Function(_$ProgramDayImpl) then,
  ) = __$$ProgramDayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int dayNumber,
    String name,
    String description,
    SessionModel session,
  });

  @override
  $SessionModelCopyWith<$Res> get session;
}

/// @nodoc
class __$$ProgramDayImplCopyWithImpl<$Res>
    extends _$ProgramDayCopyWithImpl<$Res, _$ProgramDayImpl>
    implements _$$ProgramDayImplCopyWith<$Res> {
  __$$ProgramDayImplCopyWithImpl(
    _$ProgramDayImpl _value,
    $Res Function(_$ProgramDayImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProgramDay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dayNumber = null,
    Object? name = null,
    Object? description = null,
    Object? session = null,
  }) {
    return _then(
      _$ProgramDayImpl(
        dayNumber:
            null == dayNumber
                ? _value.dayNumber
                : dayNumber // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        session:
            null == session
                ? _value.session
                : session // ignore: cast_nullable_to_non_nullable
                    as SessionModel,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgramDayImpl implements _ProgramDay {
  const _$ProgramDayImpl({
    required this.dayNumber,
    required this.name,
    required this.description,
    required this.session,
  });

  factory _$ProgramDayImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgramDayImplFromJson(json);

  @override
  final int dayNumber;
  @override
  final String name;
  @override
  final String description;
  @override
  final SessionModel session;

  @override
  String toString() {
    return 'ProgramDay(dayNumber: $dayNumber, name: $name, description: $description, session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgramDayImpl &&
            (identical(other.dayNumber, dayNumber) ||
                other.dayNumber == dayNumber) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.session, session) || other.session == session));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, dayNumber, name, description, session);

  /// Create a copy of ProgramDay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgramDayImplCopyWith<_$ProgramDayImpl> get copyWith =>
      __$$ProgramDayImplCopyWithImpl<_$ProgramDayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgramDayImplToJson(this);
  }
}

abstract class _ProgramDay implements ProgramDay {
  const factory _ProgramDay({
    required final int dayNumber,
    required final String name,
    required final String description,
    required final SessionModel session,
  }) = _$ProgramDayImpl;

  factory _ProgramDay.fromJson(Map<String, dynamic> json) =
      _$ProgramDayImpl.fromJson;

  @override
  int get dayNumber;
  @override
  String get name;
  @override
  String get description;
  @override
  SessionModel get session;

  /// Create a copy of ProgramDay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgramDayImplCopyWith<_$ProgramDayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProgramWeek _$ProgramWeekFromJson(Map<String, dynamic> json) {
  return _ProgramWeek.fromJson(json);
}

/// @nodoc
mixin _$ProgramWeek {
  int get weekNumber => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<ProgramDay> get days => throw _privateConstructorUsedError;

  /// Serializes this ProgramWeek to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProgramWeek
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProgramWeekCopyWith<ProgramWeek> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProgramWeekCopyWith<$Res> {
  factory $ProgramWeekCopyWith(
    ProgramWeek value,
    $Res Function(ProgramWeek) then,
  ) = _$ProgramWeekCopyWithImpl<$Res, ProgramWeek>;
  @useResult
  $Res call({
    int weekNumber,
    String name,
    String description,
    List<ProgramDay> days,
  });
}

/// @nodoc
class _$ProgramWeekCopyWithImpl<$Res, $Val extends ProgramWeek>
    implements $ProgramWeekCopyWith<$Res> {
  _$ProgramWeekCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProgramWeek
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekNumber = null,
    Object? name = null,
    Object? description = null,
    Object? days = null,
  }) {
    return _then(
      _value.copyWith(
            weekNumber:
                null == weekNumber
                    ? _value.weekNumber
                    : weekNumber // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            days:
                null == days
                    ? _value.days
                    : days // ignore: cast_nullable_to_non_nullable
                        as List<ProgramDay>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProgramWeekImplCopyWith<$Res>
    implements $ProgramWeekCopyWith<$Res> {
  factory _$$ProgramWeekImplCopyWith(
    _$ProgramWeekImpl value,
    $Res Function(_$ProgramWeekImpl) then,
  ) = __$$ProgramWeekImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int weekNumber,
    String name,
    String description,
    List<ProgramDay> days,
  });
}

/// @nodoc
class __$$ProgramWeekImplCopyWithImpl<$Res>
    extends _$ProgramWeekCopyWithImpl<$Res, _$ProgramWeekImpl>
    implements _$$ProgramWeekImplCopyWith<$Res> {
  __$$ProgramWeekImplCopyWithImpl(
    _$ProgramWeekImpl _value,
    $Res Function(_$ProgramWeekImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProgramWeek
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weekNumber = null,
    Object? name = null,
    Object? description = null,
    Object? days = null,
  }) {
    return _then(
      _$ProgramWeekImpl(
        weekNumber:
            null == weekNumber
                ? _value.weekNumber
                : weekNumber // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        days:
            null == days
                ? _value._days
                : days // ignore: cast_nullable_to_non_nullable
                    as List<ProgramDay>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProgramWeekImpl implements _ProgramWeek {
  const _$ProgramWeekImpl({
    required this.weekNumber,
    required this.name,
    required this.description,
    required final List<ProgramDay> days,
  }) : _days = days;

  factory _$ProgramWeekImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProgramWeekImplFromJson(json);

  @override
  final int weekNumber;
  @override
  final String name;
  @override
  final String description;
  final List<ProgramDay> _days;
  @override
  List<ProgramDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  String toString() {
    return 'ProgramWeek(weekNumber: $weekNumber, name: $name, description: $description, days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProgramWeekImpl &&
            (identical(other.weekNumber, weekNumber) ||
                other.weekNumber == weekNumber) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._days, _days));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    weekNumber,
    name,
    description,
    const DeepCollectionEquality().hash(_days),
  );

  /// Create a copy of ProgramWeek
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProgramWeekImplCopyWith<_$ProgramWeekImpl> get copyWith =>
      __$$ProgramWeekImplCopyWithImpl<_$ProgramWeekImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProgramWeekImplToJson(this);
  }
}

abstract class _ProgramWeek implements ProgramWeek {
  const factory _ProgramWeek({
    required final int weekNumber,
    required final String name,
    required final String description,
    required final List<ProgramDay> days,
  }) = _$ProgramWeekImpl;

  factory _ProgramWeek.fromJson(Map<String, dynamic> json) =
      _$ProgramWeekImpl.fromJson;

  @override
  int get weekNumber;
  @override
  String get name;
  @override
  String get description;
  @override
  List<ProgramDay> get days;

  /// Create a copy of ProgramWeek
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProgramWeekImplCopyWith<_$ProgramWeekImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainingProgram _$TrainingProgramFromJson(Map<String, dynamic> json) {
  return _TrainingProgram.fromJson(json);
}

/// @nodoc
mixin _$TrainingProgram {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get sport => throw _privateConstructorUsedError;
  String get difficulty => throw _privateConstructorUsedError;
  int get durationWeeks => throw _privateConstructorUsedError;
  List<ProgramWeek> get weeks => throw _privateConstructorUsedError;
  bool get isPreset => throw _privateConstructorUsedError;

  /// Serializes this TrainingProgram to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingProgram
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingProgramCopyWith<TrainingProgram> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingProgramCopyWith<$Res> {
  factory $TrainingProgramCopyWith(
    TrainingProgram value,
    $Res Function(TrainingProgram) then,
  ) = _$TrainingProgramCopyWithImpl<$Res, TrainingProgram>;
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String sport,
    String difficulty,
    int durationWeeks,
    List<ProgramWeek> weeks,
    bool isPreset,
  });
}

/// @nodoc
class _$TrainingProgramCopyWithImpl<$Res, $Val extends TrainingProgram>
    implements $TrainingProgramCopyWith<$Res> {
  _$TrainingProgramCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingProgram
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? sport = null,
    Object? difficulty = null,
    Object? durationWeeks = null,
    Object? weeks = null,
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
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            sport:
                null == sport
                    ? _value.sport
                    : sport // ignore: cast_nullable_to_non_nullable
                        as String,
            difficulty:
                null == difficulty
                    ? _value.difficulty
                    : difficulty // ignore: cast_nullable_to_non_nullable
                        as String,
            durationWeeks:
                null == durationWeeks
                    ? _value.durationWeeks
                    : durationWeeks // ignore: cast_nullable_to_non_nullable
                        as int,
            weeks:
                null == weeks
                    ? _value.weeks
                    : weeks // ignore: cast_nullable_to_non_nullable
                        as List<ProgramWeek>,
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
abstract class _$$TrainingProgramImplCopyWith<$Res>
    implements $TrainingProgramCopyWith<$Res> {
  factory _$$TrainingProgramImplCopyWith(
    _$TrainingProgramImpl value,
    $Res Function(_$TrainingProgramImpl) then,
  ) = __$$TrainingProgramImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String description,
    String sport,
    String difficulty,
    int durationWeeks,
    List<ProgramWeek> weeks,
    bool isPreset,
  });
}

/// @nodoc
class __$$TrainingProgramImplCopyWithImpl<$Res>
    extends _$TrainingProgramCopyWithImpl<$Res, _$TrainingProgramImpl>
    implements _$$TrainingProgramImplCopyWith<$Res> {
  __$$TrainingProgramImplCopyWithImpl(
    _$TrainingProgramImpl _value,
    $Res Function(_$TrainingProgramImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TrainingProgram
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? sport = null,
    Object? difficulty = null,
    Object? durationWeeks = null,
    Object? weeks = null,
    Object? isPreset = null,
  }) {
    return _then(
      _$TrainingProgramImpl(
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
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        sport:
            null == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                    as String,
        difficulty:
            null == difficulty
                ? _value.difficulty
                : difficulty // ignore: cast_nullable_to_non_nullable
                    as String,
        durationWeeks:
            null == durationWeeks
                ? _value.durationWeeks
                : durationWeeks // ignore: cast_nullable_to_non_nullable
                    as int,
        weeks:
            null == weeks
                ? _value._weeks
                : weeks // ignore: cast_nullable_to_non_nullable
                    as List<ProgramWeek>,
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
class _$TrainingProgramImpl implements _TrainingProgram {
  const _$TrainingProgramImpl({
    required this.id,
    required this.name,
    required this.description,
    required this.sport,
    required this.difficulty,
    required this.durationWeeks,
    required final List<ProgramWeek> weeks,
    this.isPreset = true,
  }) : _weeks = weeks;

  factory _$TrainingProgramImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingProgramImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String sport;
  @override
  final String difficulty;
  @override
  final int durationWeeks;
  final List<ProgramWeek> _weeks;
  @override
  List<ProgramWeek> get weeks {
    if (_weeks is EqualUnmodifiableListView) return _weeks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeks);
  }

  @override
  @JsonKey()
  final bool isPreset;

  @override
  String toString() {
    return 'TrainingProgram(id: $id, name: $name, description: $description, sport: $sport, difficulty: $difficulty, durationWeeks: $durationWeeks, weeks: $weeks, isPreset: $isPreset)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingProgramImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.durationWeeks, durationWeeks) ||
                other.durationWeeks == durationWeeks) &&
            const DeepCollectionEquality().equals(other._weeks, _weeks) &&
            (identical(other.isPreset, isPreset) ||
                other.isPreset == isPreset));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    description,
    sport,
    difficulty,
    durationWeeks,
    const DeepCollectionEquality().hash(_weeks),
    isPreset,
  );

  /// Create a copy of TrainingProgram
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingProgramImplCopyWith<_$TrainingProgramImpl> get copyWith =>
      __$$TrainingProgramImplCopyWithImpl<_$TrainingProgramImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingProgramImplToJson(this);
  }
}

abstract class _TrainingProgram implements TrainingProgram {
  const factory _TrainingProgram({
    required final String id,
    required final String name,
    required final String description,
    required final String sport,
    required final String difficulty,
    required final int durationWeeks,
    required final List<ProgramWeek> weeks,
    final bool isPreset,
  }) = _$TrainingProgramImpl;

  factory _TrainingProgram.fromJson(Map<String, dynamic> json) =
      _$TrainingProgramImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get sport;
  @override
  String get difficulty;
  @override
  int get durationWeeks;
  @override
  List<ProgramWeek> get weeks;
  @override
  bool get isPreset;

  /// Create a copy of TrainingProgram
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingProgramImplCopyWith<_$TrainingProgramImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
