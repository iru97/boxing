# Boxing Training Timer - Project Vision

## The Problem

Boxing timer apps on the market suffer from critical issues that frustrate real fighters and trainers:

### Top Pain Points (from real user feedback)
1. **Timer dies in background** - The #1 complaint across ALL apps. Timers stop when the screen locks, when switching to Spotify, or when the phone goes to sleep. Samsung/Android battery optimization actively kills timer apps.
2. **Terrible audio** - Sounds too quiet, get buried under music, use cheesy non-boxing sounds. Some apps stop music entirely when the bell rings instead of ducking. Users miss round endings.
3. **Feature bloat** - Apps try to be HIIT/Tabata/Yoga/CrossFit timers. Boxers don't need that.
4. **Aggressive monetization** - Boxing Timer Pro moved from one-time purchase to subscription, stripping features from paid users. Apps promise "no ads" in paid versions but still show them.
5. **Can't use with gloves on** - Only ONE app (Boxing Interval Timer) offers proximity/shake sensor. Every other app requires removing gloves. One app's tip: "push start with your tongue."
6. **No per-round customization** - Users want Round 1 at 3:00 but Round 5 at 2:00 for conditioning drills. Almost no app supports this.
7. **Battery/data drain** - Timer apps consuming 5GB of data or killing battery.
8. **Custom timer bugs** - Timers duplicate in saved lists, crash at specific times (e.g., always at :57), or freeze mid-round.

## Competitive Landscape

### Dedicated Boxing Timers

| App | Platform | Rating | Price | Strength | Key Weakness |
|-----|----------|--------|-------|----------|--------------|
| Boxing Interval Timer | Both | ~4.5 | Free/$3.99 | Proximity/shake sensor (gloves!), per-round times | Background mode still fails |
| Boxing Timer Pro | iOS | ~4.5 | Subscription | AirPlay to TV, 9 bell sounds | Subscription bait-and-switch backlash |
| Boxing Round Timer Pro | Android | ~4.5 | One-time | Reaction training mode, no ads | Limited sound customization |
| Boxing Timer Champ | iOS | Good | Free/$4.99 | Background mode, stored routines | iOS only |
| KruBoss | Both | High | **Free, no ads** | Built by martial artists, loud bells | Basic feature set |
| Boxing Round Interval Timer | Android | ~4.5 | Free | Works with Spotify | Android only |

### Training Apps (Timer + Coaching)

| App | Rating | Price | Notable |
|-----|--------|-------|---------|
| Shadow Boxing App | **4.9/5** (6,500+ reviews) | **Free, no ads** | Pad work, freestyle, defense, footwork, Apple Watch haptics, AirPods heart rate |
| Heavy Bag Pro | **4.9/5** | Subscription | 1000+ combos, 3D animations, voice instructions |
| Precision Boxing Coach | ~4/5 | $4.99 | AI combo callouts by number, Virtual Padwork |
| FightCamp | High | **$39/month + equipment** | Full guided workouts, punch tracking sensors |

### Market Gaps We Will Exploit
1. **Background reliability** - No app has fully solved this on both platforms
2. **Audio ducking** - Coexist with Spotify/Apple Music without conflicts
3. **Glove-friendly controls** - Only 1 of 10+ apps addresses this
4. **Per-round customization** - Almost entirely unsupported
5. **Intra-round signals** - Pacing beeps every 30s within a round (for drills)
6. **Voice round announcements** - "Round 3" at the start of each round
7. **Wearable haptics** - Feel the bell on your wrist in a noisy gym
8. **Coach sharing** - Create a config and push it to athletes
9. **Fair pricing** - Users accept $3-5 one-time; revolt against timer subscriptions

## Our Solution: Boxing

A **boxing-first** training timer that nails the fundamentals before anything else.

### Core Philosophy
- **Reliability over features** - The timer NEVER stops. Background mode, screen lock, music playing - it works.
- **Boxing-specific** - Not a generic interval timer. Built by and for boxers.
- **Loud and clear** - Authentic gym bell sounds that cut through music via audio ducking. Volume override.
- **Simple and fast** - Start a round in 2 taps. No bloat, no confusion.
- **Glove-friendly** - Large touch targets, proximity sensor, shake-to-pause. Minimal interaction mid-workout.

### Core Feature: Session-Based Round Management

A "Session" is a complete training configuration:

```
Session: "Heavy Bag Work"
├── Rounds: 8
├── Round Duration: 3:00 (default, can be overridden per-round)
├── Rest Duration: 1:00
├── Warning At: 0:10 (10-second warning before round ends)
├── Warmup: 0:15 (countdown before round 1)
├── Sounds:
│   ├── Round Start: gym_bell_single
│   ├── Round End: gym_bell_triple
│   ├── Warning: gym_bell_double (10s clapper)
│   ├── Rest End Warning: countdown_beep
│   └── Session Complete: gym_bell_long
├── Voice Announce: true ("Round 3")
├── Intra-round Signal: off (or every 30s for drills)
├── Auto-advance: true
├── Keep Screen On: true
└── Per-round Overrides: [] (optional per-round duration changes)
```

### Preset Sessions (Built-in)

