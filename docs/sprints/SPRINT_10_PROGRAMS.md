# Sprint 10: Guided Workout Programs

## Sprint Goal

Implement multi-week guided training programs that transform the app from a standalone timer into a structured training companion, with three launch programs (Boxing Fundamentals, Heavy Bag Progression, Fight Prep), full progress tracking, and seamless integration with the existing session/timer infrastructure.

---

## Research Findings

### Boxing Training Program Structure

Real boxing coaches structure weekly training around four pillars: **technique**, **speed**, **power/work rate**, and **conditioning**. A typical training week for a beginner includes 3 sessions on non-consecutive days, while intermediate fighters train 4-5 days per week. Each session combines shadow boxing (3-4 rounds), bag work (4-6 rounds), and conditioning (HIIT or circuit).

**Beginner progression follows a clear pattern:**
- Weeks 1-2: 2-3 sessions/week, 15-20 min each, 2-minute rounds with 1-minute rest, focus on form and basic combos (jab, cross)
- Weeks 3-4: 3 sessions/week, 20-25 min each, 2-minute rounds, add hooks and movement
- Weeks 5-6: 3 sessions/week, 25-30 min each, 3-minute rounds, introduce combinations and defense
- Weeks 7-8: 3-4 sessions/week, 30+ min each, 3-minute rounds, all tools at higher intensity

**Key training day themes (used by Precision Striking, Boxing Science, and real coaches):**
- Technique Day: controlled pace, clean form, fundamental combinations
- Speed Day: fast hands, rapid combos, reaction work
- Power/Work Rate Day: fight pace, sustained output, heavy bag focus
- Conditioning Day: HIIT intervals, burnout rounds, endurance

### Combat Sport Periodization

Professional fight camps use 4-phase periodization over 6-10 weeks:

1. **Foundation Phase** (Weeks 1-2): Movement prep, technical drills, base conditioning, clean fundamentals at moderate intensity
2. **Build Phase** (Weeks 3-6): Increased intensity, more complex combinations, power work, heavier conditioning
3. **Peak Phase** (Weeks 7-8): Maximum intensity, fight simulation rounds, sharpen all skills under fatigue
4. **Taper** (Final 1-2 weeks): Reduce volume by 40-60%, maintain intensity, maximize recovery for competition

For our app (which targets training, not fight preparation), we adapt this to a 4-week cycle:
- Week 1: Foundation (learn the movements, moderate intensity)
- Week 2: Build (add complexity, increase volume)
- Week 3: Push (higher intensity, longer rounds, more rounds)
- Week 4: Peak + Consolidate (hardest sessions, then validate progress)

### Fitness App Program UX Patterns

**From Nike Training Club, Peloton, FightCamp, and fitness app UX research:**

1. **Program Discovery**: Browse screen with cards showing program name, duration (weeks), difficulty, sport, and a brief description. Filter by difficulty and sport.
2. **Program Detail**: Overview screen showing week-by-week structure. Users can preview all weeks and days before joining. Shows total sessions, estimated time commitment.
3. **Active Program Widget**: Home screen card showing current program, next workout, and progress bar. One tap to start the next scheduled session.
4. **Day Completion**: Session complete screen flows directly into marking the day done. Shows progress update (e.g., "Day 5 of 20 complete").
5. **Progress Visualization**: Linear progress bar (X/Y days completed) is clearest. Calendar heatmaps add visual appeal. Streaks motivate consistency.
6. **Missed Days**: Best apps use "flexible scheduling" - programs advance based on completed sessions, not calendar dates. Users can do workouts at their own pace. No penalty for missed days; just pick up where you left off.
7. **Rest Days**: Shown in the schedule but marked as rest. No session required. Can optionally show light activity suggestions.

**Critical UX decisions:**
- Programs should NOT be locked to calendar dates. Users complete days in order at their own pace.
- One active program at a time keeps the UX simple and focused.
- "Next Workout" should be accessible from the home screen in a single tap.
- Session completion should automatically advance program progress with no extra steps.

### Content Strategy

**Minimum viable program set (3 programs covering the broadest user base):**

1. **Boxing Fundamentals** (4 weeks, Beginner) - The "learn to box" program. Perfect for home trainers with a heavy bag who are just starting. 3 sessions/week = 12 total training days.
2. **Heavy Bag Progression** (4 weeks, Intermediate) - For users who know the basics and want structured bag work that gets progressively harder. 4 sessions/week = 16 total training days.
3. **Fight Prep** (4 weeks, Advanced) - Simulates a condensed fight camp. 5 sessions/week = 20 total training days. High intensity, periodized.

**Program length sweet spot**: 4 weeks. Research shows:
- 2 weeks is too short for meaningful progression
- 8 weeks has high dropout rates
- 4 weeks is achievable, shows clear progress, and users can repeat or move to the next program

---

## Data Model

### Program

```dart
@freezed
class Program with _$Program {
  const factory Program({
    required String id,
    required String name,
    required String sport,           // 'boxing', 'muay_thai', 'mma', 'kickboxing'
    required String difficulty,      // 'beginner', 'intermediate', 'advanced'
    required String description,     // 1-2 sentence overview
    required String longDescription, // Detailed paragraph for detail screen
    required int totalWeeks,
    required int sessionsPerWeek,
    required int totalSessions,      // Total non-rest days
    required List<ProgramWeek> weeks,
    @Default(true) bool isBuiltIn,   // false for future user-created programs
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) =>
      _$ProgramFromJson(json);
}
```

### ProgramWeek

```dart
@freezed
class ProgramWeek with _$ProgramWeek {
  const factory ProgramWeek({
    required int weekNumber,         // 1-indexed
    required String focus,           // e.g. "Foundation", "Build", "Push", "Peak"
    required String description,     // Brief overview of this week's goals
    required List<ProgramDay> days,
  }) = _ProgramWeek;

  factory ProgramWeek.fromJson(Map<String, dynamic> json) =>
      _$ProgramWeekFromJson(json);
}
```

### ProgramDay

```dart
@freezed
class ProgramDay with _$ProgramDay {
  const factory ProgramDay({
    required int dayNumber,          // 1-indexed within the week (1-7)
    required String label,           // e.g. "Day 1", "Rest Day"
    required String description,     // e.g. "Technique: Jab & Cross Fundamentals"
    required bool isRestDay,
    // Inline session config — not a reference, fully self-contained
    @Default(null) SessionModel? session,
  }) = _ProgramDay;

  factory ProgramDay.fromJson(Map<String, dynamic> json) =>
      _$ProgramDayFromJson(json);
}
```

### ProgramProgress

