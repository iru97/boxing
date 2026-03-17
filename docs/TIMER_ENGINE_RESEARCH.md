# Timer Engine Research: Building a Reliable Boxing Round Timer in Flutter

Deep technical research covering timer accuracy, background execution, state machines, testing, and notification updates. All patterns are implementation-ready.

---

## 1. Timer Accuracy: Solving Drift

### The Problem

`Timer.periodic` is **not accurate**. The Dart docs themselves state: "The exact timing depends on the underlying timer implementation." In practice:

- Callbacks configured for 20ms can fire anywhere in the 100-1000ms range
- On Android, periodic timers **stop emitting after ~1.5-2 minutes** in background
- On resume, timers can take 15-30 seconds to fire their first callback
- If a periodic timer is delayed, all but the last tick are considered "missed" -- no callback fires for them

### The Solution: DateTime Anchoring

**Never increment a counter. Always compute elapsed time from a stored DateTime.**

```dart
class TimerEngine {
  DateTime? _phaseStartTime;
  Duration _phaseDuration;
  Duration _pausedElapsed = Duration.zero;
  Timer? _ticker;

  Duration get remaining {
    if (_phaseStartTime == null) return _phaseDuration;
    final elapsed = DateTime.now().difference(_phaseStartTime!) + _pausedElapsed;
    final left = _phaseDuration - elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  void start(Duration duration) {
    _phaseDuration = duration;
    _pausedElapsed = Duration.zero;
    _phaseStartTime = DateTime.now();
    _ticker?.cancel();
    // UI update tick -- accuracy of this tick doesn't matter
    // because `remaining` always recomputes from DateTime
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _onTick();
    });
  }

  void pause() {
    if (_phaseStartTime != null) {
      _pausedElapsed += DateTime.now().difference(_phaseStartTime!);
    }
    _phaseStartTime = null;
    _ticker?.cancel();
  }

  void resume() {
    _phaseStartTime = DateTime.now();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _onTick();
    });
  }

  void _onTick() {
    final left = remaining;
    // Notify listeners with `left`
    if (left <= Duration.zero) {
      _ticker?.cancel();
      _onPhaseComplete();
    }
  }
}
```

**Key insight**: The `Timer.periodic` at 100ms is ONLY for triggering UI redraws. The actual time measurement comes from `DateTime.now().difference(_phaseStartTime)`. If the timer fires at 95ms or 140ms, it doesn't matter -- the displayed time is always correct.

### Why 100ms, Not 1000ms?

Using a 100ms tick interval ensures the display feels smooth (updates 10x/sec) and catches phase transitions within 100ms of the actual boundary. A 1s tick can miss the exact transition moment by up to 999ms, which feels laggy.

### Ticker Alternative (UI-Synced)

For UI-only timing (no background), Flutter's `Ticker` fires once per frame (~60fps) and is automatically paused when the widget tree is inactive:

```dart
class _TimerWidgetState extends State<TimerWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration frameDuration) {
    // frameDuration is time since ticker started, but for accuracy
    // use DateTime:
    setState(() {
      _elapsed = DateTime.now().difference(_startTime!);
    });
  }

  void startTimer() {
    _startTime = DateTime.now();
    _ticker.start();
  }
}
```

**Verdict for boxing timer**: Use `Timer.periodic` at 100ms in the timer engine (decoupled from UI), NOT `Ticker`. Ticker is tied to the widget lifecycle and frame rendering -- it stops when the app is backgrounded. Our timer must survive backgrounding.

