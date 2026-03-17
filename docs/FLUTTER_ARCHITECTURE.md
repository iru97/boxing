# Flutter Architecture Decisions

## Definitive technical decisions based on deep research. Reference this before writing any code.

## Architecture: Feature-First + Layered Internals

```
lib/
├── main.dart                          # Hive init, audio_service init, ProviderScope
├── app/
│   ├── app.dart                       # MaterialApp.router, theme
│   ├── router.dart                    # GoRouter configuration
│   └── providers.dart                 # App-wide provider overrides
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         # Durations, limits, defaults
│   │   ├── preset_sessions.dart       # 17 built-in presets
│   │   └── sound_assets.dart          # Audio asset paths
│   ├── theme/
│   │   ├── app_theme.dart             # Material 3 light/dark ThemeData
│   │   ├── app_colors.dart            # Brand colors
│   │   └── timer_colors.dart          # Phase colors (domain, not theme)
│   ├── utils/
│   │   └── duration_formatter.dart    # Duration → "M:SS" formatting
│   └── extensions/
│       └── context_extensions.dart
├── features/
│   ├── timer/
│   │   ├── data/
│   │   │   └── timer_service.dart     # Platform bridge, audio_service
│   │   ├── domain/
│   │   │   ├── timer_state.dart       # Freezed TimerPhase sealed union
│   │   │   └── timer_engine.dart      # Core tick logic (pure Dart, testable)
│   │   └── presentation/
│   │       ├── timer_screen.dart
│   │       ├── timer_controller.dart  # @riverpod Notifier
│   │       └── widgets/
│   │           ├── countdown_display.dart
│   │           ├── progress_ring.dart
│   │           ├── round_indicator.dart
│   │           ├── phase_label.dart
│   │           └── timer_controls.dart
│   ├── sessions/
│   │   ├── data/
│   │   │   ├── session_repository.dart  # Hive CRUD with JSON
│   │   │   └── preset_sessions.dart     # Built-in presets
│   │   ├── domain/
│   │   │   └── session_model.dart       # @freezed Session
│   │   └── presentation/
│   │       ├── session_list_screen.dart
│   │       ├── session_editor_screen.dart
│   │       ├── sessions_controller.dart # @riverpod AsyncNotifier
│   │       └── widgets/
│   │           ├── session_card.dart
│   │           └── duration_picker.dart
│   ├── audio/
│   │   ├── data/
│   │   │   └── audio_player_service.dart # just_audio + audio_service
│   │   └── domain/
│   │       └── sound_pack.dart           # @freezed sound config
│   └── settings/
│       ├── data/
│       │   └── settings_repository.dart  # Hive-backed settings
│       ├── domain/
│       │   └── app_settings.dart         # @freezed settings model
│       └── presentation/
│           └── settings_screen.dart
├── shared/
│   └── widgets/
│       ├── large_tap_button.dart         # Glove-friendly (80dp)
│       └── confirm_dialog.dart
└── generated/                            # build_runner output (gitignored)
```

## Package Versions (Verified March 2026)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.3.1
  riverpod_annotation: ^4.0.2
  go_router: ^17.1.0
  freezed_annotation: ^3.1.0
  json_annotation: ^4.11.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  just_audio: ^0.10.5
  audio_service: ^0.18.18
  wakelock_plus: ^1.5.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.12.2
  riverpod_generator: ^4.0.3
  freezed: ^3.2.5
  json_serializable: ^6.13.0
  hive_generator: ^2.0.1
```

## Riverpod Pattern: @riverpod Code Generation

Use `@riverpod` annotations, NOT manual Provider/StateNotifier (legacy).

### Simple computed value
```dart
@riverpod
int roundsRemaining(Ref ref) {
  final state = ref.watch(timerStateProvider);
  return state.totalRounds - state.currentRound;
}
```

### Async data loading
```dart
@riverpod
Future<List<SessionModel>> savedSessions(Ref ref) async {
  final repo = ref.watch(sessionRepositoryProvider);
  return repo.getAll();
}
```

### Mutable state with logic (Notifier)
```dart
@riverpod
class TimerController extends _$TimerController {
  @override
  TimerState build() => const TimerState.idle();

  void start(SessionModel session) { ... }
  void pause() { ... }
  void resume() { ... }
}
```

### Async mutable state (AsyncNotifier)
```dart
@riverpod
class SessionsController extends _$SessionsController {
  @override
  Future<List<SessionModel>> build() async {
    return ref.watch(sessionRepositoryProvider).getAll();
  }

  Future<void> addSession(SessionModel session) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(sessionRepositoryProvider).save(session);
      return ref.read(sessionRepositoryProvider).getAll();
    });
  }
}
```

### Timer Provider: Notifier, NOT StreamProvider
Use a `Notifier` with internal `Timer.periodic` for the timer. StreamProvider is for
external streams (Firebase, WebSocket). A Notifier gives imperative methods (start, pause, resume):
```dart
@riverpod
class TimerController extends _$TimerController {
  Timer? _timer;
  DateTime? _phaseStartTime;