```dart
@freezed
class ProgramProgress with _$ProgramProgress {
  const factory ProgramProgress({
    required String programId,
    required DateTime startedAt,
    required int currentWeek,            // 1-indexed, which week user is on
    required int currentDayInWeek,       // 1-indexed, which day within the week
    required Set<String> completedDays,  // Set of "week:day" keys, e.g. {"1:1", "1:2", "1:3"}
    required int currentStreak,          // Consecutive training days (resets on 2+ missed calendar days)
    required int bestStreak,
    @Default(null) DateTime? lastCompletedAt,
    @Default(false) bool isCompleted,    // True when all sessions done
  }) = _ProgramProgress;

  factory ProgramProgress.fromJson(Map<String, dynamic> json) =>
      _$ProgramProgressFromJson(json);
}
```

### Design Decision: Inline Sessions vs. Session ID References

**Decision: Inline session configs (embedded `SessionModel` in each `ProgramDay`).**

Rationale:
- Programs must be fully self-contained and reproducible. If a user edits a referenced session, it would silently change the program.
- Program sessions have specific configurations (round counts, durations, templates) that are part of the program's progressive design.
- Session IDs for presets could work, but per-round overrides and compound round templates make each program day's session unique.
- Inline sessions use program-namespaced IDs (e.g., `program_boxing_fundamentals_w1d1`) so they can be tracked in training history without colliding with preset/custom session IDs.

Each `ProgramDay.session` is a complete `SessionModel` that can be passed directly to the timer engine. The session's `id` field uses the pattern `program_{programId}_w{week}d{day}` for history tracking.

---

## Launch Programs

### Program 1: Boxing Fundamentals (4 Weeks, Beginner)

**Overview**: Learn the core punches, develop proper form, and build basic conditioning. Designed for home trainers with a heavy bag. 3 sessions per week with rest days between training days.

**Progression**:
- Week 1: 2-minute rounds, basic jabs and crosses, 4 rounds per session
- Week 2: 2-minute rounds, add hooks and uppercuts, 5 rounds per session
- Week 3: 3-minute rounds, combinations, 5 rounds per session
- Week 4: 3-minute rounds, all tools, 6 rounds per session

#### Week 1: "Foundation" — Learn Your Stance and Straight Punches

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template/Notes |
|-----|-------|-------------|--------|------|------|---------|--------|----------------|
| 1 | Day 1 | Technique: Jab & Cross Basics | 4 | 2:00 | 1:00 | 10s | 10s | Plain rounds. Focus: jab, cross, stance, guard position. |
| 2 | Rest | Recovery & Shadow Practice | - | - | - | - | - | Rest day. |
| 3 | Day 2 | Speed: Quick Hands | 4 | 2:00 | 1:00 | 10s | 10s | Plain rounds. Focus: fast jabs, double jabs, rapid 1-2. |
| 4 | Rest | Recovery | - | - | - | - | - | Rest day. |
| 5 | Day 3 | Work Rate: Sustained Output | 4 | 2:00 | 1:00 | 10s | 10s | Plain rounds. Focus: maintain consistent pace for full rounds. |
| 6 | Rest | Recovery | - | - | - | - | - | Rest day. |
| 7 | Rest | Full Rest | - | - | - | - | - | Rest day. |

**Session configs:**

```
W1D1: id=program_boxing_fundamentals_w1d1, name="Jab & Cross Basics"
  rounds=4, roundDurationSec=120, restDurationSec=60, warningTimeSec=10, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell

W1D2: id=program_boxing_fundamentals_w1d2, name="Quick Hands"
  rounds=4, roundDurationSec=120, restDurationSec=60, warningTimeSec=10, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell

W1D3: id=program_boxing_fundamentals_w1d3, name="Sustained Output"
  rounds=4, roundDurationSec=120, restDurationSec=60, warningTimeSec=10, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell
```

#### Week 2: "Build" — Add Hooks and Movement

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Notes |
|-----|-------|-------------|--------|------|------|---------|--------|-------|
| 1 | Day 1 | Technique: Lead Hook & Rear Hook | 5 | 2:00 | 1:00 | 10s | 10s | Focus: proper hook mechanics, weight transfer, guard. |
| 2 | Rest | Recovery | - | - | - | - | - | - |
| 3 | Day 2 | Speed: 3-Punch Combinations | 5 | 2:00 | 1:00 | 10s | 10s | Focus: 1-2-3, 1-1-2, fast combos. |
| 4 | Rest | Recovery | - | - | - | - | - | - |
| 5 | Day 3 | Work Rate: Punch Volume | 5 | 2:00 | 1:00 | 10s | 10s | Focus: maintain high output for full round, no rest mid-round. |
| 6 | Rest | Recovery | - | - | - | - | - | - |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W2D1: id=program_boxing_fundamentals_w2d1, name="Lead & Rear Hook"
  rounds=5, roundDurationSec=120, restDurationSec=60, warningTimeSec=10, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell

W2D2: id=program_boxing_fundamentals_w2d2, name="3-Punch Combos"
  rounds=5, roundDurationSec=120, restDurationSec=60, warningTimeSec=10, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell

W2D3: id=program_boxing_fundamentals_w2d3, name="Punch Volume"
  rounds=5, roundDurationSec=120, restDurationSec=60, warningTimeSec=10, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell
```

#### Week 3: "Push" — Longer Rounds, Add Uppercuts

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Notes |
|-----|-------|-------------|--------|------|------|---------|--------|-------|
| 1 | Day 1 | Technique: Uppercuts & Body Shots | 5 | 3:00 | 1:00 | 10s | 15s | Focus: lead uppercut, rear uppercut, body jab, body cross. |
| 2 | Rest | Recovery | - | - | - | - | - | - |
| 3 | Day 2 | Speed: 4-Punch Combinations | 5 | 3:00 | 1:00 | 10s | 15s | Focus: 1-2-3-2, 1-2-5-2, fast flowing combos. |
| 4 | Rest | Recovery | - | - | - | - | - | - |
| 5 | Day 3 | Work Rate: Fight Simulation | 5 | 3:00 | 1:00 | 10s | 15s | Focus: imagine opponent, mix offense and movement, full pace. |
| 6 | Rest | Recovery | - | - | - | - | - | - |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W3D1: id=program_boxing_fundamentals_w3d1, name="Uppercuts & Body Shots"
  rounds=5, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W3D2: id=program_boxing_fundamentals_w3d2, name="4-Punch Combos"
  rounds=5, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W3D3: id=program_boxing_fundamentals_w3d3, name="Fight Simulation"
  rounds=5, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
```

