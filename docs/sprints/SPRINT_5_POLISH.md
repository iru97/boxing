# Sprint 5: Polish & UX

## Objective
Production-quality user experience: animations, haptics, multiple sound packs, settings screen, resume countdown, and overall refinement.

## Tasks

### Task 5.1: Resume Countdown Overlay
- After pressing resume from pause: show full-screen 3-2-1 countdown
- Large numbers with scale animation (shrink from 200% to 100%)
- Each number accompanied by a short beep
- After "1": timer resumes, overlay dismisses
- Configurable: on/off in settings (default: on)
- **Agent**: widget-builder

### Task 5.2: Session Start Countdown
- Before round 1 (when warmup is > 0): show countdown overlay
- Same visual style as resume countdown
- Uses configured warmup duration (5s, 10s, 15s, 30s)
- For 10s+ warmups: only show last 5 seconds as overlay
- **Agent**: widget-builder

### Task 5.3: Additional Sound Packs
- **Classic Bell** (already exists): Authentic boxing gym bell
- **Digital Buzzer**: Sharp electronic tones
  - round_start: short buzz
  - warning: rapid double buzz
  - round_end: long buzz
  - session_complete: ascending buzz pattern
- **Minimal Beep**: Quiet, simple tones for home/apartment training
  - round_start: soft beep
  - warning: two soft beeps
  - round_end: three soft beeps
  - session_complete: ascending beep melody
- Total: 12 audio files (4 per pack)
- Preview play in session editor and settings
- **Agent**: flutter-specialist

### Task 5.4: Haptic Feedback System
- Event → haptic mapping:
  - Round start: `HapticFeedback.heavyImpact()`
  - Warning: `HapticFeedback.mediumImpact()`
  - Round end: `HapticFeedback.heavyImpact()` x2 (with 100ms delay)
  - Session complete: custom pattern via `vibration` package
  - Button press: `HapticFeedback.selectionClick()`
- Configurable: on/off in settings (default: on)
- Works alongside audio (belt AND vibration for noisy gyms)
- **Agent**: flutter-specialist

### Task 5.5: Settings Screen Implementation
- Full settings screen with sections:
  - **Timer Defaults**:
    - Default warmup duration
    - Default warning time
    - Default auto-advance
    - Default keep screen on
    - Resume countdown on/off
  - **Audio**:
    - Default sound pack (with preview)
    - Volume override on/off
    - Haptic feedback on/off
  - **Display**:
    - Theme (Dark / Light / System)
    - Tap to pause on/off (tap anywhere on timer screen)
  - **About**:
    - App version
    - Rate the app (link to store)
    - Feedback email
    - Privacy policy
    - Licenses
- Settings stored in Hive, loaded via Riverpod provider
- Changes apply immediately
- **Agent**: widget-builder + state-manager

### Task 5.6: Phase Transition Effects
- On phase change: brief screen flash (white overlay, 100ms fade)
- Progress ring: quick "reset" animation to 100% when new phase starts
- Round counter: scale pulse animation (1.0 → 1.15 → 1.0, 300ms)
- Phase label: fade transition (200ms)
- Keep subtle - don't distract from the workout
- **Agent**: widget-builder

### Task 5.7: Session Complete Screen
- Full-screen results:
  - Session name
  - Total time
  - Rounds completed
  - "Great workout!" message
- Buttons:
  - "Done" → navigate home
  - "Repeat" → restart same session immediately
- Optional: confetti or simple celebration animation
- **Agent**: widget-builder

### Task 5.8: Empty States
- No custom sessions: illustration + "Create your first session" + CTA button
- Audio load failure: toast "Sound pack unavailable, using default"
- Storage error: toast "Could not save, please try again"
- **Agent**: widget-builder

### Task 5.9: Tap-to-Pause Feature
- Optional: tap anywhere on the timer display area to pause/resume
- Enabled/disabled in settings (default: off, to avoid accidental taps)
- When enabled: entire center area of timer screen is a giant tap target
- Visual hint: subtle text "Tap to pause" on first use
- **Agent**: widget-builder

### Task 5.10: App Icon & Splash
- App icon: boxing glove or timer icon, bold and recognizable
- Adaptive icon for Android
- Standard icon for iOS
- Splash screen: dark background with app name centered
- Use `flutter_native_splash` package
- **Agent**: widget-builder

### Task 5.11: Onboarding (Optional)
- First launch only: 2-3 screen walkthrough
  - "Built for boxers" - show timer concept
  - "Reliable & loud" - explain background + audio
  - "Get started" → go to home with presets
- Skip option on every screen
- **Agent**: widget-builder

### Task 5.12: Quality Pass
- Run through every user flow and fix rough edges
- Check all error states
- Verify accessibility (screen reader labels on buttons)
- Test on small screen (320dp width) and large screen (tablet)
- **Agent**: code-reviewer

## Definition of Done
- [ ] Resume countdown 3-2-1 works
- [ ] All 3 sound packs work with preview
- [ ] Haptic feedback fires for all events
- [ ] Settings screen fully functional with persistence
- [ ] Phase transition animations smooth
- [ ] Session complete screen shows summary
- [ ] Tap-to-pause works when enabled
- [ ] App icon and splash screen display
- [ ] No crashes or unhandled errors in any flow
- [ ] Accessible (screen reader labels)