  @override
  TimerState build() {
    ref.onDispose(() => _timer?.cancel());
    return const TimerState.idle();
  }

  void start(SessionModel session) { /* ... */ }
  void pause() { _timer?.cancel(); /* ... */ }
  void resume() { /* re-sync from DateTime.now() */ }
}
```
Update at 50ms intervals (20 FPS) - efficient, smooth enough for countdown display.

### Rules
- `ref.watch()` in build methods and provider bodies (reactive)
- `ref.read()` in callbacks and event handlers (one-shot)
- Never navigate inside providers
- One responsibility per provider

## Freezed Patterns

### Session Model - Duration as int seconds (NOT Duration type)
Store Duration as `int` seconds for clean Hive/JSON serialization. Use extension getters for convenience.
Hive + Freezed TypeAdapter integration is fragile (GitHub issue #795). JSON approach is recommended.
```dart
@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    required String id,
    required String name,
    required int rounds,
    required int roundDurationSec,      // 180 = 3 minutes
    required int restDurationSec,       // 60  = 1 minute
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

// Convenience Duration getters (extension, not in freezed class)
extension SessionModelX on SessionModel {
  Duration get roundDuration => Duration(seconds: roundDurationSec);
  Duration get restDuration => Duration(seconds: restDurationSec);
  Duration get warningTime => Duration(seconds: warningTimeSec);
  Duration get warmupDuration => Duration(seconds: warmupDurationSec);
}
```

### Timer Phase (Sealed Union)
```dart
@freezed
sealed class TimerPhase with _$TimerPhase {
  const factory TimerPhase.idle() = TimerIdle;
  const factory TimerPhase.warmup({required Duration remaining}) = TimerWarmup;
  const factory TimerPhase.work({
    required int roundNumber,
    required Duration remaining,
    required bool isWarning,
  }) = TimerWork;
  const factory TimerPhase.rest({
    required int afterRound,
    required Duration remaining,
  }) = TimerRest;
  const factory TimerPhase.paused({required TimerPhase previousPhase}) = TimerPaused;
  const factory TimerPhase.completed({required int totalRounds}) = TimerCompleted;
}
```

### Exhaustive Pattern Matching (Dart 3)
```dart
final color = switch (phase) {
  TimerIdle()      => TimerColors.idle,
  TimerWarmup()    => TimerColors.warmup,
  TimerWork()      => phase.isWarning ? TimerColors.warning : TimerColors.work,
  TimerRest()      => TimerColors.rest,
  TimerPaused()    => TimerColors.paused,
  TimerCompleted() => TimerColors.complete,
};
```

## Hive Storage Strategy

Store Freezed models as JSON strings (simplest, no custom TypeAdapters):

```dart
// Save
final json = jsonEncode(session.toJson());
await box.put(session.id, json);

// Load
final json = box.get(id);
if (json != null) {
  return SessionModel.fromJson(jsonDecode(json));
}
```

Duration stored as `int` seconds directly in the model (see Session Model above).
No custom JsonConverter needed - `json_serializable` handles `int` natively.

## App Initialization Order

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final sessionsBox = await Hive.openBox<String>('sessions');
  final settingsBox = await Hive.openBox<String>('settings');

  runApp(
    ProviderScope(
      overrides: [
        sessionsBoxProvider.overrideWithValue(sessionsBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
      ],
      child: const BoxingApp(),
    ),
  );
}
```

## Routing: GoRouter (4 screens)

```dart
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const SessionListScreen()),
    GoRoute(path: '/timer/:sessionId', builder: (_, state) =>
      TimerScreen(sessionId: state.pathParameters['sessionId']!)),
    GoRoute(path: '/session/edit/:sessionId', builder: (_, state) =>
      SessionEditorScreen(sessionId: state.pathParameters['sessionId'])),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
  ],
);
```

## Theme: Material 3 with Domain Phase Colors

- Material theme: `ColorScheme.fromSeed(seedColor: Color(0xFFD32F2F))` (boxing red)
- Phase colors are DOMAIN constants, NOT part of Material theme:
  ```dart
  class TimerColors {
    static const work = Color(0xFF4CAF50);
    static const warning = Color(0xFFFF9800);
    static const rest = Color(0xFFF44336);
    static const warmup = Color(0xFF2196F3);
    static const complete = Color(0xFFFFFFFF);
    static const idle = Color(0xFF9E9E9E);
    static const paused = Color(0xFF757575);
  }
  ```
- Dark theme primary (gym visibility), light theme as option
- Timer text: monospace, 72-96sp
