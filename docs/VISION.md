# Boxing - Project Vision

## V1: What We Built

A **boxing-first** training timer that nails the fundamentals. Every top pain point in the market — timer dying in background, terrible audio, feature bloat, aggressive monetization, unusable with gloves — is solved.

### V1 Achievement Summary

| Pain Point | Status |
|------------|--------|
| Timer dies in background | Solved — foreground service + silent keep-alive + checkpoint recovery |
| Terrible audio | Solved — 3 sound packs, audio ducking over Spotify, volume override |
| Feature bloat | Solved — boxing-specific, no generic HIIT/yoga noise |
| Aggressive monetization | Solved — zero ads, fair pricing model |
| Can't use with gloves | Solved — 80dp+ touch targets, tap-to-pause mode |
| No per-round customization | Solved — per-round overrides + compound round templates |
| Battery/data drain | Solved — efficient lifecycle, minimal permissions |
| Custom timer bugs | Solved — DateTime-based engine, crash recovery via checkpoints |

### V1 Feature Set (Complete)

- Reliable timer engine (DateTime-based, drift-free, background-safe)
- Background execution with foreground service + silent audio keep-alive
- Audio ducking (bells play over Spotify without stopping music)
- 3 sound packs (Classic Bell, Digital Buzzer, Minimal Beep)
- Voice round announcements (TTS in EN/ES/PT)
- Compound rounds with segments (sub-round structure)
- Session editor with full configuration
- 20 built-in preset sessions
- Per-round duration overrides
- Checkpoint/pause recovery (survives crashes)
- Training history
- Glove-friendly controls (80dp+, tap-to-pause)
- Settings (theme, language, audio, defaults)
- i18n (English, Spanish, Portuguese)

### V1 Competitive Position

We are the **only app** combining: reliable background timing + audio ducking + compound rounds + voice TTS + checkpoint recovery + glove-friendly controls. No competitor has this full stack.

---

## The Problem With V1 (and Every Timer App)

V1 is a great timer. But a timer is a commodity.

Our presets prove this: "Muay Thai" is just 5 rounds x 3:00 with 2:00 rest. "MMA" is 3 rounds x 5:00. There's nothing sport-specific about them — they're labels on number combinations.

**Nobody will pay for a configurable countdown clock**, no matter how reliable.

The market is splitting into two categories:
1. **Dumb timers** — free, simple, commodity (where most apps live)
2. **Smart coaches** — guided workouts, AI combos, training programs (Shadow Boxing App, Heavy Bag Pro, FightCamp)

There's a gap in the middle: a **reliable timer that also trains you**. That's where we go next.

---

## V2 Vision: Smart Training Companion

> "The timer is free. The brain is paid."

Boxing becomes a training companion that knows your sport, calls your combos, structures your progression, and makes solo training feel coached.

### Core Philosophy (Updated)

- **Reliability is table stakes** — the timer works perfectly. That's the baseline, not the product.
- **Sport-specific intelligence** — each sport gets real training structure, not just different round durations.
- **The app replaces the coach you don't have** — combo callouts, drill structure, progressive difficulty for solo trainers.
- **Simple to start, deep to master** — 2 taps to start a preset. Weeks of progression if you want it.
- **Zero ads, ever** — the free tier is genuinely useful. Paid tier is genuinely worth it.

### V2 Focus Areas

#### 1. Combo Callouts

The #1 feature opportunity identified across all research. Solo trainers at home have nobody calling combos. This turns a timer into a training partner.

**Boxing Punch System:**
- 1=Jab, 2=Cross, 3=Lead Hook, 4=Rear Hook, 5=Lead Uppercut, 6=Rear Uppercut
- "b" modifier = body shot (1b = jab to body)
- Common combos: 1-2, 1-2-3, 1-1-2, 2-3-2, 1-2-3-2, 1-2-5-2

**How it works:**
- During work rounds, voice calls out combos at configurable intervals
- Difficulty levels: Beginner (basic 2-punch), Intermediate (3-4 punch), Advanced (5-6 punch + body)
- Random or structured combo sequences
- Visual display of current combo (for learning the number system)
- Sport-specific combo libraries:
  - Boxing: standard punch combos
  - Muay Thai: punch-kick combos (1-2-roundhouse, teep-cross, etc.)
  - MMA: striking combos with level changes
  - Kickboxing: hands + feet combos