### References
- [Flutter Case Study: Timer Precision](https://medium.com/geekculture/flutter-case-study-timer-precision-a1154b431e8)
- [Flutter Timer vs Ticker (Code with Andrea)](https://codewithandrea.com/articles/flutter-timer-vs-ticker/)
- [Timer.periodic API docs](https://api.flutter.dev/flutter/dart-async/Timer/Timer.periodic.html)
- [Android: Dart timers unresponsive after background (flutter/flutter#94094)](https://github.com/flutter/flutter/issues/94094)

---

## 2. WidgetsBindingObserver / AppLifecycleListener: Background Sync

### The Problem

When Android calls `Activity.onStop`, Flutter enters `paused` state. The OS will:
- Throttle/stop `Timer.periodic` callbacks after ~1.5-2 minutes
- Potentially kill the isolate entirely (Doze mode)
- On resume, timers can be sluggish for 15-30 seconds

### The Solution: Record Time on Pause, Recompute on Resume

Since our timer engine uses DateTime anchoring (Section 1), background survival is largely free. But we still need to:
1. Know when we go to background (to potentially start a foreground service)
2. Re-kick the Timer.periodic on resume (it may have stopped)
3. Wake up the event loop (Android bug workaround)

### Implementation with AppLifecycleListener (Flutter 3.13+)

```dart
class TimerService {
  late final AppLifecycleListener _lifecycleListener;
  DateTime? _backgroundedAt;

  void init() {
    _lifecycleListener = AppLifecycleListener(
      onStateChange: _onStateChange,
      onPause: _onPause,
      onResume: _onResume,
      onInactive: _onInactive,
    );
  }

  void _onStateChange(AppLifecycleState state) {
    // Log for debugging
    debugPrint('App lifecycle: $state');
  }

  void _onPause() {
    // App is going to background
    _backgroundedAt = DateTime.now();
    // Start foreground service if timer is active
    if (isRunning) {
      _startForegroundService();
    }
  }

  void _onResume() {
    // App is coming back to foreground
    // CRITICAL: Wake up the event loop (Android timer bug workaround)
    Future(() => null);

    if (_backgroundedAt != null) {
      final backgroundDuration = DateTime.now().difference(_backgroundedAt!);
      debugPrint('Was backgrounded for: $backgroundDuration');
      _backgroundedAt = null;
    }

    // Re-sync: restart the periodic ticker if timer is running
    // The DateTime-anchored `remaining` getter is already correct
    if (isRunning) {
      _restartPeriodicTicker();
      _stopForegroundService();
    }
  }

  void _onInactive() {
    // Transitional state (e.g., phone call overlay, app switcher)
    // Don't do anything drastic here
  }

  void dispose() {
    _lifecycleListener.dispose();
  }
}
```

### Legacy WidgetsBindingObserver Pattern

For widgets that need scoped lifecycle observation:

```dart
class _TimerScreenState extends State<TimerScreen>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // Going to background
        break;
      case AppLifecycleState.resumed:
        // Returning to foreground
        Future(() => null); // Android event loop workaround
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }
}
```

### The `Future(() => null)` Workaround

From flutter/flutter#94094: On Android devices with battery optimization, timers become unresponsive after returning from background. The fix is to trigger an empty Future to "wake up" the event loop:

```dart
if (state == AppLifecycleState.resumed) {
  Future(() => null).then((_) {
    // Now timers respond normally
  });
}
```

### Lifecycle State Flow

```
              ┌──────────┐
              │  resumed  │  (app is visible, has focus)
              └─────┬─────┘
                    │
              ┌─────▼─────┐
              │  inactive  │  (losing focus: phone call, app switcher)
              └─────┬─────┘
                    │
              ┌─────▼─────┐
              │   hidden   │  (fully obscured but still hosted)
              └─────┬─────┘
                    │
              ┌─────▼─────┐
              │   paused   │  (background -- timers start dying)
              └─────┬─────┘
                    │
              ┌─────▼─────┐
              │  detached  │  (still hosted but detached from views)
              └──────────┘
```

### References
- [AppLifecycleListener class](https://api.flutter.dev/flutter/widgets/AppLifecycleListener-class.html)
- [AppLifecycleState enum](https://api.flutter.dev/flutter/dart-ui/AppLifecycleState.html)
- [New AppLifecycleListener overview (Kazlauskas)](https://kazlauskas.dev/blog/flutter-app-lifecycle-listener-overview/)
- [Flutter: Dealing with Slow Timers in Background](https://medium.com/@soojlee0701/flutter-dealing-with-slow-timers-in-background-6d401a20d459)
- [Mastering Flutter App Lifecycle](https://medium.com/@krishna.ram30/mastering-flutter-app-lifecycle-with-widgetsbindingobserver-1350319cc3fa)

---

## 3. Isolates for Timer: Analysis and Verdict

### Should the timer run in a separate isolate?

**Short answer: No, not for the core timer logic. But the foreground service runs in one anyway.**

### Why NOT a separate isolate for the timer:

1. **Timer accuracy is a non-problem with DateTime anchoring** -- The main isolate's Timer.periodic is only a UI refresh trigger. Drift doesn't matter.

2. **Communication overhead** -- Isolates communicate via message passing (copying data). Sending timer state 10x/sec between isolates adds unnecessary complexity and latency.

3. **Plugin access** -- As of Flutter 3.7, background isolates CAN access platform plugins, but the integration is fragile. Audio playback, notifications, and wake lock all need platform channels.

4. **Memory overhead** -- Each isolate has its own heap. For a simple countdown, this is wasteful.

5. **UI updates require main isolate** -- You'd have to send every tick back to the main isolate anyway.

### When isolates ARE relevant:

**`flutter_foreground_task` already runs your TaskHandler in a separate isolate.** When the app is backgrounded, the foreground service's isolate keeps running. This is the right architectural boundary:

```
┌─────────────────────────────────┐
│        Main Isolate             │
│                                 │
│  TimerEngine (DateTime-based)   │
│  UI (widgets, state)            │
│  Audio playback                 │
│                                 │
│  When app is FOREGROUNDED:      │
│  Timer.periodic drives UI       │
└────────────┬────────────────────┘
             │ (app backgrounded)
             ▼
┌─────────────────────────────────┐
│     Foreground Service Isolate  │
│                                 │
│  TaskHandler                    │
│  onRepeatEvent every 1000ms     │
│  Updates notification with      │
│  current round/time             │
│  Plays audio cues on schedule   │
│                                 │
│  When app RESUMES:              │
│  Sends current state to main    │
└─────────────────────────────────┘
```

### Communication Pattern

```dart
// In TaskHandler (foreground service isolate)
@override
void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
  // Compute remaining time (DateTime-anchored)
  final remaining = _phaseEndTime.difference(DateTime.now());

  // Update notification
  FlutterForegroundTask.updateService(
    notificationTitle: 'Round $_currentRound / $_totalRounds',
    notificationText: '${_formatDuration(remaining)} remaining',
  );

  // Send state to main isolate (if UI is listening)
  sendPort?.send({
    'round': _currentRound,
    'phase': _currentPhase.name,
    'remaining': remaining.inMilliseconds,
  });

  // Check for phase transitions
  if (remaining <= Duration.zero) {
    _transitionToNextPhase();
  }
}

// In main isolate UI
FlutterForegroundTask.addTaskDataCallback((data) {
  final map = data as Map;
  // Update UI state from foreground service
  ref.read(timerStateProvider.notifier).syncFromService(
    round: map['round'],
    phase: TimerPhase.values.byName(map['phase']),
    remaining: Duration(milliseconds: map['remaining']),
  );
});
```

### References
- [Flutter Isolates documentation](https://docs.flutter.dev/perf/isolates)
- [Dart Concurrency](https://dart.dev/language/concurrency)
- [Using Isolates and reliable_interval_timer](https://medium.com/@shyamdelvadiya0/using-isolates-and-reliable-interval-timer-for-background-tasks-in-flutter-f39fcc960722)

---

## 4. flutter_foreground_task: The Background Execution Solution

### Package Overview

**Latest version**: 9.0.0 (requires Kotlin 1.9.10+, Gradle 8.6.0+)
**Purpose**: Run a foreground service on Android; limited background execution on iOS.

### Why This Over audio_service?

| Aspect | flutter_foreground_task | audio_service |
|--------|----------------------|---------------|
| Primary use | General foreground services | Audio playback sessions |
| Timer support | Direct (onRepeatEvent) | Indirect (must fake audio session) |
| Notification | Full control (title/text) | Media-style controls |
| iOS background | ~30s every 15min | Continuous (if audio playing) |
| Complexity | Lower | Higher (MediaItem, queue, etc.) |

**Recommendation**: Use `flutter_foreground_task` for the timer service. Use `just_audio` independently for sound playback. Don't abuse `audio_service` to keep a timer alive.

### Complete Setup

#### AndroidManifest.xml
```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<service
    android:name="com.pravera.flutter_foreground_task.service.ForegroundService"
    android:foregroundServiceType="mediaPlayback"
    android:stopWithTask="false"
    android:exported="false" />
```

Note: `mediaPlayback` type is appropriate since we play audio cues. Using `stopWithTask="false"` means the service survives the app being swiped from recents.

#### Initialization
```dart
void _initForegroundTask() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'boxing_timer',
      channelName: 'Boxing Timer',
      channelDescription: 'Active boxing round timer',
      channelImportance: NotificationChannelImportance.LOW, // no sound
      priority: NotificationPriority.LOW,
      showBadge: false,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.repeat(1000), // 1s
      autoRunOnBoot: false,
      autoRunOnMyPackageReplaced: false,
      allowWakeLock: true,
      allowWifiLock: false,
    ),
  );
}
```

#### TaskHandler
```dart
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(BoxingTimerTaskHandler());
}

class BoxingTimerTaskHandler extends TaskHandler {
  // Timer state -- duplicated from main isolate for background operation
  DateTime _phaseEndTime = DateTime.now();
  int _currentRound = 1;
  int _totalRounds = 12;
  String _currentPhase = 'work'; // work, rest, warmup, complete
  late SessionConfig _config;

  @override
  void onStart(DateTime timestamp, TaskStarter starter, SendPort? sendPort) {
    // Receive initial state from main isolate
    // (sent via FlutterForegroundTask.sendDataToTask before starting)
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
    final remaining = _phaseEndTime.difference(DateTime.now());

    FlutterForegroundTask.updateService(
      notificationTitle: _formatPhaseTitle(),
      notificationText: _formatRemaining(remaining),
    );

    sendPort?.send({
      'type': 'tick',
      'round': _currentRound,
      'phase': _currentPhase,
      'remainingMs': remaining.inMilliseconds,
    });

    if (remaining.inMilliseconds <= 0) {
      _advancePhase(sendPort);
    }
  }

  @override
  void onReceiveData(Object data) {
    // Receive commands from main isolate
    final map = data as Map<String, dynamic>;
    switch (map['command']) {
      case 'init':
        _config = SessionConfig.fromJson(map['config']);
        _currentRound = map['round'];
        _currentPhase = map['phase'];
        _phaseEndTime = DateTime.fromMillisecondsSinceEpoch(map['endTimeMs']);
        break;
      case 'pause':
        // Handle pause
        break;
      case 'resume':
        // Handle resume
        break;
    }
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) {
    // Cleanup
  }

  String _formatPhaseTitle() {
    switch (_currentPhase) {
      case 'warmup': return 'Get Ready';
      case 'work': return 'Round $_currentRound / $_totalRounds';
      case 'rest': return 'Rest';
      case 'complete': return 'Workout Complete';
      default: return 'Boxing Timer';
    }
  }
}
```

#### Starting/Stopping
```dart
Future<void> startTimerService(SessionConfig config) async {
  if (await FlutterForegroundTask.isRunningService) {
    await FlutterForegroundTask.restartService();
  } else {
    await FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'Boxing Timer',
      notificationText: 'Starting...',
      callback: startCallback,
    );
  }

  // Send initial state to the task handler
  FlutterForegroundTask.sendDataToTask({
    'command': 'init',
    'config': config.toJson(),
    'round': 1,
    'phase': 'warmup',
    'endTimeMs': DateTime.now()
        .add(Duration(seconds: config.warmupSeconds))
        .millisecondsSinceEpoch,
  });
}
```

### iOS Limitations

iOS does NOT support true foreground services. `flutter_foreground_task` on iOS:
- Runs for ~30 seconds every ~15 minutes
- Force-closing the app kills the task immediately
- Cannot auto-start on boot

For iOS background timer, the strategy is:
1. Use `audio_service` + `just_audio` to maintain a background audio session (playing silence or the bell sounds keeps the app alive)
2. Use `AppLifecycleListener` to detect background/foreground transitions
3. DateTime-anchored timer self-corrects on resume regardless

### References
- [flutter_foreground_task on pub.dev](https://pub.dev/packages/flutter_foreground_task)
- [flutter_foreground_task API docs](https://pub.dev/documentation/flutter_foreground_task/latest/)
- [flutter_foreground_task example](https://pub.dev/packages/flutter_foreground_task/example)
- [flutter_foreground_task changelog](https://pub.dev/packages/flutter_foreground_task/changelog)
- [Background processes (Flutter docs)](https://docs.flutter.dev/packages-and-plugins/background-processes)

---

## 5. Timer State Machine: Modeling Phases

### Phase Definitions for Boxing Timer

```dart
enum TimerPhase {
  idle,       // Not started
  warmup,     // Pre-round countdown (3-2-1 or configured warmup)
  work,       // Active round
  warning,    // Sub-phase of work (last N seconds -- triggers warning bell)
  rest,       // Between rounds
  complete,   // All rounds done
}
```

Note: `warning` is NOT a separate state machine state -- it's a threshold within `work`. The state machine should be:

```dart
enum TimerPhase {
  idle,
  warmup,
  work,       // warning is detected by checking remaining <= warningDuration
  rest,
  complete,
}
```

### State Transitions

```
     ┌──────┐
     │ idle │
     └──┬───┘
        │ start()
        ▼
    ┌────────┐   warmup duration = 0
    │ warmup │ ─────────────────────────┐
    └───┬────┘                          │
        │ warmup expires                │
        ▼                               ▼
    ┌────────┐                      ┌────────┐
    │  work  │ ◄────────────────────│  work  │
    └───┬────┘   rest expires       └───┬────┘
        │        (not last round)       │
        │ round expires                 │
        ▼                               │
   ┌─────────┐                          │
   │  rest   │  ◄──────────────────────┘
   └────┬────┘       (not last round)
        │
        │ round expires AND last round
        ▼
   ┌──────────┐
   │ complete │
   └──────────┘
```

### Implementation with Riverpod

```dart
// --- State ---

@freezed
class TimerState with _$TimerState {
  const factory TimerState({
    required TimerPhase phase,
    required int currentRound,
    required int totalRounds,
    required Duration remaining,
    required Duration phaseDuration,
    required bool isPaused,
    required SessionConfig config,
  }) = _TimerState;

  const TimerState._();

  bool get isWarning =>
      phase == TimerPhase.work &&
      remaining <= Duration(seconds: config.warningSeconds) &&
      config.warningSeconds > 0;

  double get progress =>
      phaseDuration.inMilliseconds > 0
          ? 1.0 - (remaining.inMilliseconds / phaseDuration.inMilliseconds)
          : 0.0;

  String get phaseLabel {
    switch (phase) {
      case TimerPhase.idle: return 'Ready';
      case TimerPhase.warmup: return 'Get Ready';
      case TimerPhase.work: return 'Round $currentRound';
      case TimerPhase.rest: return 'Rest';
      case TimerPhase.complete: return 'Done';
    }
  }
}

// --- Notifier ---

@riverpod
class TimerNotifier extends _$TimerNotifier {
  Timer? _ticker;
  DateTime? _phaseStartTime;
  Duration _pausedElapsed = Duration.zero;

  @override
  TimerState build() {
    ref.onDispose(() => _ticker?.cancel());
    return TimerState(
      phase: TimerPhase.idle,
      currentRound: 0,
      totalRounds: 0,
      remaining: Duration.zero,
      phaseDuration: Duration.zero,
      isPaused: false,
      config: SessionConfig.empty(),
    );
  }

  void startSession(SessionConfig config) {
    state = state.copyWith(
      config: config,
      totalRounds: config.rounds,
      currentRound: 0,
    );

    if (config.warmupSeconds > 0) {
      _startPhase(TimerPhase.warmup, Duration(seconds: config.warmupSeconds));
    } else {
      _startNextRound();
    }
  }

  void _startPhase(TimerPhase phase, Duration duration) {
    _ticker?.cancel();
    _pausedElapsed = Duration.zero;
    _phaseStartTime = DateTime.now();

    state = state.copyWith(
      phase: phase,
      remaining: duration,
      phaseDuration: duration,
      isPaused: false,
    );

    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _tick();
    });
  }

  void _tick() {
    if (_phaseStartTime == null) return; // paused

    final elapsed = DateTime.now().difference(_phaseStartTime!) + _pausedElapsed;
    final remaining = state.phaseDuration - elapsed;

    if (remaining <= Duration.zero) {
      _ticker?.cancel();
      _onPhaseComplete();
    } else {
      state = state.copyWith(remaining: remaining);
      // Check for warning threshold (audio cue trigger)
      _checkWarningThreshold(remaining);
    }
  }

  void _onPhaseComplete() {
    switch (state.phase) {
      case TimerPhase.warmup:
        _startNextRound();
      case TimerPhase.work:
        if (state.currentRound >= state.totalRounds) {
          state = state.copyWith(
            phase: TimerPhase.complete,
            remaining: Duration.zero,
          );
          // Play completion sound
        } else {
          _startPhase(
            TimerPhase.rest,
            Duration(seconds: state.config.restSeconds),
          );
          // Play round-end bell
        }
      case TimerPhase.rest:
        _startNextRound();
      default:
        break;
    }
  }

  void _startNextRound() {
    final nextRound = state.currentRound + 1;
    final roundDuration = state.config.roundDurationForRound(nextRound);
    state = state.copyWith(currentRound: nextRound);
    _startPhase(TimerPhase.work, roundDuration);
    // Play round-start bell
    // Announce "Round N" if voice enabled
  }

  void pause() {
    if (_phaseStartTime != null) {
      _pausedElapsed += DateTime.now().difference(_phaseStartTime!);
    }
    _phaseStartTime = null;
    _ticker?.cancel();
    state = state.copyWith(isPaused: true);
  }

  void resume() {
    _phaseStartTime = DateTime.now();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
      _tick();
    });
    state = state.copyWith(isPaused: false);
  }

  void stop() {
    _ticker?.cancel();
    _phaseStartTime = null;
    state = build(); // Reset to idle
  }

  void _checkWarningThreshold(Duration remaining) {
    // Trigger warning audio cue once when crossing the threshold
    final warningDuration = Duration(seconds: state.config.warningSeconds);
    final prevRemaining = state.remaining;
    if (prevRemaining > warningDuration && remaining <= warningDuration) {
      // Play warning bell (10-second clapper)
    }
  }

  /// Called when returning from background to re-sync
  void syncFromBackground() {
    // DateTime anchoring means state.remaining is already stale,
    // but _phaseStartTime is still valid. Just restart the ticker.
    if (state.phase != TimerPhase.idle &&
        state.phase != TimerPhase.complete &&
        !state.isPaused) {
      _ticker?.cancel();
      _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) {
        _tick();
      });
      // The next tick will recompute remaining from DateTime.now()
    }
  }
}
```

### Why Not a Formal State Machine Library?

Packages like `statemachine` or `state_machina` add abstractions but no real value for this use case. The transitions are simple and linear (warmup -> work <-> rest -> complete). An enum + switch is clearer and more debuggable. A formal FSM becomes valuable if you add features like:
- Branching paths (different phase sequences)
- Guard conditions (can't transition unless X)
- Hierarchical states (work.normal, work.warning as sub-states)

For Phase 1, the enum + Riverpod notifier approach is the right level of abstraction.

### References
- [State Machines in Dart and Flutter (Sandro Maglione)](https://www.sandromaglione.com/articles/how-to-implement-state-machines-and-statecharts-in-dart-and-flutter)
- [statemachine package](https://pub.dev/packages/statemachine)
- [Flutter Timer with flutter_bloc (Felix Angelov)](https://medium.com/flutter-community/flutter-timer-with-flutter-bloc-a464e8332ceb)
- [Flutter Timer Tutorial (Bloc Library)](https://bloclibrary.dev/tutorials/flutter-timer/)

---

## 6. Real Implementations to Study

### Tabata Timer by insin (Most Complete)

**Repo**: [github.com/insin/tabata_timer](https://github.com/insin/tabata_timer)

Architecture:
- `WorkoutState` enum: `initial`, `starting`, `exercising`, `resting`, `breaking`, `finished`
- `Workout` class owns a `Timer.periodic(Duration(seconds: 1), _tick)`
- `_tick()`: decrements `_timeLeft`, when it hits 1 second calls `_nextStep()`
- `_nextStep()`: exercises -> rest or break, resting -> next exercise, starting/breaking -> next set
- Audio cues at 3-2-1 second boundaries
- Background color changes per phase (green=exercise, blue=rest, red=break)
- Wakelock during active workout

**Limitation**: Uses simple counter-based timing (not DateTime-anchored). No background service.

### Training Timer by plinkr (MMA/Boxing Focused)

**Repo**: [github.com/plinkr/training_timer](https://github.com/plinkr/training_timer)

Features matching our needs:
- Customizable rounds and intervals
- Visual progress indicators per phase
- Pause/resume support
- Audio alerts at phase transitions and 10-second warnings
- Linux and web support

### Riverpod Timer by raywalz

**Repo**: [github.com/raywalz/riverpod_timer](https://github.com/raywalz/riverpod_timer)

Simple 10-minute countdown demonstrating:
- Riverpod state management with hooks
- Timer provider pattern

### Flutter Interval Timer by dustin-graham (Testing Focus)

**Repo**: [github.com/dustin-graham/flutter_interval_timer](https://github.com/dustin-graham/flutter_interval_timer)

Specifically built to demonstrate testing practices:
- Unit tests for timer logic
- Widget tests for UI
- Integration tests for full flow
- Good separation of concerns

### Bloc Timer Tutorial (Official)

**Tutorial**: [bloclibrary.dev/tutorials/flutter-timer](https://bloclibrary.dev/tutorials/flutter-timer/)

Key pattern -- the `Ticker` data source:
```dart
class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}
```

States: `TimerInitial`, `TimerRunInProgress`, `TimerRunPause`, `TimerRunComplete`
Events: `TimerStarted`, `_TimerTicked`, `TimerPaused`, `TimerResumed`, `TimerReset`

The Bloc subscribes to the Ticker stream, managing a `StreamSubscription` that gets paused/resumed/cancelled.

**What to take from this**: The stream-based Ticker pattern is elegant for single-phase countdowns but doesn't naturally model multi-phase sequences (warmup -> work -> rest -> work...). For multi-phase, the explicit state machine approach in Section 5 is better.

### References
- [Tabata Timer](https://github.com/insin/tabata_timer)
- [Training Timer](https://github.com/plinkr/training_timer)
- [Riverpod Timer](https://github.com/raywalz/riverpod_timer)
- [Flutter Interval Timer](https://github.com/dustin-graham/flutter_interval_timer)
- [Flutter Timer Riverpod MVC Tutorial](https://medium.com/@yujitoshi/how-to-create-a-timer-app-with-flutter-riverpod-mvc-ec941d87cef9)
- [Bloc Timer Tutorial](https://bloclibrary.dev/tutorials/flutter-timer/)

---

## 7. Testing Timers with fakeAsync

### The Core Pattern

```dart
import 'package:fake_async/fake_async.dart';
import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimerNotifier', () {
    test('counts down work phase correctly', () {
      fakeAsync((async) {
        final notifier = TimerNotifier();
        final config = SessionConfig(
          rounds: 3,
          roundDurationSeconds: 180,  // 3 minutes
          restSeconds: 60,
          warmupSeconds: 0,
          warningSeconds: 10,
        );

        notifier.startSession(config);
        expect(notifier.state.phase, TimerPhase.work);
        expect(notifier.state.currentRound, 1);

        // Advance 1 minute
        async.elapse(const Duration(minutes: 1));
        expect(notifier.state.remaining.inSeconds, closeTo(120, 1));

        // Advance to warning threshold
        async.elapse(const Duration(minutes: 1, seconds: 50));
        expect(notifier.state.isWarning, isTrue);

        // Advance past round end
        async.elapse(const Duration(seconds: 10));
        expect(notifier.state.phase, TimerPhase.rest);
        expect(notifier.state.currentRound, 1);

        // Advance past rest
        async.elapse(const Duration(seconds: 60));
        expect(notifier.state.phase, TimerPhase.work);
        expect(notifier.state.currentRound, 2);

        notifier.stop();
      });
    });

    test('pause freezes remaining time', () {
      fakeAsync((async) {
        final notifier = TimerNotifier();
        notifier.startSession(SessionConfig.threeMinRounds(rounds: 1));

        async.elapse(const Duration(seconds: 30));
        notifier.pause();
        final remainingAtPause = notifier.state.remaining;

        async.elapse(const Duration(minutes: 5));
        // Time should NOT have advanced
        expect(notifier.state.remaining, remainingAtPause);

        notifier.resume();
        async.elapse(const Duration(seconds: 10));
        expect(
          notifier.state.remaining.inSeconds,
          closeTo(remainingAtPause.inSeconds - 10, 1),
        );

        notifier.stop();
      });
    });

    test('completes after all rounds', () {
      fakeAsync((async) {
        final notifier = TimerNotifier();
        notifier.startSession(SessionConfig(
          rounds: 2,
          roundDurationSeconds: 10,
          restSeconds: 5,
          warmupSeconds: 0,
          warningSeconds: 0,
        ));

        // Round 1 work (10s) + rest (5s) + round 2 work (10s)
        async.elapse(const Duration(seconds: 26));
        expect(notifier.state.phase, TimerPhase.complete);

        notifier.stop();
      });
    });
  });
}
```

### Critical: Making DateTime.now() Work with fakeAsync

`fakeAsync` does NOT control `DateTime.now()`. You must use the `clock` package:

```dart
// In your timer engine, replace:
DateTime.now()
// With:
clock.now()

// pubspec.yaml
dependencies:
  clock: ^1.1.1

// In your timer code:
import 'package:clock/clock.dart';

class TimerEngine {
  void start(Duration duration) {
    _phaseStartTime = clock.now();  // NOT DateTime.now()
    // ...
  }

  Duration get remaining {
    final elapsed = clock.now().difference(_phaseStartTime!);
    // ...
  }
}
```

Now `fakeAsync` automatically controls `clock.now()`:

```dart
test('timer uses clock correctly', () {
  fakeAsync((async) {
    final engine = TimerEngine();
    engine.start(const Duration(minutes: 3));

    async.elapse(const Duration(minutes: 1));
    // clock.now() has advanced 1 minute, so remaining = 2 minutes
    expect(engine.remaining.inSeconds, closeTo(120, 1));
  });
});
```

### Simulating Background/Resume in Tests

```dart
test('timer survives background cycle', () {
  fakeAsync((async) {
    final notifier = TimerNotifier();
    notifier.startSession(threeRoundConfig);

    // Simulate 30 seconds of normal operation
    async.elapse(const Duration(seconds: 30));

    // Simulate going to background (pause the ticker, not the timer)
    notifier._ticker?.cancel(); // In test, simulate ticker death

    // Simulate 2 minutes in background
    async.elapse(const Duration(minutes: 2));

    // Simulate resume -- restart ticker
    notifier.syncFromBackground();
    async.elapse(const Duration(milliseconds: 100)); // One tick

    // Timer should show ~30s elapsed (30s normal + the tick for
    // re-sync computes from DateTime which advanced 2:30)
    // Actually: 2 minutes 30 seconds have passed total
    expect(
      notifier.state.remaining.inSeconds,
      closeTo(180 - 150, 1), // 30 seconds remaining
    );
  });
});
```

### Widget Test Pattern

Widget tests use FakeAsync by default via `TestWidgetsFlutterBinding`:

```dart
testWidgets('timer display updates', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(home: TimerScreen()),
    ),
  );

  // Tap start
  await tester.tap(find.byKey(const Key('startButton')));
  await tester.pump(); // Rebuild

  // Advance 10 seconds
  await tester.pump(const Duration(seconds: 10));

  // Verify display
  expect(find.text('2:50'), findsOneWidget);
});
```

### flushTimers Gotcha

Avoid `tester.pumpAndSettle()` with periodic timers -- it waits for ALL timers to stop, and a periodic timer never stops. Use `tester.pump(duration)` instead.

### References
- [FakeAsync class docs](https://api.flutter.dev/flutter/package-fake_async_fake_async/FakeAsync-class.html)
- [fake_async package](https://pub.dev/packages/fake_async)
- [clock package](https://pub.dev/packages/clock)
- [Mastering Time in Flutter Tests (Carlos Daniel)](https://cdmunoz.medium.com/mastering-time-in-flutter-tests-how-fakeasync-eliminates-flaky-tests-and-delivers-precision-0e0d909e6b88)
- [Testing Time-dependent Code Reliably](https://tomasrepcik.dev/blog/2022/2022-11-10-time-dependent-coding-copy/)
- [FakeAsync and Clock for Game Logic Tests](https://gladimdim.org/fakeasync-and-clock-as-rescuers-for-your-async-game-logic-tests)
- [DateTime.now() untestable (dart-lang/sdk#28985)](https://github.com/dart-lang/sdk/issues/28985)

---

## 8. Foreground Notification Updates

### Strategy 1: flutter_foreground_task updateService (Recommended)

The `onRepeatEvent` callback fires every N milliseconds (configured via `ForegroundTaskEventAction.repeat(1000)`). Each tick updates the notification:

```dart
@override
void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {
  final remaining = _phaseEndTime.difference(DateTime.now());
  final minutes = remaining.inMinutes;
  final seconds = remaining.inSeconds % 60;

  FlutterForegroundTask.updateService(
    notificationTitle: _currentPhase == 'work'
        ? 'Round $_currentRound of $_totalRounds'
        : _currentPhase == 'rest'
            ? 'Rest'
            : 'Get Ready',
    notificationText: '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')} remaining',
  );
}
```

### Strategy 2: Android Native Chronometer (Most Efficient)

Android notifications support a built-in chronometer that counts up/down natively without needing to update the notification every second. This is the most battery-efficient approach:

```dart
// Using flutter_local_notifications
AndroidNotificationDetails(
  'boxing_timer',
  'Boxing Timer',
  channelDescription: 'Active round timer',
  usesChronometer: true,
  chronometerCountDown: true,
  when: DateTime.now().add(remaining).millisecondsSinceEpoch,
  ongoing: true,
  autoCancel: false,
);
```

The `when` field sets the target time, and Android counts down to it natively. You only need to update the notification when the phase changes (work -> rest, round transitions), not every second.

**Limitation**: The chronometer shows simple time only. For custom text like "Round 3 of 12 - 1:45", you need Strategy 1.

### Strategy 3: Hybrid (Best of Both)

Use the chronometer for the time display but update the title on phase changes:

```dart
void _updateNotificationForPhase() {
  FlutterForegroundTask.updateService(
    notificationTitle: 'Round $_currentRound / $_totalRounds - $_phaseName',
    notificationText: '', // Chronometer handles the countdown
  );
}

// Only called on phase transitions, not every second
void _onPhaseTransition(String newPhase) {
  _currentPhase = newPhase;
  _updateNotificationForPhase();
}
```

### Notification Content Recommendations for Boxing Timer

| Phase | Title | Text |
|-------|-------|------|
| Warmup | Get Ready | 0:15 remaining |
| Work | Round 3 of 12 | 2:45 |
| Rest | Rest | 0:45 |
| Complete | Workout Complete | 12 rounds - 48:00 total |

### Battery Optimization Note

On Android 15, `dataSync` foreground services are limited to 6 hours per 24-hour period. Using `mediaPlayback` type (which we need anyway for audio) does NOT have this limitation. This is another reason to use `mediaPlayback` as the foreground service type.

### References
- [flutter_foreground_task](https://pub.dev/packages/flutter_foreground_task)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [flutter_background_service](https://pub.dev/packages/flutter_background_service)
- [Countdown Notification (flutter_local_notifications)](https://medium.com/@hemantkumarceo001/day-35-master-flutter-local-notification-part-5-countdown-notification-2c7fdcdc7cf9)

---

## Architecture Summary: How It All Fits Together

```
┌──────────────────────────────────────────────────────┐
│                    Main Isolate                       │
│                                                      │
│  ┌─────────────────────────────────────────────────┐ │
│  │              TimerNotifier (Riverpod)            │ │
│  │                                                 │ │
│  │  State: { phase, round, remaining, isPaused }   │ │
│  │  Uses: clock.now() for DateTime anchoring       │ │
│  │  Drives: Timer.periodic(100ms) for UI refresh   │ │
│  │  Manages: Phase transitions (state machine)     │ │
│  │  Triggers: Audio cues via AudioService          │ │
│  └─────────────────────────────────────────────────┘ │
│                         │                             │
│  ┌──────────────────────▼──────────────────────────┐ │
│  │           AppLifecycleListener                  │ │
│  │                                                 │ │
│  │  onPause → start foreground service             │ │
│  │  onResume → sync from service, restart ticker   │ │
│  │           → Future(() => null) event loop fix    │ │
│  └─────────────────────────────────────────────────┘ │
│                         │                             │
│  ┌──────────────────────▼──────────────────────────┐ │
│  │              UI Layer (Widgets)                  │ │
│  │                                                 │ │
│  │  ConsumerWidget watches timerNotifierProvider    │ │
│  │  Displays: time, round, phase, progress         │ │
│  │  Colors: green=work, blue=rest, red=warning     │ │
│  └─────────────────────────────────────────────────┘ │
└──────────────────────────┬───────────────────────────┘
                           │ (app backgrounded)
                           ▼
┌──────────────────────────────────────────────────────┐
│          Foreground Service Isolate                   │
│          (flutter_foreground_task)                    │
│                                                      │
│  BoxingTimerTaskHandler                              │
│  - Receives session state on init                    │
│  - onRepeatEvent(1s): computes remaining,            │
│    updates notification, sends state to main         │
│  - Handles phase transitions independently           │
│  - Plays audio cues via platform channel             │
│                                                      │
│  ┌────────────────────────────────────────────────┐  │
│  │  Android Notification                          │  │
│  │  Title: "Round 3 of 12"                        │  │
│  │  Text:  "2:45 remaining"                       │  │
│  │  Updated every 1s via updateService()          │  │
│  └────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────┘

Testing:
  clock.now() + fakeAsync → full control of time
  async.elapse(duration) → advance timer deterministically
  No flaky tests, no real waits
```

### Key Design Decisions

1. **DateTime (via `clock.now()`) over counters** -- Immune to drift, background-safe, testable
2. **100ms Timer.periodic for UI** -- Smooth display updates, doesn't affect accuracy
3. **Enum state machine over library** -- Simple linear phases don't need FSM framework
4. **flutter_foreground_task over audio_service for background** -- Purpose-built for this use case
5. **Duplicate timer logic in TaskHandler** -- Foreground service isolate runs independently; sync on resume
6. **clock package for testability** -- fakeAsync controls clock.now(); DateTime.now() is untestable
7. **AppLifecycleListener over WidgetsBindingObserver** -- Newer API (Flutter 3.13+), cleaner callback pattern
8. **mediaPlayback service type** -- No Android 15 time limits; matches our audio use case
