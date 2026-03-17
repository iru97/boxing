# Boxing Training Timer - Project Vision

## The Problem

Boxing timer apps on the market suffer from critical issues that frustrate real fighters and trainers:

### Top Pain Points (from real user feedback)
1. **Timer dies in background** - The #1 complaint. Timers stop when the screen locks, when switching to Spotify, or when the phone goes to sleep. Fighters miss round starts/ends.
2. **Terrible audio** - Sounds are too quiet, get buried under music, use cheesy non-boxing sounds. No authentic gym bell. Can't hear the 10-second warning over Spotify.
3. **Feature bloat** - Apps try to be HIIT/Tabata/Yoga/CrossFit timers. Boxers don't need that. They need a boxing timer that works perfectly.
4. **Aggressive monetization** - Free apps full of ads, or bait-and-switch subscriptions that strip features from paid users.
5. **Can't use with gloves on** - No hands-free controls. One app's tip: "push start with your tongue."
6. **Battery/data drain** - Timer apps consuming 5GB of data or killing battery life.
7. **Poor UX** - Confusing navigation, duplicated custom timers, unclear current state.
8. **Unresponsive developers** - No updates, no bug fixes, no response to user feedback.

## Our Solution: Boxing

A **boxing-first** training timer that nails the fundamentals before anything else:

### Core Philosophy
- **Reliability over features** - The timer NEVER stops. Background mode, screen lock, music playing - it works.
- **Boxing-specific** - Not a generic interval timer. Built by and for boxers.
- **Loud and clear** - Authentic gym bell sounds that cut through music. Configurable audio that WORKS.
- **Simple and fast** - Start a round in 2 taps. No bloat, no confusion.
- **Glove-friendly** - Large touch targets, minimal interaction needed mid-workout.

### Core Feature: Session-Based Round Management

A "Session" is a complete training configuration:

```
Session: "Heavy Bag Work"
├── Rounds: 8
├── Round Duration: 3:00
├── Rest Duration: 1:00
├── Warning At: 0:10 (10-second warning before round ends)
├── Sounds:
│   ├── Round Start: gym_bell_single
│   ├── Round End: gym_bell_triple
│   ├── Warning: gym_bell_double
│   ├── Rest End Warning: countdown_beep
│   └── Session Complete: gym_bell_long
├── Auto-advance: true
└── Keep Screen On: true
```

### Preset Sessions (Built-in)

| Session | Rounds | Work | Rest | Warning | Use Case |
|---------|--------|------|------|---------|----------|
| Pro Boxing | 12 | 3:00 | 1:00 | 0:10 | Pro fight simulation |
| Amateur Boxing | 3 | 3:00 | 1:00 | 0:10 | Amateur fight simulation |
| Shadow Boxing | 5 | 3:00 | 1:00 | 0:10 | Warm-up / technique |
| Heavy Bag | 8 | 3:00 | 1:00 | 0:10 | Power and combos |
| Speed Bag | 6 | 2:00 | 0:30 | 0:05 | Speed and rhythm |
| Sparring | 6 | 3:00 | 1:00 | 0:10 | Partner work |
| Conditioning | 10 | 0:30 | 0:30 | 0:05 | HIIT-style boxing |
| Beginner | 4 | 2:00 | 1:00 | 0:10 | New boxers |
| Muay Thai | 5 | 3:00 | 1:00 | 0:10 | Muay Thai rules |
| MMA | 3 | 5:00 | 1:00 | 0:10 | MMA fight simulation |

### Session Configuration Options

- **Round count**: 1-30 rounds
- **Round duration**: 15s to 10:00
- **Rest duration**: 0s to 5:00
- **Warning time**: 5s, 10s, 15s, 30s, or off
- **Sound pack**: Different bell/buzzer sound sets
- **Volume override**: Force volume level regardless of phone settings
- **Auto-advance**: Auto-start next round after rest, or wait for tap
- **Screen behavior**: Keep on, dim, or follow system
- **Warmup timer**: Optional countdown before first round (10s, 15s, 30s)

## Technical Priorities

### Must Work Perfectly
1. Timer accuracy - never drift, never stop
2. Background execution - works with screen locked
3. Audio over music - sounds must cut through Spotify/Apple Music
4. Screen wake lock - screen stays on during active session
5. Battery efficiency - minimal drain

### Flutter Technical Stack (Planned)
- `just_audio` + `audio_service` - Background audio with foreground service
- `wakelock_plus` - Keep screen on during sessions
- State management: Riverpod or Bloc
- Local storage: Hive or SharedPreferences for session configs
- Minimal permissions: audio, foreground service, wake lock only

## Competitive Landscape

### Direct Competitors
| App | Rating | Strength | Weakness |
|-----|--------|----------|----------|
| Boxing Interval Timer | 4.8/5 | Popular, reliable | Background mode issues |
| Boxing Round Timer Pro | 5.0/5 | Simple, clean | Missing 10s audio cue |
| Timer Plus | High | Gym-visible display | Generic, not boxing-specific |
| Boxing iTimer Lite | Good | Background mode, presets | iOS only, dated UI |
| Shadow Boxing App | #1 2025 | Guided workouts, combos | More than just a timer |

### Our Differentiation
1. **Background reliability** as a first-class feature, not an afterthought
2. **Boxing-specific presets** that match real training protocols
3. **Audio that actually works** over music with volume override
4. **Zero ads, zero subscriptions** for core timer functionality
5. **Glove-friendly UX** with large targets and minimal mid-workout interaction

## Future Potential (Phase 2+)
- Combo callouts (voice: "jab-cross-hook")
- Training log and session history
- Coach mode (manage multiple timers for a class)
- Apple Watch / Wear OS companion
- Workout templates (warm-up -> bag work -> cooldown as one flow)
- Music integration (auto-pause/resume with rounds)
- Social features (share workouts)

## Target Users
1. **Solo home trainers** - Heavy bag at home, need a reliable timer
2. **Gym boxers** - Training at a boxing gym, want personal timer on phone
3. **Beginners** - Just starting boxing, need simple presets
4. **Coaches** - Want to manage round timing for their sessions
5. **Combat sport athletes** - Boxing, Muay Thai, MMA, kickboxing