**Design questions to resolve:**
- TTS vs. pre-recorded voice (quality vs. flexibility)
- Combo frequency: every 5s? 8s? 10s? Configurable?
- Should combos respect round phase? (simpler at start, harder near end)
- Defense callouts too? ("slip", "roll", "block")
- Footwork cues? ("pivot", "angle off", "cut the ring")

#### 2. Sport-Specific Training Structure

Each sport has fundamentally different training patterns. Real presets should capture these, not just adjust round timers.

**What makes each sport different (not just round times):**

| Sport | Training Differentiator | Beyond Timer |
|-------|------------------------|--------------|
| **Boxing** | Combo work, defense drills, footwork patterns | Punch number callouts, defensive cues |
| **Muay Thai** | Clinch rounds, kick-only rounds, teep drills, elbow work | Kick combo callouts, clinch timer segments |
| **MMA** | Striking + grappling split, takedown drills, cage work, position transitions | Mixed drill segments, position callouts |
| **BJJ** | Positional drilling (guard/mount/back), competition formats (IBJJF/ADCC/sub-only), technique-specific timers | Position announcements, drill rotation cues |
| **Kickboxing** | Hands + feet combos, movement drills | Kick-focused combo callouts |
| **Wrestling** | Period structure, top/bottom drills, shot drills, chain wrestling | Position rotation cues, intensity callouts |

**How sport-specific presets should work:**

Instead of just "Muay Thai: 5 rounds x 3:00", a real Muay Thai preset could be:

```
Muay Thai Pad Work (Sport-Specific):
├── Round 1: Hands Only (boxing combos)
├── Round 2: Kicks Only (kick callouts: "roundhouse", "teep", "switch kick")
├── Round 3: Hands + Kicks (mixed combos)
├── Round 4: Clinch Work (clinch entry cues)
├── Round 5: Free Round (all techniques)
├── Rest: 2:00 between rounds
└── Each round: technique callouts specific to the focus
```

A BJJ drilling preset could be:

```
BJJ Positional Drilling:
├── Round 1: Guard Retention (position cue: "re-guard")
├── Round 2: Guard Passing (position cue: "pass")
├── Round 3: Mount Escapes (position cue: "escape")
├── Round 4: Back Takes (position cue: "take the back")
├── Round 5: Submissions (position cue: "submit")
├── Round 6: Live Rolling (no cues)
├── Rest: 30s between positions
└── Each round: position-specific voice cues
```

**Key insight: the PRESET becomes the training program, not just the timer config.**

The data model needs to evolve — a session isn't just rounds/time/rest. It includes:
- What type of training each round represents
- What audio cues play during each round (combos, positions, techniques)
- What skill level the session targets
- What sport and sub-discipline it belongs to

#### 3. Guided Workout Programs

Progressive training that builds over weeks, not just single sessions.

**Concept:**

```
Program: "Boxing Fundamentals" (4 weeks)
├── Week 1: Stance & Jab
│   ├── Day 1: Shadow Boxing (basic 1-2 combos, 4 rounds)
│   ├── Day 2: Heavy Bag (1-2, 1-1-2, focus on form, 6 rounds)
│   └── Day 3: Speed Work (quick 1-2s, short rounds, conditioning)
├── Week 2: Adding the Hook
│   ├── Day 1: Shadow Boxing (1-2-3 combos introduced)
│   ├── Day 2: Heavy Bag (1-2-3, 2-3-2 combos, 6 rounds)
│   └── Day 3: Defense + Offense (slip-counter combos)
├── Week 3: Uppercuts & Combinations
│   └── ...progresses in difficulty
└── Week 4: Putting It Together
    └── ...full combo library, longer rounds, fight simulation
```

**What this gives users:**
- Direction — "what should I train today?"
- Progression — each week builds on the last
- Variety — different focuses prevent staleness
- Accountability — streak tracking, program completion

**Design questions:**
- How much is free vs. paid?
- Do we create content ourselves or build tools for others to create?
- How many programs at launch?
- Per-sport programs? (Boxing fundamentals, Muay Thai basics, BJJ drilling)

---

## Data Model Evolution

### Current: Session = Timer Configuration
```
Session: rounds, duration, rest, warning, warmup, sound, auto-advance
```

