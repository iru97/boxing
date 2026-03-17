# Sprint 6: Platform & Release

## Objective
Platform-specific configuration, comprehensive device testing, performance optimization, and app store preparation.

## Tasks

### Task 6.1: Android Release Configuration
- `android/app/build.gradle`:
  - `minSdkVersion: 24` (Android 7.0+, 97%+ coverage)
  - `targetSdkVersion: 34`
  - `compileSdkVersion: 34`
  - Signing config for release keystore
- Generate release keystore and store securely
- ProGuard/R8 keep rules for:
  - just_audio native code
  - audio_service
  - Hive type adapters
- Test release APK on real device
- **Agent**: platform-integrator

### Task 6.2: iOS Release Configuration
- Deployment target: iOS 14.0
- Verify capabilities: Background Modes (audio)
- Verify Info.plist entries
- App icons all sizes (via flutter_launcher_icons)
- Launch screen configuration
- Test release build on real device
- **Agent**: platform-integrator

### Task 6.3: Device Testing Matrix
- **Android Stock (Pixel)**: Full test pass
  - Timer background, audio ducking, notifications, wake lock
- **Samsung Galaxy**: Critical test
  - Battery optimization, Sleeping Apps, timer survival
  - Document any required user steps
- **Budget Android**: Performance test
  - Check for jank, audio latency, memory usage
- **iPhone (Recent)**: Full test pass
  - Timer background, audio ducking, lock screen
- **iPhone (Older, iOS 14)**: Compatibility test
  - Ensure all features work on minimum supported version
- **Document**: Create test checklist and results matrix

### Task 6.4: Performance Profiling
- Use Flutter DevTools:
  - Frame rendering: verify 60fps during timer animations
  - Memory: no leaks after 30-minute session (check stream subscriptions, timers)
  - CPU: timer tick processing < 1ms
- Battery drain measurement:
  - Run 30-minute session, measure battery consumption
  - Compare foreground vs background battery usage
  - Target: < 5% battery per 30-minute session
- APK/IPA size:
  - Target: < 20MB (including sound assets)
  - If larger: compress audio, tree-shake unused code

### Task 6.5: Timer Accuracy Validation
- Run full 12-round pro boxing session (36 minutes + rests)
- Compare session end time vs expected
- Acceptable: within ±1 second over 36 minutes
- Test in foreground, background, and mixed scenarios
- Document results

### Task 6.6: Accessibility Audit
- All interactive elements have semantic labels
- Screen reader can announce: round number, time remaining, phase
- High contrast mode works
- No information conveyed by color alone (phase label + color)
- Dynamic type / font scaling doesn't break layout

### Task 6.7: App Store Metadata
- **App Name**: "Boxing Timer - Round Trainer" (or similar, needs ASO research)
- **Description**: Short and long descriptions
- **Keywords**: boxing timer, round timer, boxing training, Muay Thai, MMA
- **Category**: Health & Fitness / Sports
- **Screenshots**:
  - Home screen with presets
  - Active timer (work phase)
  - Active timer (rest phase)
  - Session editor
  - Settings
  - Sizes: 6.7", 6.5", 5.5" (iOS), Phone + 7" + 10" (Android)
- **Privacy Policy**: Simple page - "We don't collect any data"
- **Age Rating**: 4+ (no objectionable content)

### Task 6.8: CI/CD Setup
- GitHub Actions workflow:
  - On push to main: `flutter analyze` + `flutter test`
  - On tag: build release APK and IPA
- Fastlane (optional): automated app store deployment
- Version numbering: 1.0.0 (semver)

### Task 6.9: Final QA Pass
- Run through every user flow on both platforms
- Create and run through complete test checklist:
  - [ ] Fresh install → presets visible
  - [ ] Start preset → timer runs → complete
  - [ ] Create custom session → save → load → start → complete
  - [ ] Edit custom session → save → verify changes
  - [ ] Delete custom session → confirm → verify gone
  - [ ] Background timer → return → verify accurate
  - [ ] Lock screen → bell plays → unlock → verify accurate
  - [ ] Play Spotify → start session → bell ducks music
  - [ ] Pause → resume countdown → continue
  - [ ] Skip forward/back during session
  - [ ] Stop mid-session → confirm → home
  - [ ] Settings changes apply
  - [ ] Force-kill app → restart → checkpoint offer
  - [ ] Low battery mode → timer still works
  - [ ] Phone call during session → handle gracefully

### Task 6.10: Documentation
- README.md for GitHub repo
- Contributing guidelines (if open source)
- In-app help (optional): FAQ or tips screen
- Update CLAUDE.md with final architecture decisions

## Definition of Done
- [ ] Release APK builds and installs on Android device
- [ ] Release IPA builds (or --no-codesign for CI)
- [ ] All device tests pass
- [ ] Timer accurate within ±1 second over 36-minute session
- [ ] 60fps maintained on budget device
- [ ] No memory leaks after 30-minute session
- [ ] Battery drain < 5% per 30-minute session
- [ ] APK size < 20MB
- [ ] Accessibility audit passes
- [ ] App store metadata and screenshots ready
- [ ] CI/CD running
- [ ] Final QA checklist complete