| Session | Rounds | Work | Rest | Warning | Use Case |
|---------|--------|------|------|---------|----------|
| Pro Boxing (Men) | 12 | 3:00 | 1:00 | 0:10 | Pro men's fight simulation |
| Pro Boxing (Women) | 10 | 2:00 | 1:00 | 0:10 | Pro women's fight simulation |
| Amateur Boxing | 3 | 3:00 | 1:00 | 0:10 | Amateur fight simulation |
| Amateur Women | 3 | 2:00 | 1:00 | 0:10 | Women's amateur rules |
| Shadow Boxing | 5 | 3:00 | 0:30 | 0:10 | Warm-up / technique |
| Heavy Bag | 8 | 3:00 | 1:00 | 0:10 | Power and combos |
| Speed Bag | 6 | 2:00 | 0:30 | 0:05 | Speed and rhythm |
| Sparring | 6 | 3:00 | 1:00 | 0:10 | Partner work |
| Pad Work | 4 | 3:00 | 1:00 | 0:10 | Mitts with coach |
| Conditioning | 10 | 0:30 | 0:30 | 0:05 | HIIT-style boxing |
| Tabata | 8 | 0:20 | 0:10 | off | Tabata protocol |
| EMOM | 10 | 1:00 | 0:00 | 0:10 | Every Minute On the Minute |
| Beginner | 4 | 2:00 | 1:00 | 0:10 | New boxers |
| Youth Boxing | 4 | 1:30 | 1:00 | 0:10 | Junior fighters |
| Muay Thai | 5 | 3:00 | 2:00 | 0:10 | Muay Thai rules (2min rest) |
| MMA | 3 | 5:00 | 1:00 | 0:10 | MMA fight simulation |
| Kickboxing | 3 | 3:00 | 1:00 | 0:10 | Kickboxing rules |

### Session Configuration Options

- **Round count**: 1-30 rounds
- **Round duration**: 15s to 10:00 (per-session default + per-round overrides)
- **Rest duration**: 0s to 5:00
- **Warning time**: 5s, 10s, 15s, 30s, or off
- **Warmup countdown**: 0s, 5s, 10s, 15s, 30s
- **Sound pack**: Different bell/buzzer sound sets (authentic gym bells primary)
- **Volume override**: Force volume level regardless of phone settings
- **Voice announcements**: Announce round number at start of each round
- **Intra-round signal**: Optional pacing beep every N seconds within a round
- **Auto-advance**: Auto-start next round after rest, or wait for tap
- **Resume countdown**: 3-2-1 countdown when resuming after a pause
- **Round labels**: Name individual rounds (e.g., "Heavy Bag", "Speed Bag") for multi-phase workouts
- **Screen behavior**: Keep on, dim, or follow system

## Technical Priorities

### Must Work Perfectly (Phase 1)
1. Timer accuracy - never drift, never stop, DateTime-based
2. Background execution - works with screen locked, survives Android Doze
3. Audio ducking - sounds play OVER Spotify/Apple Music, don't stop it
4. Volume override - bell is always audible
5. Screen wake lock - screen stays on during active session
6. Battery efficiency - foreground service only during active session

### Flutter Technical Stack
- `just_audio` + `audio_service` - Background audio with foreground service
- `wakelock_plus` - Keep screen on during sessions
- `proximity_sensor` or custom platform channel - Glove-friendly controls
- State management: Riverpod
- Local storage: Hive for session configs and settings
- Minimal permissions: audio, foreground service, wake lock

## Monetization Strategy

Based on market research, users strongly reject subscriptions for timers but accept one-time purchases:

- **Free tier**: Full timer with all presets, limited to 3 custom sessions
- **One-time purchase ($3.99-$4.99)**: Unlimited custom sessions, per-round overrides, all sound packs, coach sharing
- **Zero ads in any tier** - This is a key differentiator
- **Future subscription (Phase 2+)**: Only for coaching content (combo callouts, training programs, guided workouts)

## Feature Roadmap

### Phase 1: Perfect Timer (MVP)
- Session model with all config options
- 10 built-in presets
- Custom session creation and persistence
- Reliable timer engine (background, audio ducking, wake lock)
- Authentic bell sounds with volume override
- Large, gym-visible display with phase colors
- Basic glove-friendly UX (large targets)

### Phase 2: Enhanced Experience
- Per-round duration overrides
- Voice round announcements ("Round 3")
- Intra-round pacing signals
- Proximity sensor / shake to pause
- Session history and training log
- Multiple sound packs
- Landscape mode for gym TV display

### Phase 3: Multi-Phase Workouts & Coaching
- **Multi-phase sessions**: Chain different timer configs into one workout flow:
  ```
  Full Session Example (90 min):
  1. Warmup: 10 min countdown
  2. Shadow Boxing: 3 rounds x 3:00 / 0:30 rest
  3. Heavy Bag: 6 rounds x 3:00 / 1:00 rest
  4. Pad Work: 4 rounds x 3:00 / 1:00 rest
  5. Conditioning: Tabata 8 x 0:20 / 0:10
  6. Cooldown: 5 min countdown
  ```
- Combo callouts using the standard punch number system:
  - 1=Jab, 2=Cross, 3=Lead Hook, 4=Rear Hook, 5=Lead Uppercut, 6=Rear Uppercut
  - Voice calls: "1-2", "1-2-3", "1-1-2", "2-3-2", with "b" modifier for body shots
- Coach mode (create and share sessions with athletes)
- Apple Watch / Wear OS companion with haptic alerts (feel the bell in noisy gyms)
- Music integration (auto-duck/resume with rounds)
- Training log with periodization support (foundation -> build -> peak -> taper phases)
- Fight camp programming: 8-12 week structured training blocks

## Target Users
1. **Solo home trainers** - Heavy bag at home, need a reliable timer
2. **Gym boxers** - Training at a boxing gym, want personal timer on phone
3. **Beginners** - Just starting boxing, need simple presets
4. **Coaches** - Want to manage round timing for their sessions
5. **Combat sport athletes** - Boxing, Muay Thai, MMA, kickboxing
