# Testing Guide — Boxing Timer App

## Overview

Testing is split into four layers:

| Layer | Tool | Coverage | Run Time |
|-------|------|----------|----------|
| Unit (timer engine) | `flutter test` | Timer accuracy, state machine, audio cues | ~3s |
| Widget | `flutter test` | UI rendering, controls, phase colors | ~10s |
| Integration (repo) | `flutter test` | Hive CRUD, serialization, presets | ~3s |
| Device / manual | Physical device | Background, audio ducking, wake lock | 30 min |

---

## 1. Automated Tests

### Run all tests

```bash
export PATH="/opt/flutter/bin:$PATH"
flutter test
```

Expected: **73 tests, 0 failures**.

### Run a specific file

```bash
flutter test test/timer_engine_test.dart
flutter test test/timer_screen_test.dart
flutter test test/session_repository_test.dart
```

### Run with coverage

```bash
flutter test --coverage
# View report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Analyze code

```bash
flutter analyze
# Expected: No issues found
```

---

## 2. Building for Devices

### Android

**Debug build (USB debugging):**
```bash
flutter run                          # Connected device
flutter run -d <device-id>          # Specific device
```

**Release build:**
```bash
flutter build apk --release         # APK (sideload/testing)
flutter build appbundle --release   # AAB (Play Store)
```

**Install APK directly:**
```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

### iOS

**Debug build (requires Xcode + Apple Developer account):**
```bash
flutter run                         # Connected iPhone/iPad
```

**Release build:**
```bash
flutter build ios --release --no-codesign   # Without signing (CI)
flutter build ios --release                  # With signing
```

**Open in Xcode for device provisioning:**
```bash
open ios/Runner.xcworkspace
```

---

## 3. Device Testing Checklist

### Prerequisites
- Physical Android device (API 24+, Android 7.0+) **or** iPhone (iOS 14+)
- Spotify or Apple Music installed and playing music
- USB cable or wireless ADB

### 3.1 Basic Timer Flow

| # | Test | Expected |
|---|------|----------|
| 1 | Launch app | Session list shows 17 presets |
| 2 | Tap "Heavy Bag" | Session summary screen with rounds/duration |
| 3 | Tap START | Timer starts, WORK phase, green color |
| 4 | Wait for warning | Color turns amber, bell sounds at 10s |
| 5 | Wait for round end | Bell sounds (triple), REST phase, red color |
| 6 | Wait for rest end | Bell sounds, next WORK phase starts |
| 7 | Tap pause | Timer freezes, PAUSED label, skip buttons dim |
| 8 | Tap resume | Timer continues from exact moment |
| 9 | Tap skip forward | Jumps to next phase immediately |
| 10 | Tap skip back | Restarts current round from full duration |
| 11 | Complete all rounds | Session complete screen with stats |
| 12 | Tap REPEAT | Restarts same session |
| 13 | Tap DONE | Returns to session list |

### 3.2 Background Survival (Critical)

This is the #1 failure mode in competing apps. Test on a **real device**.

| # | Test | Expected |
|---|------|----------|
| 1 | Start timer | Round counting down |
| 2 | Press home button | App backgrounds |
| 3 | Wait 30 seconds | Notification shows updated round/time |
| 4 | Return to app | Timer is accurate (≤100ms drift) |
| 5 | Lock screen during rest | Timer continues in background |
| 6 | Unlock screen | Timer displays correct time |
| 7 | Open another app (Maps) | Timer keeps running |
| 8 | Switch back | No drift |

**Samsung-specific (aggressive battery optimization):**
1. Go to Settings → Battery → App power management
2. Find "boxing" → Set to "Unrestricted"
3. Repeat background tests above

**If timer stops in background:**
- Check `AndroidManifest.xml` has `FOREGROUND_SERVICE` permission
- Check notification is showing (confirms foreground service is running)
- Check `audio_service` is initialized in `main.dart`

### 3.3 Audio Ducking

| # | Test | Expected |
|---|------|----------|
| 1 | Start Spotify, play music | Music playing at normal volume |
| 2 | Start boxing timer | Music continues (does NOT stop) |
| 3 | Wait for bell | Music ducks briefly, bell plays over it |
| 4 | Bell completes | Music returns to normal volume |
| 5 | Lock screen, music + timer | Bell still audible through lock screen |