#### Week 4: "Peak" — Full Rounds, All Tools

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Notes |
|-----|-------|-------------|--------|------|------|---------|--------|-------|
| 1 | Day 1 | Technique: Defense & Counter | 6 | 3:00 | 1:00 | 10s | 15s | Focus: slip, roll, counter with 1-2, defensive mindset. |
| 2 | Rest | Recovery | - | - | - | - | - | - |
| 3 | Day 2 | Speed: Fast Combinations | 6 | 3:00 | 1:00 | 10s | 15s | Focus: rapid-fire combos, all punches, snap and return. |
| 4 | Rest | Recovery | - | - | - | - | - | - |
| 5 | Day 3 | Work Rate: 6-Round Challenge | 6 | 3:00 | 1:00 | 10s | 15s | Focus: full 6 rounds at fight pace, use everything you learned. Graduation session. |
| 6 | Rest | Recovery | - | - | - | - | - | - |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W4D1: id=program_boxing_fundamentals_w4d1, name="Defense & Counter"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W4D2: id=program_boxing_fundamentals_w4d2, name="Fast Combinations"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W4D3: id=program_boxing_fundamentals_w4d3, name="6-Round Challenge"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
```

**Program totals: 12 training sessions, 4 weeks, ~3.5 hours total training time**

---

### Program 2: Heavy Bag Progression (4 Weeks, Intermediate)

**Overview**: Structured heavy bag program that builds power, speed, and endurance through progressive overload. Uses compound round templates to vary intensity within rounds. 4 sessions per week.

**Progression**:
- Week 1: 3-minute rounds, 5 rounds, focus on clean technique and power
- Week 2: 3-minute rounds, 6 rounds, introduce compound templates (offense/defense)
- Week 3: 3-minute rounds, 7 rounds, mix compound and burnout templates
- Week 4: 3-minute rounds, 8 rounds, full intensity with all template types

#### Week 1: "Foundation" — Power Fundamentals

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template |
|-----|-------|-------------|--------|------|------|---------|--------|----------|
| 1 | Day 1 | Power: Heavy Singles | 5 | 3:00 | 1:00 | 10s | 15s | Plain. Focus: single power shots, maximum force per punch. |
| 2 | Day 2 | Speed: Rapid Combos | 5 | 3:00 | 1:00 | 10s | 15s | Plain. Focus: 3-4 punch combos at max speed. |
| 3 | Rest | Recovery | - | - | - | - | - | - |
| 4 | Day 3 | Technique: Body Work | 5 | 3:00 | 1:00 | 10s | 15s | Plain. Focus: body jabs, body hooks, uppercuts to body. |
| 5 | Day 4 | Conditioning: Volume Rounds | 5 | 3:00 | 0:45 | 10s | 15s | Plain. Focus: non-stop punching, short rest. |
| 6 | Rest | Recovery | - | - | - | - | - | - |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W1D1: id=program_heavy_bag_w1d1, name="Heavy Singles"
  rounds=5, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W1D2: id=program_heavy_bag_w1d2, name="Rapid Combos"
  rounds=5, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W1D3: id=program_heavy_bag_w1d3, name="Body Work"
  rounds=5, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W1D4: id=program_heavy_bag_w1d4, name="Volume Rounds"
  rounds=5, roundDurationSec=180, restDurationSec=45, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
```

#### Week 2: "Build" — Compound Rounds Introduced

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template |
|-----|-------|-------------|--------|------|------|---------|--------|----------|
| 1 | Day 1 | Power: Offense / Defense | 6 | 3:00 | 1:00 | 10s | 15s | Offense/Defense template (2:00 offense, 1:00 defense). |
| 2 | Day 2 | Speed: Bag + Conditioning | 6 | 3:00 | 1:00 | 10s | 15s | Bag/Conditioning template (1:00 bag, 0:30 conditioning x2). |
| 3 | Rest | Recovery | - | - | - | - | - | - |
| 4 | Day 3 | Technique: Head & Body | 6 | 3:00 | 1:00 | 10s | 15s | Plain. Alternate head and body shots each round. |
| 5 | Day 4 | Conditioning: Reduced Rest | 6 | 3:00 | 0:45 | 10s | 15s | Plain. Short rest forces sustained output. |
| 6 | Rest | Recovery | - | - | - | - | - | - |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W2D1: id=program_heavy_bag_w2d1, name="Offense / Defense"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='offense_defense', name='Offense / Defense',
    segments=[
      RoundSegment(label='Offense', durationSec=120, color='work', audioCue='bell_single'),
      RoundSegment(label='Defense', durationSec=60, color='warning', audioCue='bell_double'),
    ], repeatCount=1)

W2D2: id=program_heavy_bag_w2d2, name="Bag + Conditioning"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='bag_conditioning', name='Bag + Conditioning',
    segments=[
      RoundSegment(label='Bag Work', durationSec=60, color='work', audioCue='bell_single'),
      RoundSegment(label='Conditioning', durationSec=30, color='warning'),
    ], repeatCount=2)

W2D3: id=program_heavy_bag_w2d3, name="Head & Body"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W2D4: id=program_heavy_bag_w2d4, name="Reduced Rest"
  rounds=6, roundDurationSec=180, restDurationSec=45, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
```

#### Week 3: "Push" — Higher Volume, Burnout Rounds

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template |
|-----|-------|-------------|--------|------|------|---------|--------|----------|
| 1 | Day 1 | Power: Burnout Finishers | 7 | 3:00 | 1:00 | 10s | 15s | Burnout template (2:00 normal, 0:45 hard, 0:15 all-out). |
| 2 | Day 2 | Speed: Offense / Defense | 7 | 3:00 | 1:00 | 10s | 15s | Offense/Defense template. Focus on explosive attacks. |
| 3 | Rest | Recovery | - | - | - | - | - | - |
| 4 | Day 3 | Technique: Counter Combinations | 7 | 3:00 | 1:00 | 10s | 15s | Plain. Visualize opponent, counter after slipping/rolling. |
| 5 | Day 4 | Conditioning: Bag + Conditioning | 7 | 3:00 | 0:45 | 10s | 15s | Bag/Conditioning template with short rest. |
| 6 | Rest | Recovery | - | - | - | - | - | - |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W3D1: id=program_heavy_bag_w3d1, name="Burnout Finishers"
  rounds=7, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='burnout', name='Burnout Finisher',
    segments=[
      RoundSegment(label='Normal', durationSec=120, color='work'),
      RoundSegment(label='Hard', durationSec=45, color='warning', audioCue='bell_double'),
      RoundSegment(label='All-Out', durationSec=15, color='rest', audioCue='bell_single'),
    ], repeatCount=1)

W3D2: id=program_heavy_bag_w3d2, name="Explosive Offense / Defense"
  rounds=7, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='offense_defense', name='Offense / Defense',
    segments=[
      RoundSegment(label='Offense', durationSec=120, color='work', audioCue='bell_single'),
      RoundSegment(label='Defense', durationSec=60, color='warning', audioCue='bell_double'),
    ], repeatCount=1)

W3D3: id=program_heavy_bag_w3d3, name="Counter Combinations"
  rounds=7, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W3D4: id=program_heavy_bag_w3d4, name="Bag + Conditioning Grind"
  rounds=7, roundDurationSec=180, restDurationSec=45, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='bag_conditioning', name='Bag + Conditioning',
    segments=[
      RoundSegment(label='Bag Work', durationSec=60, color='work', audioCue='bell_single'),
      RoundSegment(label='Conditioning', durationSec=30, color='warning'),
    ], repeatCount=2)
```