### V2: Session = Training Experience
```
Session: timer config + training context
├── Timer: rounds, duration, rest, warning
├── Sport: boxing | muay_thai | mma | bjj | kickboxing | wrestling | general
├── Training Focus: combos | defense | footwork | positional | conditioning | free
├── Combo Set: reference to which combos can be called
├── Combo Difficulty: beginner | intermediate | advanced
├── Combo Frequency: seconds between callouts (or "off")
├── Round Instructions: per-round focus/cue configuration
└── Program Reference: (optional) which program/week/day this belongs to
```

---

## Preset Architecture (V2)

### Problem: Flat List of Number Combos

Current presets are a flat list of 20 sessions that only differ in rounds/duration/rest. Extending to other sports by just adding "BJJ: 6 x 5:00" is meaningless.

### Solution: Categorized, Sport-Aware Presets

```
Presets/
├── Boxing/
│   ├── Competition/
│   │   ├── Pro Boxing (Men) — 12x3:00, fight sim
│   │   ├── Pro Boxing (Women) — 10x2:00, fight sim
│   │   ├── Amateur Boxing — 3x3:00, fight sim
│   │   └── Amateur Women — 3x2:00, fight sim
│   ├── Training/
│   │   ├── Shadow Boxing — 5x3:00, basic combos
│   │   ├── Heavy Bag — 8x3:00, power combos
│   │   ├── Speed Bag — 6x2:00, rhythm focus
│   │   ├── Pad Work — 4x3:00, coach combos
│   │   └── Sparring — 6x3:00, no callouts
│   ├── Drills/
│   │   ├── Combo Drill (Beginner) — 6x2:00, basic 2-punch combos called
│   │   ├── Combo Drill (Advanced) — 6x3:00, complex combos called
│   │   ├── Defense Drill — 6x2:00, slip/roll/block callouts
│   │   └── Footwork Drill — 6x2:00, movement cues
│   └── Conditioning/
│       ├── Conditioning — 10x0:30 HIIT
│       ├── Tabata — 8x0:20
│       └── EMOM — 10x1:00
│
├── Muay Thai/
│   ├── Competition/
│   │   └── Muay Thai Fight — 5x3:00, 2:00 rest
│   ├── Training/
│   │   ├── Pad Work — kick+punch combos, 5x3:00
│   │   ├── Clinch Work — clinch-specific segments, 5x3:00
│   │   ├── Kick Rounds — kick-only callouts, 5x3:00
│   │   └── Shadow Work — mixed technique, 5x3:00
│   └── Drills/
│       ├── Teep Drill — teep-focused callouts
│       ├── Kick Combos — roundhouse combinations
│       └── Elbow/Knee — close-range drills
│
├── MMA/
│   ├── Competition/
│   │   ├── UFC Fight — 3x5:00 (or 5x5:00 title)
│   │   └── Amateur MMA — 3x3:00
│   ├── Training/
│   │   ├── Striking Rounds — boxing+kicks, 5x5:00
│   │   ├── Grappling Rounds — position transitions, 5x5:00
│   │   └── Mixed Training — alternating strike/grapple segments
│   └── Drills/
│       ├── Takedown Drill — shot/sprawl cues
│       └── Ground & Pound — position segments
│
├── BJJ/
│   ├── Competition/
│   │   ├── IBJJF Match — point-based, regulation times
│   │   ├── Sub-Only — submission-only format
│   │   └── ADCC — ADCC ruleset timers
│   ├── Training/
│   │   ├── Positional Drilling — rotating positions per round
│   │   ├── Live Rolling — standard rounds, 6x5:00
│   │   └── Shark Tank — one person vs. rotating partners
│   └── Drills/
│       ├── Guard Retention — guard-specific timer
│       ├── Passing Drill — pass-focused rounds
│       └── Submission Chains — sub attempt intervals
│
├── Kickboxing/
│   ├── Competition/
│   │   └── K-1 Rules — 3x3:00
│   ├── Training/
│   │   ├── Combo Work — hands+feet callouts
│   │   └── Bag Rounds — power kick focus
│   └── Drills/
│       └── Kick Combos — specific kick combinations
│
└── Wrestling/
    ├── Competition/
    │   ├── Folkstyle — periods with riding time
    │   └── Freestyle/Greco — 2x3:00
    ├── Training/
    │   ├── Live Wrestling — standard rounds
    │   └── Situational — top/bottom/neutral rotation
    └── Drills/
        ├── Shot Drill — shot attempt intervals
        └── Chain Wrestling — technique flow timer
```

This structure is hierarchical: Sport → Context → Session. Each session carries sport-specific intelligence (combo sets, position cues, technique callouts) — not just different numbers.