**If music stops entirely instead of ducking:**
- This is the `gainTransientMayDuck` vs `gainTransient` issue
- Check `AudioSession` configuration in `boxing_audio_handler.dart`

**If bell is too quiet:**
- Test with `volumeOverride: true` in settings (uses alarm stream)

### 3.4 Wake Lock

| # | Test | Expected |
|---|------|----------|
| 1 | Start timer | Screen stays on (no auto-sleep) |
| 2 | Pause timer for >5 min | Screen may sleep (wake lock still held) |
| 3 | Session complete | Screen can sleep normally |
| 4 | Force-stop app | Wake lock released |

**Verify wake lock on Android:**
```bash
adb shell dumpsys power | grep "WAKE LOCK"
# Should show: boxing PARTIAL_WAKE_LOCK while session active
```

### 3.5 Session Management

| # | Test | Expected |
|---|------|----------|
| 1 | Tap + FAB | New Session editor opens |
| 2 | Leave name blank, tap SAVE | Validation error shown |
| 3 | Fill form, tap SAVE | Snackbar "Saved" + back to list |
| 4 | Long-press custom session | Edit / Duplicate / Delete menu |
| 5 | Edit session → Save | Changes persisted after app restart |
| 6 | Delete session | Snackbar "Deleted" + removed from list |
| 7 | Long-press preset | Only "Duplicate as Custom" option |
| 8 | Duplicate preset | Creates editable copy, snackbar shown |
| 9 | Kill + relaunch app | Custom sessions still present |

### 3.6 Settings

| # | Test | Expected |
|---|------|----------|
| 1 | Open Settings | All options visible |
| 2 | Change theme to Light | App theme changes immediately |
| 3 | Change Default Warning to 5s | New sessions start with 5s warning |
| 4 | Toggle Haptic Feedback off | No vibration on button taps |
| 5 | Kill + relaunch | Settings persisted |

---

## 4. Performance Targets

| Metric | Target | How to Measure |
|--------|--------|----------------|
| Timer accuracy | ≤100ms drift per phase | fakeAsync tests + device stopwatch |
| Frame rate | 60fps during countdown | Flutter DevTools → Performance |
| Memory (30 min session) | No leaks | DevTools → Memory → Heap |
| APK size | <25MB | `flutter build apk` → check output |
| Audio latency | <200ms after phase change | Listen for bell at exact moment |
| Cold start | <2s to session list | Manual stopwatch |

### Flutter DevTools

```bash
flutter run --profile                # Profile mode (no debug overhead)
# Open DevTools URL printed in terminal
```

Key screens:
- **Performance** — frame timeline, jank detection
- **Memory** — heap allocations, leak detection
- **CPU Profiler** — find expensive operations

---

## 5. CI / Automated Pipeline

The GitHub Actions workflow (`.github/workflows/ci.yml`) runs on every push:

```
analyze → test → build (Android)
```

**Trigger manually:**
```bash
gh workflow run ci.yml
gh run watch   # Watch progress
```

**View test results:**
```bash
gh run view --log
```

---

## 6. Known Limitations & Workarounds

| Issue | Affected Devices | Workaround |
|-------|-----------------|------------|
| Battery optimization kills background | Samsung, Xiaomi, Huawei | Disable battery optimization for app in device settings |
| Volume override limited on iOS | All iOS | Uses `playback` audio category; hardware volume controls still work |
| Background audio requires foreground service | Android only | Notification is required and intentional |
| Wakelock not granted without permission | Some Android | `WAKE_LOCK` in manifest — already configured |

---

## 7. Test Data

### Quick-test session (use for manual testing)

Create a custom session with:
- Rounds: 2
- Round Duration: 0:15
- Rest Duration: 0:05
- Warning: 5s

This completes in ~45 seconds — fast enough for iterative manual testing.

### Preset for audio testing

Use **Tabata** (8 × 20s work / 10s rest):
- Fast phase transitions (every 20s)
- No warmup
- Tight warning window (5s)