#### Week 4: "Peak" — Maximum Volume, Full Intensity

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template |
|-----|-------|-------------|--------|------|------|---------|--------|----------|
| 1 | Day 1 | Power: 8-Round Burnout | 8 | 3:00 | 1:00 | 10s | 15s | Burnout template. Full 8 rounds of escalating intensity. |
| 2 | Day 2 | Speed: Station Rotation | 8 | 3:00 | 1:00 | 10s | 15s | Station Rotation template (bag, conditioning, shadow). |
| 3 | Rest | Recovery | - | - | - | - | - | - |
| 4 | Day 3 | Technique: Freestyle Flow | 8 | 3:00 | 1:00 | 10s | 15s | Plain. All tools, all combos, fight your fight. |
| 5 | Day 4 | Conditioning: Final Challenge | 8 | 3:00 | 0:30 | 10s | 15s | Burnout template + minimal rest. Graduation session. |
| 6 | Rest | Recovery | - | - | - | - | - | - |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W4D1: id=program_heavy_bag_w4d1, name="8-Round Burnout"
  rounds=8, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='burnout', name='Burnout Finisher',
    segments=[
      RoundSegment(label='Normal', durationSec=120, color='work'),
      RoundSegment(label='Hard', durationSec=45, color='warning', audioCue='bell_double'),
      RoundSegment(label='All-Out', durationSec=15, color='rest', audioCue='bell_single'),
    ], repeatCount=1)

W4D2: id=program_heavy_bag_w4d2, name="Station Rotation"
  rounds=8, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='station_rotation', name='Station Rotation',
    segments=[
      RoundSegment(label='Bag Work', durationSec=60, color='work', audioCue='bell_single'),
      RoundSegment(label='Conditioning', durationSec=45, color='warning'),
      RoundSegment(label='Shadow Box', durationSec=45, color='work'),
    ], repeatCount=1)
    Note: This template produces 2:30 rounds. roundDurationSec is overridden by template total.

W4D3: id=program_heavy_bag_w4d3, name="Freestyle Flow"
  rounds=8, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W4D4: id=program_heavy_bag_w4d4, name="Final Challenge"
  rounds=8, roundDurationSec=180, restDurationSec=30, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='burnout', name='Burnout Finisher',
    segments=[
      RoundSegment(label='Normal', durationSec=120, color='work'),
      RoundSegment(label='Hard', durationSec=45, color='warning', audioCue='bell_double'),
      RoundSegment(label='All-Out', durationSec=15, color='rest', audioCue='bell_single'),
    ], repeatCount=1)
```

**Program totals: 16 training sessions, 4 weeks, ~6.5 hours total training time**

---

### Program 3: Fight Prep (4 Weeks, Advanced)

**Overview**: Condensed fight camp simulation. Periodized intensity across 4 weeks with 5 sessions per week. Uses all timer features: compound rounds, varied rest periods, progressive round counts. Designed for experienced fighters or dedicated home trainers.

**Progression**:
- Week 1: Foundation — 6 rounds, 3:00, technique focus, moderate intensity
- Week 2: Build — 8 rounds, 3:00, increased volume and intensity, compound rounds
- Week 3: Peak — 10 rounds, 3:00, maximum volume and intensity, fight simulation
- Week 4: Taper — 6-8 rounds, 3:00, reduced volume, maintain sharpness

#### Week 1: "Foundation" — Technical Reset

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template |
|-----|-------|-------------|--------|------|------|---------|--------|----------|
| 1 | Day 1 | Shadow Boxing: Technical Rounds | 6 | 3:00 | 0:30 | 10s | 15s | Plain. Clean technique, footwork, visualization. |
| 2 | Day 2 | Heavy Bag: Power Foundations | 6 | 3:00 | 1:00 | 10s | 15s | Plain. Heavy singles and doubles, maximum force. |
| 3 | Rest | Active Recovery | - | - | - | - | - | Light stretching. |
| 4 | Day 3 | Speed: Rapid Fire | 6 | 3:00 | 1:00 | 10s | 15s | Plain. Max speed combos, snap punches. |
| 5 | Day 4 | Bag: Offense / Defense | 6 | 3:00 | 1:00 | 10s | 15s | Offense/Defense template. |
| 6 | Day 5 | Conditioning: Tabata Finisher | 8 | 0:20 | 0:10 | 0s | 10s | Tabata protocol. All-out effort. |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W1D1: id=program_fight_prep_w1d1, name="Technical Shadow Boxing"
  rounds=6, roundDurationSec=180, restDurationSec=30, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W1D2: id=program_fight_prep_w1d2, name="Power Foundations"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W1D3: id=program_fight_prep_w1d3, name="Rapid Fire"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W1D4: id=program_fight_prep_w1d4, name="Offense / Defense"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='offense_defense', name='Offense / Defense',
    segments=[
      RoundSegment(label='Offense', durationSec=120, color='work', audioCue='bell_single'),
      RoundSegment(label='Defense', durationSec=60, color='warning', audioCue='bell_double'),
    ], repeatCount=1)

W1D5: id=program_fight_prep_w1d5, name="Tabata Finisher"
  rounds=8, roundDurationSec=20, restDurationSec=10, warningTimeSec=0, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell
```