---

## Monetization Strategy (Updated)

Based on V2 research (see `docs/research/06_BUSINESS_MODELS.md`):

### Free Tier (with ads)
- Full timer with all core features
- All presets (every sport)
- Custom sessions
- Training history
- Non-intrusive ads (between sessions, never during active timer)

### Paid Tier — Remove Ads (base)
- Pay to remove all ads
- This is the entry-level purchase that funds development
- Pricing TBD ($3.99-$4.99 one-time or low subscription)

### Future Premium Tiers (added later as features mature)
- **Combo callouts** — voice-called combos during rounds
- **Sport-specific drill presets** — with technique cues and structured training
- **Guided workout programs** — progressive multi-week training plans
- **Advanced features** — TBD based on what users actually value

**Key principle:** Start simple with ads + pay to remove. Layer premium features on top as they're built and validated. Don't over-engineer monetization before there are users.

---

## Feature Roadmap (V2)

### Phase 2A: Combo Callouts (Core Feature)
- Combo data model and library
- Boxing combo set (beginner/intermediate/advanced)
- Voice engine integration (TTS or pre-recorded)
- Combo frequency and difficulty settings
- Visual combo display on timer screen
- Combo-enabled preset sessions

### Phase 2B: Sport-Specific Expansion
- Restructure preset system (Sport → Context → Session)
- Muay Thai combo/technique library
- MMA training structure (strike/grapple segments)
- BJJ positional drilling framework
- Kickboxing and wrestling basics
- Sport-specific voice cue libraries

### Phase 2C: Guided Programs
- Program data model (program → weeks → days → sessions)
- 2-3 launch programs (Boxing Fundamentals, Heavy Bag Progression, Fight Prep)
- Progress tracking (streak, completion %)
- Program discovery/browse screen

### Phase 3: Coach Mode (Deferred — requires dedicated research)
- Create sessions with custom combo sequences
- Share sessions with athletes
- Live session control
- Athlete progress tracking
- Class/group timer mode

### Future Considerations (from research)
- Apple Watch companion with haptic bell
- iOS Live Activities / Dynamic Island timer
- BLE heart rate monitor integration
- Gym display mode (landscape, large timer for TV/casting)
- AI-adaptive difficulty (adjust combos based on training history)

---

## Target Users (Updated)

| User | V1 Value | V2 Value |
|------|----------|----------|
| **Solo home trainers** | Reliable timer for bag work | Combo callouts replace the coach they don't have |
| **Gym boxers** | Personal timer on phone | Sport-specific drill sessions |
| **Beginners** | Simple presets to start | Guided programs that teach progression |
| **Combat sport athletes** | Multi-sport timer | Real sport-specific training (not just different round times) |
| **Coaches** | (minimal) | Phase 3: create and share structured sessions |

## Technical Priorities (V2)

### Must Work Perfectly
1. Combo audio timing — callouts must not overlap with bells or each other
2. TTS quality — combos must be clear and fast (evaluate ElevenLabs vs flutter_tts)
3. Combo data model — extensible to any sport's technique system
4. Backward compatibility — V1 sessions continue to work exactly as before

### New Technical Considerations
- Combo library storage and management
- Voice asset pipeline (TTS generation, caching, pre-loading)
- Program state persistence (progress, streaks, history)
- Sport-specific data models (combo sets, technique libraries, position systems)

---

## Research Foundation

All strategic decisions are backed by deep research in `docs/research/`:

| Document | Lines | Key Finding |
|----------|-------|-------------|
| `01_VALUE_ANALYSIS.md` | 692 | Reliability > Simplicity > Cost Fairness (we nail top 3) |
| `02_COMPETITOR_DEEP_DIVE.md` | 957 | Nobody combines reliable timer + training intelligence |
| `03_USER_PAIN_POINTS.md` | 913 | Top 8 pain points solved; combo callouts is #1 unsolved |
| `04_TECHNOLOGY_SCAN.md` | 1,184 | Combo callouts = production-ready, high wow, medium effort |
| `05_MARKET_EXPANSION.md` | 1,109 | BJJ and coaches = highest-value expansion segments |
| `06_BUSINESS_MODELS.md` | 1,029 | Free timer + paid training content is the viable model |
| `07_OPPORTUNITY_MATRIX.md` | 675 | "Smart Training Companion" is the recommended strategic path |