#### Week 2: "Build" — Increase Volume and Intensity

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template |
|-----|-------|-------------|--------|------|------|---------|--------|----------|
| 1 | Day 1 | Shadow Boxing: Fight Visualization | 8 | 3:00 | 0:30 | 10s | 15s | Plain. Visualize opponent, offensive and defensive movement. |
| 2 | Day 2 | Heavy Bag: Burnout Rounds | 8 | 3:00 | 1:00 | 10s | 15s | Burnout template. Build intensity within each round. |
| 3 | Rest | Active Recovery | - | - | - | - | - | - |
| 4 | Day 3 | Speed: Bag + Conditioning | 8 | 3:00 | 1:00 | 10s | 15s | Bag/Conditioning template. Speed focus on bag segments. |
| 5 | Day 4 | Power: Heavy Bag Grind | 8 | 3:00 | 0:45 | 10s | 15s | Plain. Every punch at 80%+ power, reduced rest. |
| 6 | Day 5 | Conditioning: HIIT Rounds | 10 | 0:30 | 0:30 | 5s | 10s | Conditioning intervals. Max effort. |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

**Session configs:**

```
W2D1: id=program_fight_prep_w2d1, name="Fight Visualization"
  rounds=8, roundDurationSec=180, restDurationSec=30, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W2D2: id=program_fight_prep_w2d2, name="Burnout Rounds"
  rounds=8, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='burnout', name='Burnout Finisher',
    segments=[
      RoundSegment(label='Normal', durationSec=120, color='work'),
      RoundSegment(label='Hard', durationSec=45, color='warning', audioCue='bell_double'),
      RoundSegment(label='All-Out', durationSec=15, color='rest', audioCue='bell_single'),
    ], repeatCount=1)

W2D3: id=program_fight_prep_w2d3, name="Speed Bag + Conditioning"
  rounds=8, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='bag_conditioning', name='Bag + Conditioning',
    segments=[
      RoundSegment(label='Bag Work', durationSec=60, color='work', audioCue='bell_single'),
      RoundSegment(label='Conditioning', durationSec=30, color='warning'),
    ], repeatCount=2)

W2D4: id=program_fight_prep_w2d4, name="Heavy Bag Grind"
  rounds=8, roundDurationSec=180, restDurationSec=45, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W2D5: id=program_fight_prep_w2d5, name="HIIT Rounds"
  rounds=10, roundDurationSec=30, restDurationSec=30, warningTimeSec=5, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell
```

#### Week 3: "Peak" — Maximum Volume

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template |
|-----|-------|-------------|--------|------|------|---------|--------|----------|
| 1 | Day 1 | Shadow Boxing: 10-Round War | 10 | 3:00 | 0:30 | 10s | 15s | Plain. Full fight simulation, all tools, max focus. |
| 2 | Day 2 | Heavy Bag: Burnout Marathon | 10 | 3:00 | 1:00 | 10s | 15s | Burnout template. 10 rounds of escalating intensity. |
| 3 | Rest | Active Recovery | - | - | - | - | - | - |
| 4 | Day 3 | Mixed: Station Rotation | 10 | 3:00 | 1:00 | 10s | 15s | Station Rotation template. Bag, conditioning, shadow. |
| 5 | Day 4 | Power: Offense / Defense | 10 | 3:00 | 0:45 | 10s | 15s | Offense/Defense template. Short rest, relentless offense. |
| 6 | Day 5 | Conditioning: Tabata x2 | 8 | 0:20 | 0:10 | 0s | 10s | Double Tabata. 8 rounds, rest 2:00, 8 more mentally. |
| 7 | Rest | Full Rest | - | - | - | - | - | - |

Note: Day 5 uses a single Tabata session. The "x2" intent is described to the user, who can repeat the session.

**Session configs:**

```
W3D1: id=program_fight_prep_w3d1, name="10-Round Shadow War"
  rounds=10, roundDurationSec=180, restDurationSec=30, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W3D2: id=program_fight_prep_w3d2, name="Burnout Marathon"
  rounds=10, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='burnout', name='Burnout Finisher',
    segments=[
      RoundSegment(label='Normal', durationSec=120, color='work'),
      RoundSegment(label='Hard', durationSec=45, color='warning', audioCue='bell_double'),
      RoundSegment(label='All-Out', durationSec=15, color='rest', audioCue='bell_single'),
    ], repeatCount=1)

W3D3: id=program_fight_prep_w3d3, name="Station Rotation"
  rounds=10, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='station_rotation', name='Station Rotation',
    segments=[
      RoundSegment(label='Bag Work', durationSec=60, color='work', audioCue='bell_single'),
      RoundSegment(label='Conditioning', durationSec=45, color='warning'),
      RoundSegment(label='Shadow Box', durationSec=45, color='work'),
    ], repeatCount=1)

W3D4: id=program_fight_prep_w3d4, name="Relentless Offense / Defense"
  rounds=10, roundDurationSec=180, restDurationSec=45, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='offense_defense', name='Offense / Defense',
    segments=[
      RoundSegment(label='Offense', durationSec=120, color='work', audioCue='bell_single'),
      RoundSegment(label='Defense', durationSec=60, color='warning', audioCue='bell_double'),
    ], repeatCount=1)

W3D5: id=program_fight_prep_w3d5, name="Tabata Burnout"
  rounds=8, roundDurationSec=20, restDurationSec=10, warningTimeSec=0, warmupDurationSec=10
  voiceAnnounce=true, soundPack=classic_bell
```

#### Week 4: "Taper" — Sharpen and Recover

| Day | Label | Description | Rounds | Work | Rest | Warning | Warmup | Template |
|-----|-------|-------------|--------|------|------|---------|--------|----------|
| 1 | Day 1 | Shadow Boxing: Technical Sharpening | 8 | 3:00 | 0:30 | 10s | 15s | Plain. Clean, precise, focused technique. |
| 2 | Day 2 | Heavy Bag: Offense / Defense | 8 | 3:00 | 1:00 | 10s | 15s | Offense/Defense template. Controlled intensity. |
| 3 | Rest | Recovery | - | - | - | - | - | - |
| 4 | Day 3 | Speed: Fast Combinations | 6 | 3:00 | 1:00 | 10s | 15s | Plain. Sharp, snappy combinations. Reduced volume. |
| 5 | Day 4 | Bag: Burnout Test | 6 | 3:00 | 1:00 | 10s | 15s | Burnout template. Prove your conditioning gains. |
| 6 | Day 5 | Final: 6-Round Championship | 6 | 3:00 | 1:00 | 10s | 15s | Plain. Fight simulation. Everything at fight pace. Graduation. |
| 7 | Rest | Program Complete | - | - | - | - | - | - |

**Session configs:**

```
W4D1: id=program_fight_prep_w4d1, name="Technical Sharpening"
  rounds=8, roundDurationSec=180, restDurationSec=30, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W4D2: id=program_fight_prep_w4d2, name="Offense / Defense"
  rounds=8, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='offense_defense', name='Offense / Defense',
    segments=[
      RoundSegment(label='Offense', durationSec=120, color='work', audioCue='bell_single'),
      RoundSegment(label='Defense', durationSec=60, color='warning', audioCue='bell_double'),
    ], repeatCount=1)

W4D3: id=program_fight_prep_w4d3, name="Fast Combinations"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell

W4D4: id=program_fight_prep_w4d4, name="Burnout Test"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
  roundTemplate=RoundTemplate(id='burnout', name='Burnout Finisher',
    segments=[
      RoundSegment(label='Normal', durationSec=120, color='work'),
      RoundSegment(label='Hard', durationSec=45, color='warning', audioCue='bell_double'),
      RoundSegment(label='All-Out', durationSec=15, color='rest', audioCue='bell_single'),
    ], repeatCount=1)

W4D5: id=program_fight_prep_w4d5, name="Championship Rounds"
  rounds=6, roundDurationSec=180, restDurationSec=60, warningTimeSec=10, warmupDurationSec=15
  voiceAnnounce=true, soundPack=classic_bell
```

**Program totals: 20 training sessions, 4 weeks, ~10 hours total training time**

---

## UI Design

### 1. Program Discovery / Browse Screen

**Route**: `/programs`

**Layout**:
```
┌─────────────────────────────────┐
│  ← Programs                    │
│                                 │
│  ┌─────────────────────────┐   │
│  │ BOXING FUNDAMENTALS     │   │
│  │ 4 weeks · Beginner      │   │
│  │ ● ● ● ○ ○  3x/week     │   │
│  │ Learn the core punches  │   │
│  │ and build conditioning  │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ HEAVY BAG PROGRESSION   │   │
│  │ 4 weeks · Intermediate  │   │
│  │ ● ● ● ● ○  4x/week     │   │
│  │ Build power, speed, and │   │
│  │ endurance on the bag    │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │ FIGHT PREP              │   │
│  │ 4 weeks · Advanced      │   │
│  │ ● ● ● ● ●  5x/week     │   │
│  │ Condensed fight camp    │   │
│  │ with periodized phases  │   │
│  └─────────────────────────┘   │
│                                 │
└─────────────────────────────────┘
```

- Each program card shows: name, duration, difficulty badge (color-coded), sessions per week (dot indicator), brief description
- Difficulty colors: beginner = green, intermediate = amber, advanced = red
- If a program is already active, show a "Continue" badge on the card
- If a program is completed, show a checkmark badge

### 2. Program Detail Screen

**Route**: `/programs/:programId`

**Layout**:
```
┌─────────────────────────────────┐
│  ←                              │
│                                 │
│  BOXING FUNDAMENTALS            │
│  4 weeks · 12 sessions          │
│  Beginner · ~3.5 hours total    │
│                                 │
│  Learn the core punches and     │
│  build basic conditioning...    │
│                                 │
│  ┌─ Week 1: Foundation ───────┐ │
│  │ Day 1  Jab & Cross Basics  │ │
│  │        4 rds × 2:00        │ │
│  │ Day 2  Rest                │ │
│  │ Day 3  Quick Hands         │ │
│  │        4 rds × 2:00        │ │
│  │ Day 4  Rest                │ │
│  │ Day 5  Sustained Output    │ │
│  │        4 rds × 2:00        │ │
│  │ Day 6  Rest                │ │
│  │ Day 7  Rest                │ │
│  └────────────────────────────┘ │
│                                 │
│  ▸ Week 2: Build                │
│  ▸ Week 3: Push                 │
│  ▸ Week 4: Peak                 │
│                                 │
│  ┌────────────────────────────┐ │
│  │      START PROGRAM         │ │
│  └────────────────────────────┘ │
└─────────────────────────────────┘
```

- Expandable week sections (first week expanded by default)
- Each training day shows: day label, session name, round summary (e.g., "6 rds x 3:00")
- Rest days shown in muted style with "Rest" label
- Bottom button: "Start Program" (if not started), "Continue" (if in progress), "Restart" (if completed)
- If program is active, scroll to current week and highlight next session

### 3. Active Program Widget on Home Screen

**Placement**: Below the brand header, above the preset sessions section.

**Layout**:
```
┌─────────────────────────────────┐
│  BOXING FUNDAMENTALS            │
│  Week 2 · Day 3                 │
│  ▓▓▓▓▓▓▓▓░░░░░░░░  5/12       │
│                                 │
│  Next: Quick Hands              │
│  5 rds × 2:00 · 15 min         │
│                                 │
│  ┌────────────────────────────┐ │
│  │       START WORKOUT  ►    │ │
│  └────────────────────────────┘ │
└─────────────────────────────────┘
```

- Shows program name, current position (week + day)
- Progress bar showing completed/total sessions
- Next session name with round summary and estimated duration
- Single tap "Start Workout" button launches the session
- Small "View Program" link to go to program detail screen
- If no active program, show a "Browse Programs" card that links to the programs screen

### 4. Day Completion Flow

When a program session completes in the timer:

1. Normal `_SessionCompleteView` is shown (existing completion screen)
2. Below the existing "Repeat" / "Done" buttons, add a program progress section:

```
┌─────────────────────────────────┐
│  ✓ SESSION COMPLETE             │
│                                 │
│  6-Round Challenge              │
│  6 rounds · 24:00 total        │
│                                 │
│  ── Program Progress ──         │
│  BOXING FUNDAMENTALS            │
│  Day 5 of 12 complete           │
│  ▓▓▓▓▓░░░░░░░  5/12            │
│                                 │
│  Next: Lead & Rear Hook         │
│                                 │
│  [ Repeat ]  [ Done ]           │
└─────────────────────────────────┘
```

3. Progress is automatically marked when session completes (no extra tap required)
4. If it was the final session in the program, show a "Program Complete!" celebration instead

### 5. Progress Visualization

**In Program Detail Screen (when active):**
- Each completed day shows a green checkmark
- Current day is highlighted with an accent color
- Future days are in default muted style
- Week header shows "3/3 complete" or "1/3 complete"

**Overall progress:**
- Linear progress bar: filled portion = completed sessions / total sessions
- Text: "X of Y sessions complete"
- Current streak display: "N day streak" (consecutive calendar days with a completed session)

### 6. Rest Day Display

- Rest days are shown in the weekly schedule with muted styling
- No session attached, not tappable
- Label: "Rest" with a subtle icon (moon or pause icon)
- Rest days do NOT count toward completion totals (only training sessions count)
- If user opens app on a scheduled rest day, the active program widget says "Rest Day - Next workout: [session name]"

### 7. Program Complete Screen

When the last session of a program finishes:

```
┌─────────────────────────────────┐
│                                 │
│         🏆                      │
│  PROGRAM COMPLETE               │
│                                 │
│  Boxing Fundamentals            │
│  12 sessions completed          │
│  ~3.5 hours total training      │
│  Best streak: 5 days            │
│                                 │
│  ┌────────────────────────────┐ │
│  │     BROWSE PROGRAMS        │ │
│  └────────────────────────────┘ │
│  ┌────────────────────────────┐ │
│  │     RESTART PROGRAM        │ │
│  └────────────────────────────┘ │
│  ┌────────────────────────────┐ │
│  │         DONE               │ │
│  └────────────────────────────┘ │
└─────────────────────────────────┘
```

---

## Integration Points

### 1. Programs Launch Sessions

**Flow**: Tap "Start Workout" on home widget (or tap a day in program detail) -> Load the `ProgramDay.session` (a full `SessionModel`) -> Navigate to `/timer/:sessionId` with the session loaded -> Timer runs normally.

**Implementation**:
- The `ProgramDay.session` is a complete `SessionModel` with a program-namespaced ID (e.g., `program_boxing_fundamentals_w1d1`)
- Before navigating to timer, save the session temporarily via `SessionRepository` or pass it through a Riverpod state provider (preferred — avoids polluting saved sessions)
- Use a new `activeProgramSessionProvider` that holds the `SessionModel` from the program day
- The timer screen already accepts a `sessionId` — modify `sessionByIdProvider` to also check `activeProgramSessionProvider` before falling back to repository lookup

**New provider**:
```dart
/// Holds the session loaded from a program day (not persisted to Hive).
final activeProgramSessionProvider = StateProvider<SessionModel?>((ref) => null);
```

**Modified `sessionByIdProvider`**: Check `activeProgramSessionProvider` first, then presets, then custom sessions.

### 2. Session Completion Marks Program Progress

**Flow**: When timer reaches `TimerCompleted` state -> existing code saves a `TrainingRecord` -> additionally check if the completed session ID starts with `program_` -> if so, advance `ProgramProgress`.

**Implementation**:
- In `_TimerScreenState.build()`, where `_recordSaved` is set and `historyControllerProvider.addRecord()` is called, add a call to `programProgressController.markDayCompleted(sessionId)`
- `ProgramProgressController.markDayCompleted(String sessionId)`:
  1. Parse the program ID from the session ID (e.g., `program_boxing_fundamentals_w1d1` -> `boxing_fundamentals`)
  2. Add the current day key to `completedDays`
  3. Advance `currentWeek`/`currentDayInWeek` to the next training day (skip rest days)
  4. Update streak logic
  5. If all training sessions are completed, set `isCompleted = true`
  6. Persist to Hive

### 3. Home Screen Integration

**Modify `SessionListScreen`**:
- After the brand header and divider, before the preset categories:
  - If an active program exists (progress is not null and not completed): show `ActiveProgramCard`
  - If no active program: show `BrowseProgramsCard` (a subtle card linking to `/programs`)
- Add a "Programs" icon button in the top action bar (next to history and settings icons)

### 4. History Integration

- Program sessions are saved to training history with the same `TrainingRecord` model
- The `sessionId` field contains the program-namespaced ID (e.g., `program_boxing_fundamentals_w1d1`)
- The `sessionName` field contains the human-readable name (e.g., "Jab & Cross Basics")
- No changes to `TrainingRecord` model needed
- History screen can optionally group/filter by program sessions (future enhancement, not required for MVP)

### 5. Router Integration

**New routes**:
```dart
GoRoute(
  path: '/programs',
  builder: (context, state) => const ProgramListScreen(),
),
GoRoute(
  path: '/programs/:programId',
  builder: (context, state) => ProgramDetailScreen(
    programId: state.pathParameters['programId']!,
  ),
),
```

---

## File Changes

### New Files

| File | Purpose |
|------|---------|
| `lib/features/programs/domain/program_model.dart` | `Program`, `ProgramWeek`, `ProgramDay` freezed models |
| `lib/features/programs/domain/program_progress.dart` | `ProgramProgress` freezed model |
| `lib/features/programs/data/program_repository.dart` | Hive CRUD for `ProgramProgress`, provides built-in program catalog |
| `lib/features/programs/presentation/program_controller.dart` | Riverpod providers: `allProgramsProvider`, `activeProgramProgressProvider`, `programByIdProvider`, `programProgressControllerProvider` |
| `lib/features/programs/presentation/program_list_screen.dart` | Program browse/discovery screen |
| `lib/features/programs/presentation/program_detail_screen.dart` | Program detail with week/day breakdown |
| `lib/features/programs/presentation/widgets/active_program_card.dart` | Home screen widget for active program |
| `lib/features/programs/presentation/widgets/browse_programs_card.dart` | Home screen widget when no active program |
| `lib/features/programs/presentation/widgets/program_card.dart` | Program card for browse screen |
| `lib/features/programs/presentation/widgets/program_day_tile.dart` | Day row in program detail |
| `lib/features/programs/presentation/widgets/program_week_section.dart` | Expandable week section in program detail |
| `lib/features/programs/presentation/widgets/program_complete_view.dart` | Program completion celebration screen |
| `lib/features/programs/presentation/widgets/program_progress_bar.dart` | Linear progress bar widget |
| `lib/core/constants/preset_programs.dart` | All 3 built-in program definitions with inline session configs |
| `lib/features/programs/domain/program_model.freezed.dart` | Generated |
| `lib/features/programs/domain/program_model.g.dart` | Generated |
| `lib/features/programs/domain/program_progress.freezed.dart` | Generated |
| `lib/features/programs/domain/program_progress.g.dart` | Generated |

### Modified Files

| File | Change |
|------|--------|
| `lib/main.dart` | Open `programsBox` Hive box, add `programsBoxProvider` override |
| `lib/core/constants/app_constants.dart` | Add `programsBoxName = 'programs'` |
| `lib/app/router.dart` | Add `/programs` and `/programs/:programId` routes |
| `lib/features/sessions/presentation/session_list_screen.dart` | Add `ActiveProgramCard` or `BrowseProgramsCard` below brand header, add programs icon button |
| `lib/features/sessions/presentation/sessions_controller.dart` | Modify `sessionByIdProvider` to check `activeProgramSessionProvider` |
| `lib/features/timer/presentation/timer_screen.dart` | After session complete record save, call `programProgressController.markDayCompleted()` if session ID starts with `program_`; add program progress section to `_SessionCompleteView` |
| `lib/features/timer/presentation/timer_controller.dart` | Add `activeProgramSessionProvider` |
| `lib/l10n/app_en.arb` | Add program-related strings |
| `lib/l10n/app_es.arb` | Add program-related strings (Spanish) |
| `lib/l10n/app_pt.arb` | Add program-related strings (Portuguese) |

### Localization Strings to Add

```
programsTitle: "Programs"
programsDescription: "Multi-week guided training plans"
programWeekLabel: "Week {weekNumber}"
programDayLabel: "Day {dayNumber}"
programRestDay: "Rest"
programSessionsPerWeek: "{count}x/week"
programWeeksCount: "{count} weeks"
programTotalSessions: "{count} sessions"
programDifficulty_beginner: "Beginner"
programDifficulty_intermediate: "Intermediate"
programDifficulty_advanced: "Advanced"
programStartButton: "Start Program"
programContinueButton: "Continue"
programRestartButton: "Restart Program"
programBrowseButton: "Browse Programs"
programNextWorkout: "Next: {sessionName}"
programProgressLabel: "{completed} of {total} complete"
programDayComplete: "Day {day} of {total} complete"
programCompleteTitle: "Program Complete!"
programCompleteMessage: "{count} sessions completed"
programActiveProgramLabel: "Active Program"
programStartWorkout: "Start Workout"
programViewDetails: "View Program"
programRestDayMessage: "Rest Day"
programRestDayNextWorkout: "Next workout: {sessionName}"
programStreakLabel: "{count} day streak"
programWeekFocus: "Focus: {focus}"
programEstimatedTime: "~{time} total"
```

---

## Dependencies

No new packages required. The feature uses only existing dependencies:
- `freezed_annotation` + `freezed` for models
- `json_annotation` + `json_serializable` for JSON serialization
- `hive` + `hive_flutter` for persistence
- `flutter_riverpod` for state management
- `go_router` for navigation
- `uuid` for ID generation

---

## Acceptance Criteria

### Data Model & Storage
- [ ] `Program`, `ProgramWeek`, `ProgramDay`, `ProgramProgress` models generate correctly with `dart run build_runner build`
- [ ] `ProgramProgress` persists to Hive and survives app restart
- [ ] All 3 built-in programs load correctly from `PresetPrograms`
- [ ] Program session IDs follow the `program_{programId}_w{week}d{day}` convention
- [ ] Each `ProgramDay.session` is a valid `SessionModel` that the timer engine accepts

### Program Browse & Detail
- [ ] Programs screen (`/programs`) displays all 3 programs with name, difficulty, duration, description
- [ ] Program detail screen shows all weeks and days with session summaries
- [ ] Week sections are expandable/collapsible
- [ ] Rest days are displayed in muted style and are not tappable
- [ ] Difficulty badges are color-coded (green/amber/red)

### Active Program Flow
- [ ] Starting a program sets `ProgramProgress` with correct initial state
- [ ] Active program card appears on home screen with progress bar and next session
- [ ] Tapping "Start Workout" on home card navigates to timer with correct session
- [ ] Tapping a training day in program detail navigates to timer with that day's session
- [ ] Only one program can be active at a time (starting a new one prompts to abandon current)

### Session Completion & Progress
- [ ] Completing a program session automatically marks the day as done in `ProgramProgress`
- [ ] Progress bar updates after each completed session
- [ ] `currentWeek` and `currentDayInWeek` advance to the next training day (skipping rest days)
- [ ] Streak counter increments on consecutive training days
- [ ] Streak resets after 2+ calendar days without a completed session
- [ ] Completed sessions appear in training history with program session names
- [ ] Timer completion screen shows program progress section below existing UI

### Program Completion
- [ ] When final session completes, `isCompleted` is set to true
- [ ] Program complete celebration screen shows with stats (sessions, time, streak)
- [ ] Completed program shows checkmark badge in browse screen
- [ ] User can restart a completed program (resets progress)

### Missed Days & Flexibility
- [ ] Programs do not enforce calendar dates — user completes days at their own pace
- [ ] Skipping a day does not block access to future days (user follows sequential order)
- [ ] If app is opened on a "rest day" position, widget shows "Rest Day" with next session info

### Home Screen Integration
- [ ] Active program card shows below brand header when a program is in progress
- [ ] "Browse Programs" card shows when no program is active
- [ ] Programs icon button in top action bar navigates to `/programs`

### Edge Cases
- [ ] Starting a program session, quitting mid-session (Save & Exit), does NOT mark the day complete
- [ ] Partially completed sessions (ended early via "End" button) do NOT mark the day complete
- [ ] Only fully completed sessions (`completedFully: true`) advance program progress
- [ ] Repeating a session (via "Repeat" button) does not double-count progress
- [ ] `flutter analyze` passes with zero errors
- [ ] `flutter test` runs successfully
- [ ] All screens handle dark theme correctly
- [ ] All text is localized (en, es, pt)

---

## Implementation Notes

### Streak Calculation Logic

```
On session completion:
  if lastCompletedAt is null OR lastCompletedAt is yesterday OR lastCompletedAt is today:
    currentStreak += 1 (only if not already counted today)
    bestStreak = max(bestStreak, currentStreak)
  else if lastCompletedAt is more than 1 day ago:
    currentStreak = 1  // Reset streak, start fresh
  lastCompletedAt = now
```

"Yesterday" and "today" comparisons use date-only (ignore time), so completing a session at 11pm and another at 6am the next day counts as consecutive.

### Next Day Advancement Logic

```
On markDayCompleted:
  Add "week:day" to completedDays set
  Find next training day:
    Start from current position
    Advance to next day in the week
    If day is rest day, skip
    If end of week, move to next week day 1
    If end of all weeks, set isCompleted = true
  Update currentWeek and currentDayInWeek
```

### Session ID Parsing

Program session IDs follow a strict convention for easy parsing:
- Format: `program_{programSlug}_w{weekNum}d{dayNum}`
- Example: `program_boxing_fundamentals_w2d3`
- Parse: split on `_w` and `d` to extract program slug, week number, and day number
- The program slug maps to the program ID in the catalog

### Program Data Sizing

All 3 programs together contain:
- 48 total session configs (12 + 16 + 20)
- Each session is ~200 bytes as JSON
- Total program data: ~10KB — trivially small, fine as const Dart objects
- Progress data per active program: ~500 bytes — stored in Hive

### Testing Strategy

- **Unit tests**: Program model creation, progress advancement, streak calculation, next-day logic, session ID parsing
- **Widget tests**: Program card rendering, progress bar accuracy, active program card, program detail screen
- **Integration tests**: Full flow: browse -> start program -> complete session -> verify progress -> complete program
