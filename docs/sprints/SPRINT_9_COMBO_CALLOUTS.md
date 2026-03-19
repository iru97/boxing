# Sprint 9: Combo Callouts

## Sprint Goal

Add voice combo callouts that act as a virtual boxing coach, calling out punch combinations, defense cues, and footwork commands during work phases -- the #1 feature gap for solo trainers who have nobody calling combos.

---

## Research Findings

### Competitor Analysis

#### Precision Boxing Coach (iOS/Android, $4.99)
- The market leader for combo callouts. Simulates a boxing coach calling out techniques.
- **4 difficulty modes** controlling combo length:
  - Amateur: 2-4 techniques per combo
  - Pro: 2-6 techniques per combo
  - Titleist: 3-7 techniques per combo
  - P4P: 4-8 techniques per combo
- **3 intensity levels** controlling pace between callouts:
  - Classic (standard), Pressure (faster), Hurricane (fastest)
- **Progressive building**: combos build on themselves (e.g., "1-2", then "1-2-slip right", then "1-2-slip right-2"), then the full combo repeats once before moving on.
- Calls out punches, slips, ducks, defense, body shots using the number system.
- Includes southpaw mode and counter-punching mode.

#### Shadow Boxing App (iOS/Android, Free, 4.9 stars)
- Calls out actions during rounds: punches, defenses, movements.
- **11 speed levels** to control combo delivery pace.
- Users can add, delete, and edit combinations.
- 200K+ downloads. Emphasis on simplicity -- "keep your eyes on the bag."

#### Callout - The Boxing App (iOS)
- Users set a **frequency rating** per combo to control how often each appears.
- Create custom combinations.
- Timer integrated with punch callouts.

#### Heavy Bag Pro (iOS, Subscription)
- Calls out combos with 3D punch animations.
- Voice + visual combo display.

#### Shadow Boxing Workout Partner (Web/Mobile)
- Simple random combo generator.
- 11 speed levels matching intensity.

### Key Design Insights from Competitors
1. **Number system is universal** -- all apps use 1-6 for punches.
2. **Speed/intensity and difficulty are separate axes** -- difficulty controls combo complexity, intensity controls frequency.
3. **Progressive building** (Precision Boxing Coach's approach) is highly valued but adds complexity. We will start with random selection and add progressive building as a future enhancement.
4. **Custom combos** are expected -- users want to train specific sequences.
5. **Defense mixed into combos** is what separates good apps from great ones (e.g., "1-2-slip-2" not just "1-2-3-2").
6. **Body shots** use a modifier: "1 body", "3 body" or the "b" suffix.

### Combo Callout Timing Research

Based on competitor analysis and training methodology:

| Intensity | Interval Between Combos | Use Case |
|-----------|------------------------|----------|
| Relaxed | 8-12 seconds | Beginners, technique focus |
| Moderate | 5-8 seconds | Standard training |
| Intense | 3-5 seconds | Advanced, cardio push |
| Hurricane | 2-3 seconds | Max intensity burnout |

The interval should include execution time (the combo itself takes 1-3 seconds to call out, plus time for the fighter to execute). A 3-punch combo at moderate intensity: ~1.5s callout + ~2s execution + ~4s pause = ~7.5s total cycle.

### TTS Capabilities & Limitations

#### flutter_tts Performance
- **Speech rate range**: 0.0 to 2.0, where 1.0 is normal speed.
- Current app uses 0.5 rate for round announcements -- too slow for combos.
- **Combo callouts need rate 0.7-1.0** for clarity at speed.
- `flutter_tts` works **offline** on most devices once language packs are installed.
- **Latency**: ~50-200ms on most devices for short phrases. Acceptable for our use case since combos are called ahead of execution, not reactively.
- `synthesizeToFile()` exists but has platform inconsistencies. Not recommended as primary approach.

#### TTS vs Pre-Recorded Audio Decision

| Factor | Live TTS | Pre-Recorded |
|--------|----------|--------------|
| Combo flexibility | Unlimited combos | Fixed set only |
| Custom combos | Supported automatically | Requires recording |
| Multi-language | Built-in (en/es/pt) | Must record 3x |
| Audio quality | Device-dependent | Consistent |
| Latency | ~100ms | ~20ms |
| Storage | Zero | ~50KB per phrase |
| Maintenance | Zero | Must re-record for changes |

**Decision: Use live TTS** (via existing `flutter_tts`/`VoiceService`). The flexibility advantages are decisive -- unlimited combos, automatic multi-language support, custom combo support, and zero storage overhead. The ~100ms latency is acceptable because combos are anticipatory (called before execution), not reactive.

#### Audio Channel Management
- Combo callouts use TTS (speech channel), which is separate from bell sounds (just_audio).
- TTS and just_audio can coexist on both Android and iOS.
- **Priority**: Bell sounds > TTS callouts. If a bell fires during a combo callout, `_tts.stop()` first, play bell, then resume combo flow.
- **No overlap with phase announcements**: combo callouts pause during round start/end transitions. First combo fires 2-3 seconds after the round-start bell and "Round N" announcement.

---

## Combo Library Design

### Punch Number System (Universal Standard)

```
1  = Jab                    1b = Jab to body
2  = Cross (straight right) 2b = Cross to body
3  = Lead Hook              3b = Lead Hook to body
4  = Rear Hook              4b = Rear Hook to body (overhand right)
5  = Lead Uppercut          5b = Lead Uppercut (always body by nature)
6  = Rear Uppercut          6b = Rear Uppercut (always body by nature)
```

Note: For southpaw fighters, all "lead" and "rear" are reversed. The numbers stay the same -- 1 is always the lead hand jab regardless of stance. The app does not need to handle stance differences; the user knows their stance.

### Defense Callouts

| Key | Callout | Description |
|-----|---------|-------------|
| `slip_l` | "Slip left" | Move head left to evade |
| `slip_r` | "Slip right" | Move head right to evade |
| `roll` | "Roll" | Roll under a hook |
| `block` | "Block" | High guard block |
| `parry` | "Parry" | Deflect incoming jab/cross |
| `pull` | "Pull back" | Pull back to avoid |
| `catch` | "Catch" | Catch a hook with glove |
| `duck` | "Duck" | Duck under a punch |
| `cover` | "Cover" | Turtle/cover up |
| `shoulder_roll` | "Shoulder roll" | Philly shell defense |

### Footwork Callouts

| Key | Callout | Description |
|-----|---------|-------------|
| `pivot_l` | "Pivot left" | Pivot on lead foot |
| `pivot_r` | "Pivot right" | Pivot on rear foot |
| `angle_l` | "Angle left" | Step to an angle |
| `angle_r` | "Angle right" | Step to an angle |
| `step_back` | "Step back" | Step back out of range |
| `cut_off` | "Cut off" | Cut off the ring |
| `circle_l` | "Circle left" | Circle to the left |
| `circle_r` | "Circle right" | Circle to the right |
| `in_out` | "In and out" | Step in, strike, step out |
| `lateral` | "Lateral" | Side-to-side movement |

### Boxing Combo Library

#### Beginner (2-3 techniques, fundamental combinations)

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| B1 | 1 | "Jab" | 1 |
| B2 | 1-1 | "Jab, jab" | 1-1 |
| B3 | 1-2 | "Jab, cross" | 1-2 |
| B4 | 2-3 | "Cross, hook" | 2-3 |
| B5 | 1-1-2 | "Jab, jab, cross" | 1-1-2 |
| B6 | 1-2-3 | "Jab, cross, hook" | 1-2-3 |
| B7 | 1-2-1 | "Jab, cross, jab" | 1-2-1 |
| B8 | 1-4 | "Jab, rear hook" | 1-4 |
| B9 | 5-2 | "Uppercut, cross" | 5-2 |
| B10 | 6-3 | "Rear uppercut, hook" | 6-3 |
| B11 | 1-2b | "Jab, cross body" | 1-2b |
| B12 | 1-3 | "Jab, hook" | 1-3 |
| B13 | 1-6 | "Jab, rear uppercut" | 1-6 |
| B14 | 2-1 | "Cross, jab" | 2-1 |
| B15 | 1b-2 | "Jab body, cross" | 1b-2 |
| B16 | 3-2 | "Hook, cross" | 3-2 |

#### Intermediate (3-4 techniques, adding defense and body shots)

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| I1 | 1-2-3-2 | "Jab, cross, hook, cross" | 1-2-3-2 |
| I2 | 1-1-2-3 | "Jab, jab, cross, hook" | 1-1-2-3 |
| I3 | 2-3-2 | "Cross, hook, cross" | 2-3-2 |
| I4 | 1-2-5-2 | "Jab, cross, uppercut, cross" | 1-2-5-2 |
| I5 | 1-6-3-2 | "Jab, rear uppercut, hook, cross" | 1-6-3-2 |
| I6 | 1-2-3b | "Jab, cross, hook body" | 1-2-3b |
| I7 | 3-2-3 | "Hook, cross, hook" | 3-2-3 |
| I8 | 5-2-3 | "Uppercut, cross, hook" | 5-2-3 |
| I9 | 1-2-slip_r-2 | "Jab, cross, slip right, cross" | 1-2-SR-2 |
| I10 | 1-2-roll-3-2 | "Jab, cross, roll, hook, cross" | 1-2-R-3-2 |
| I11 | 6-5-2 | "Rear uppercut, uppercut, cross" | 6-5-2 |
| I12 | 1-2b-3 | "Jab, cross body, hook" | 1-2b-3 |
| I13 | 3-4-2 | "Hook, rear hook, cross" | 3-4-2 |
| I14 | 1-2-1-2 | "Jab, cross, jab, cross" | 1-2-1-2 |
| I15 | 2-3-6 | "Cross, hook, rear uppercut" | 2-3-6 |
| I16 | 1-slip_l-2-3 | "Jab, slip left, cross, hook" | 1-SL-2-3 |
| I17 | 3b-3-2 | "Hook body, hook, cross" | 3b-3-2 |
| I18 | 1-2-3-2b | "Jab, cross, hook, cross body" | 1-2-3-2b |

#### Advanced (4-6+ techniques, complex sequences with defense and movement)

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| A1 | 1-1-2-3-2 | "Jab, jab, cross, hook, cross" | 1-1-2-3-2 |
| A2 | 1-2-3-roll-3-2 | "Jab, cross, hook, roll, hook, cross" | 1-2-3-R-3-2 |
| A3 | 1-2-5-6-3-2 | "Jab, cross, uppercut, rear uppercut, hook, cross" | 1-2-5-6-3-2 |
| A4 | 6-3-2-slip_r-2-3 | "Rear uppercut, hook, cross, slip right, cross, hook" | 6-3-2-SR-2-3 |
| A5 | 1-2-duck-2-3-2 | "Jab, cross, duck, cross, hook, cross" | 1-2-D-2-3-2 |
| A6 | 1-2-3b-pivot_l-4-3 | "Jab, cross, hook body, pivot left, rear hook, hook" | 1-2-3b-PL-4-3 |
| A7 | 2-3-2-duck-2-3-2 | "Cross, hook, cross, duck, cross, hook, cross" | 2-3-2-D-2-3-2 |
| A8 | 1-2-3-4b-3b-2 | "Jab, cross, hook, rear hook body, hook body, cross" | 1-2-3-4b-3b-2 |
| A9 | 5-4-3b-pivot_r-1-2 | "Uppercut, rear hook, hook body, pivot right, jab, cross" | 5-4-3b-PR-1-2 |
| A10 | 1-2-slip_r-2-slip_l-2-3 | "Jab, cross, slip right, cross, slip left, cross, hook" | 1-2-SR-2-SL-2-3 |
| A11 | 1-3b-3-6b-6-2 | "Jab, hook body, hook, rear uppercut body, rear uppercut, cross" | 1-3b-3-6b-6-2 |
| A12 | parry-2-3-2-roll-3-2 | "Parry, cross, hook, cross, roll, hook, cross" | P-2-3-2-R-3-2 |
| A13 | 1-2-3-2-step_back-1-2 | "Jab, cross, hook, cross, step back, jab, cross" | 1-2-3-2-SB-1-2 |
| A14 | 1-6b-6-3-2 | "Jab, rear uppercut body, rear uppercut, hook, cross" | 1-6b-6-3-2 |
| A15 | shoulder_roll-2-3-6-3 | "Shoulder roll, cross, hook, rear uppercut, hook" | ShR-2-3-6-3 |
| A16 | 1-1-2-3-4b-3b | "Jab, jab, cross, hook, rear hook body, hook body" | 1-1-2-3-4b-3b |

### Muay Thai Combo Library

Muay Thai uses the same 1-6 punch numbering, plus kicks, knees, elbows, and teeps:

| Key | TTS Text | Description |
|-----|----------|-------------|
| `lk` | "Low kick" | Rear low roundhouse |
| `hk` | "High kick" | Rear high roundhouse |
| `bk` | "Body kick" | Rear mid roundhouse |
| `switch_kick` | "Switch kick" | Lead leg roundhouse (stance switch) |
| `teep` | "Teep" | Front push kick |
| `rear_teep` | "Rear teep" | Rear push kick |
| `lead_elbow` | "Elbow" | Lead horizontal elbow |
| `rear_elbow` | "Rear elbow" | Rear horizontal elbow |
| `up_elbow` | "Up elbow" | Rising elbow (12-6) |
| `lead_knee` | "Knee" | Lead knee strike |
| `rear_knee` | "Rear knee" | Rear knee strike |
| `clinch` | "Clinch" | Enter clinch |

#### Beginner Muay Thai (10 combos)

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| MT-B1 | 1-2-lk | "Jab, cross, low kick" | 1-2-LK |
| MT-B2 | 1-2-bk | "Jab, cross, body kick" | 1-2-BK |
| MT-B3 | 1-2-3-lk | "Jab, cross, hook, low kick" | 1-2-3-LK |
| MT-B4 | teep-1-2 | "Teep, jab, cross" | T-1-2 |
| MT-B5 | 1-2-teep | "Jab, cross, teep" | 1-2-T |
| MT-B6 | lk-1-2 | "Low kick, jab, cross" | LK-1-2 |
| MT-B7 | 1-2-lead_elbow | "Jab, cross, elbow" | 1-2-E |
| MT-B8 | 1-2-rear_knee | "Jab, cross, rear knee" | 1-2-RK |
| MT-B9 | 1-lk | "Jab, low kick" | 1-LK |
| MT-B10 | 1-2-3-bk | "Jab, cross, hook, body kick" | 1-2-3-BK |

#### Intermediate Muay Thai (12 combos)

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| MT-I1 | 1-2-3-2-lk | "Jab, cross, hook, cross, low kick" | 1-2-3-2-LK |
| MT-I2 | teep-1-2-lead_elbow-rear_elbow | "Teep, jab, cross, elbow, rear elbow" | T-1-2-E-RE |
| MT-I3 | 1-2-switch_kick | "Jab, cross, switch kick" | 1-2-SK |
| MT-I4 | lk-1-2-3-hk | "Low kick, jab, cross, hook, high kick" | LK-1-2-3-HK |
| MT-I5 | 1-2-3b-rear_knee | "Jab, cross, hook body, rear knee" | 1-2-3b-RK |
| MT-I6 | 1-2-clinch-rear_knee-rear_knee | "Jab, cross, clinch, rear knee, rear knee" | 1-2-CL-RK-RK |
| MT-I7 | 2-3-hk | "Cross, hook, high kick" | 2-3-HK |
| MT-I8 | 1-2-lead_elbow-rear_elbow-rear_knee | "Jab, cross, elbow, rear elbow, rear knee" | 1-2-E-RE-RK |
| MT-I9 | parry-2-lk | "Parry, cross, low kick" | P-2-LK |
| MT-I10 | bk-1-2-3 | "Body kick, jab, cross, hook" | BK-1-2-3 |
| MT-I11 | 1-rear_teep-lk | "Jab, rear teep, low kick" | 1-RT-LK |
| MT-I12 | 1-2-up_elbow | "Jab, cross, up elbow" | 1-2-UE |

#### Advanced Muay Thai (8 combos)

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| MT-A1 | 1-2-3-hk-clinch-rear_knee-lead_elbow | "Jab, cross, hook, high kick, clinch, rear knee, elbow" | 1-2-3-HK-CL-RK-E |
| MT-A2 | teep-1-2-switch_kick-2-3-lk | "Teep, jab, cross, switch kick, cross, hook, low kick" | T-1-2-SK-2-3-LK |
| MT-A3 | lk-parry-2-lead_elbow-rear_knee-hk | "Low kick, parry, cross, elbow, rear knee, high kick" | LK-P-2-E-RK-HK |
| MT-A4 | 1-2-3-rear_elbow-lead_knee-rear_knee | "Jab, cross, hook, rear elbow, knee, rear knee" | 1-2-3-RE-K-RK |
| MT-A5 | switch_kick-2-3-2-lk | "Switch kick, cross, hook, cross, low kick" | SK-2-3-2-LK |
| MT-A6 | 1-2-clinch-rear_knee-rear_knee-up_elbow | "Jab, cross, clinch, rear knee, rear knee, up elbow" | 1-2-CL-RK-RK-UE |
| MT-A7 | teep-catch-lk-2-3-rear_elbow | "Teep, catch, low kick, cross, hook, rear elbow" | T-C-LK-2-3-RE |
| MT-A8 | 1-2-duck-bk-lead_elbow-rear_knee | "Jab, cross, duck, body kick, elbow, rear knee" | 1-2-D-BK-E-RK |

### MMA Combo Library (10 combos)

MMA adds takedown setups and ground-and-pound cues to the striking vocabulary:

| Key | TTS Text | Description |
|-----|----------|-------------|
| `level_change` | "Level change" | Drop level for takedown threat |
| `sprawl` | "Sprawl" | Sprawl to defend takedown |
| `superman` | "Superman punch" | Jumping cross |

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| MMA1 | 1-2-lk | "Jab, cross, low kick" | 1-2-LK |
| MMA2 | 1-2-3-level_change | "Jab, cross, hook, level change" | 1-2-3-LC |
| MMA3 | 1-2-bk-2-3 | "Jab, cross, body kick, cross, hook" | 1-2-BK-2-3 |
| MMA4 | lk-1-superman | "Low kick, jab, superman punch" | LK-1-SP |
| MMA5 | 1-2-3-2-lk | "Jab, cross, hook, cross, low kick" | 1-2-3-2-LK |
| MMA6 | teep-1-2-3-hk | "Teep, jab, cross, hook, high kick" | T-1-2-3-HK |
| MMA7 | sprawl-2-3-2 | "Sprawl, cross, hook, cross" | SP-2-3-2 |
| MMA8 | 1-2-clinch-rear_knee-lead_elbow | "Jab, cross, clinch, rear knee, elbow" | 1-2-CL-RK-E |
| MMA9 | 1-2-duck-2-lk | "Jab, cross, duck, cross, low kick" | 1-2-D-2-LK |
| MMA10 | bk-2-3-level_change-2 | "Body kick, cross, hook, level change, cross" | BK-2-3-LC-2 |

### Kickboxing Combo Library (10 combos)

Kickboxing is similar to Muay Thai but typically without elbows, knees, and clinch:

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| KB1 | 1-2-lk | "Jab, cross, low kick" | 1-2-LK |
| KB2 | 1-2-hk | "Jab, cross, high kick" | 1-2-HK |
| KB3 | 1-2-3-bk | "Jab, cross, hook, body kick" | 1-2-3-BK |
| KB4 | lk-1-2-3 | "Low kick, jab, cross, hook" | LK-1-2-3 |
| KB5 | 1-2-3-2-lk | "Jab, cross, hook, cross, low kick" | 1-2-3-2-LK |
| KB6 | 2-3-hk | "Cross, hook, high kick" | 2-3-HK |
| KB7 | switch_kick-2-3-2 | "Switch kick, cross, hook, cross" | SK-2-3-2 |
| KB8 | teep-1-2-bk | "Teep, jab, cross, body kick" | T-1-2-BK |
| KB9 | 1-2-slip_r-2-lk | "Jab, cross, slip right, cross, low kick" | 1-2-SR-2-LK |
| KB10 | 1-2-3-switch_kick-2 | "Jab, cross, hook, switch kick, cross" | 1-2-3-SK-2 |

### Defense-Only Drill Library

For pure defense rounds (useful in compound round defense segments):

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| D1 | slip_r-slip_l | "Slip right, slip left" | SR-SL |
| D2 | slip_r-2 | "Slip right, cross" | SR-2 |
| D3 | roll-3-2 | "Roll, hook, cross" | R-3-2 |
| D4 | parry-2-3 | "Parry, cross, hook" | P-2-3 |
| D5 | block-2-3-2 | "Block, cross, hook, cross" | B-2-3-2 |
| D6 | slip_l-slip_r-roll | "Slip left, slip right, roll" | SL-SR-R |
| D7 | pull-1-2 | "Pull back, jab, cross" | PB-1-2 |
| D8 | duck-5-2 | "Duck, uppercut, cross" | D-5-2 |
| D9 | parry-slip_r-2-3 | "Parry, slip right, cross, hook" | P-SR-2-3 |
| D10 | shoulder_roll-2-3-6 | "Shoulder roll, cross, hook, rear uppercut" | ShR-2-3-6 |

### Footwork-Only Drill Library

For movement-focused rounds:

| # | Combo | TTS Text | Display |
|---|-------|----------|---------|
| F1 | pivot_l-1-2 | "Pivot left, jab, cross" | PL-1-2 |
| F2 | pivot_r-2-3 | "Pivot right, cross, hook" | PR-2-3 |
| F3 | angle_l-1-2-3 | "Angle left, jab, cross, hook" | AL-1-2-3 |
| F4 | step_back-1-2 | "Step back, jab, cross" | SB-1-2 |
| F5 | in_out-1-2 | "In and out, jab, cross" | IO-1-2 |
| F6 | circle_l-1-2 | "Circle left, jab, cross" | CL-1-2 |
| F7 | circle_r-2-3 | "Circle right, cross, hook" | CR-2-3 |
| F8 | lateral-1-1-2 | "Lateral, jab, jab, cross" | LT-1-1-2 |
| F9 | cut_off-1-2-3 | "Cut off, jab, cross, hook" | CO-1-2-3 |
| F10 | angle_r-2-3-2 | "Angle right, cross, hook, cross" | AR-2-3-2 |

---

## Data Model

### Technique Enum

Every atomic action the coach can call out. This is the building block of combos.

```dart
/// A single technique the coach can call out.
/// Each technique has a display abbreviation, a TTS-friendly spoken form,
/// and a category (punch, defense, footwork, kick, elbow, knee, other).
enum TechniqueCategory { punch, defense, footwork, kick, elbow, knee, other }

class Technique {
  final String id;           // e.g., '1', '2', '3b', 'slip_r', 'lk'
  final String displayText;  // e.g., '1', 'SR', 'LK'
  final Map<String, String> ttsText; // locale → spoken text, e.g., {'en': 'Jab', 'es': 'Jab', 'pt': 'Jab'}
  final TechniqueCategory category;

  const Technique({
    required this.id,
    required this.displayText,
    required this.ttsText,
    required this.category,
  });
}
```

### Combo Model

```dart
/// A single combo: an ordered sequence of techniques.
@freezed
class Combo with _$Combo {
  const factory Combo({
    required String id,               // Unique: 'boxing_b_1' or user-generated UUID
    required List<String> techniqueIds, // e.g., ['1', '2', 'slip_r', '2']
    required ComboDifficulty difficulty,
    required ComboSport sport,
    @Default(false) bool isCustom,     // User-created
    @Default('') String displayText,   // Pre-computed: '1-2-SR-2'
    @Default('') String ttsText,       // Pre-computed for locale: 'Jab, cross, slip right, cross'
  }) = _Combo;

  factory Combo.fromJson(Map<String, dynamic> json) =>
      _$ComboFromJson(json);
}

enum ComboDifficulty { beginner, intermediate, advanced }

enum ComboSport { boxing, muayThai, mma, kickboxing, defense, footwork }
```

### ComboSet Model

```dart
/// A named group of combos used together (e.g., "Boxing Fundamentals").
@freezed
class ComboSet with _$ComboSet {
  const factory ComboSet({
    required String id,
    required String name,
    required ComboSport sport,
    required ComboDifficulty difficulty,
    required List<String> comboIds,    // References into the combo library
    @Default(false) bool isCustom,
  }) = _ComboSet;

  factory ComboSet.fromJson(Map<String, dynamic> json) =>
      _$ComboSetFromJson(json);
}
```

### ComboCalloutConfig (Session-level settings)

```dart
/// Combo callout settings attached to a session.
@freezed
class ComboCalloutConfig with _$ComboCalloutConfig {
  const factory ComboCalloutConfig({
    @Default(false) bool enabled,
    @Default(ComboSport.boxing) ComboSport sport,
    @Default(ComboDifficulty.beginner) ComboDifficulty difficulty,
    @Default(ComboIntensity.moderate) ComboIntensity intensity,
    @Default(true) bool includeDefense,     // Mix in defense cues
    @Default(false) bool includeFootwork,   // Mix in footwork cues
    @Default(null) String? comboSetId,      // null = use default set for sport+difficulty
  }) = _ComboCalloutConfig;

  factory ComboCalloutConfig.fromJson(Map<String, dynamic> json) =>
      _$ComboCalloutConfigFromJson(json);
}

/// Controls the pacing between combo callouts.
enum ComboIntensity {
  relaxed,   // 8-12s between combos
  moderate,  // 5-8s between combos
  intense,   // 3-5s between combos
  hurricane, // 2-3s between combos
}
```

### SessionModel Changes

Add a single field to `SessionModel`:

```dart
@freezed
class SessionModel with _$SessionModel {
  const factory SessionModel({
    // ... all existing fields ...
    @Default(null) ComboCalloutConfig? comboConfig,  // NEW
  }) = _SessionModel;
}
```

When `comboConfig` is non-null and `comboConfig.enabled == true`, the timer engine triggers combo callouts during work/segment phases.

---

## Voice Engine: ComboCalloutEngine

### Architecture

The `ComboCalloutEngine` is a standalone service that the `TimerEngine` drives. It does not tick independently -- instead, the timer engine tells it when to start, stop, pause, and when to check if a callout is due.

```dart
/// Drives combo voice callouts during active work phases.
///
/// Lifecycle:
///   1. Timer engine calls onWorkPhaseStart() → engine starts scheduling
///   2. Timer engine calls onTick(remaining) each tick → engine checks if
///      it's time to speak
///   3. Timer engine calls onPhaseEnd() → engine stops and resets
///   4. Timer engine calls onPause() / onResume() → engine suspends/resumes
///
/// The engine picks combos randomly from the filtered library, avoiding
/// repeating the same combo consecutively. It uses TTS to speak the combo.
class ComboCalloutEngine {
  final VoiceService voiceService;
  final ComboCalloutConfig config;
  final List<Combo> comboPool;  // Pre-filtered by sport + difficulty

  DateTime? _lastCalloutTime;
  String? _lastComboId;         // Avoid immediate repeats
  bool _active = false;
  bool _paused = false;
  Duration _initialDelay;       // 2-3s after round start before first combo

  ComboCalloutEngine({
    required this.voiceService,
    required this.config,
    required this.comboPool,
  });

  /// Called when a work phase (or work segment) begins.
  void onWorkPhaseStart() {
    _active = true;
    _paused = false;
    _lastCalloutTime = DateTime.now();
    _initialDelay = const Duration(seconds: 3); // Wait for round bell + announcement
  }

  /// Called on each timer tick. Returns true if a callout was triggered.
  /// [remaining] is the time left in the current phase.
  /// [warningTime] is the session's warning threshold.
  bool onTick(Duration remaining, Duration warningTime) {
    if (!_active || _paused || comboPool.isEmpty) return false;

    // Don't call combos during the warning period (last N seconds of round)
    if (warningTime > Duration.zero && remaining <= warningTime) return false;

    // Don't call a combo if there isn't enough time for the fighter to execute
    // (at least 3 seconds before warning zone or phase end)
    final cutoff = warningTime > Duration.zero
        ? warningTime + const Duration(seconds: 3)
        : const Duration(seconds: 3);
    if (remaining <= cutoff) return false;

    final now = DateTime.now();
    final elapsed = now.difference(_lastCalloutTime!);

    // Check initial delay
    if (_initialDelay > Duration.zero) {
      if (elapsed < _initialDelay) return false;
      _initialDelay = Duration.zero;
    }

    // Check interval
    final interval = _intervalForIntensity(config.intensity);
    if (elapsed < interval) return false;

    // Pick and speak a combo
    final combo = _pickCombo();
    if (combo == null) return false;

    _lastCalloutTime = now;
    _lastComboId = combo.id;
    _speakCombo(combo);
    return true;
  }

  void onPause() => _paused = true;

  void onResume() {
    _paused = false;
    // Reset timer so next combo doesn't fire immediately
    _lastCalloutTime = DateTime.now();
  }

  void onPhaseEnd() {
    _active = false;
  }

  /// Random interval within the intensity range.
  Duration _intervalForIntensity(ComboIntensity intensity) {
    final range = switch (intensity) {
      ComboIntensity.relaxed   => (min: 8, max: 12),
      ComboIntensity.moderate  => (min: 5, max: 8),
      ComboIntensity.intense   => (min: 3, max: 5),
      ComboIntensity.hurricane => (min: 2, max: 3),
    };
    final seconds = range.min + _random.nextInt(range.max - range.min + 1);
    return Duration(seconds: seconds);
  }

  Combo? _pickCombo() {
    if (comboPool.length == 1) return comboPool.first;
    // Filter out the last-called combo to avoid repeats
    final candidates = comboPool.where((c) => c.id != _lastComboId).toList();
    if (candidates.isEmpty) return comboPool.first;
    return candidates[_random.nextInt(candidates.length)];
  }

  void _speakCombo(Combo combo) {
    // Use a higher speech rate for combos than for round announcements
    voiceService.speakCombo(combo.ttsText);
  }

  final _random = math.Random();
}
```

### TTS Configuration for Combos

The existing `VoiceService` needs a new method for combo speech:

```dart
/// Speak a combo callout with faster speech rate.
Future<void> speakCombo(String text) async {
  if (!_initialized) return;
  try {
    await _tts.stop();
    await _tts.setSpeechRate(_comboSpeechRate);
    await _tts.speak(text);
    // Restore normal rate after speaking (for phase announcements)
    // Done via completion handler or a flag check
  } catch (e) {
    debugPrint('VoiceService: speakCombo failed: $e');
  }
}
```

Speech rate settings per intensity:

| Intensity | TTS Speech Rate | Rationale |
|-----------|----------------|-----------|
| Relaxed | 0.6 | Slower, clear enunciation for beginners |
| Moderate | 0.7 | Default, balanced |
| Intense | 0.8 | Faster delivery |
| Hurricane | 0.9 | Rapid fire, experienced fighters |

### Audio Priority & Conflict Resolution

1. **Bell cue fires** (round start, warning, round end):
   - `VoiceService.stop()` immediately (kills any active combo speech).
   - Play bell sound via `just_audio`.
   - Combo engine resets its `_lastCalloutTime` so it waits the normal interval before next combo.

2. **Phase announcement fires** ("Round 3", "Rest"):
   - Happens 500ms after bell (existing behavior in `timerEngineProvider`).
   - Combo engine has a 3-second initial delay after work phase start, so no conflict.

3. **Combo callout fires during work phase**:
   - Uses `VoiceService.speakCombo()` at the appropriate speech rate.
   - If a bell fires mid-combo, the bell handler calls `_tts.stop()` first.

---

## Timer Integration

### How ComboCalloutEngine Plugs Into TimerEngine

The `ComboCalloutEngine` is **not** embedded inside `TimerEngine`. Instead, the integration happens at the provider level in `timer_controller.dart`, similar to how `onAudioCue` and `onVoiceAnnounce` are wired.

```
TimerEngine (pure Dart, no combo knowledge)
    │
    ├─ onAudioCue → BoxingAudioService.playCue()
    ├─ onVoiceAnnounce → VoiceService.announce()
    │
    └─ stateStream → timerStateProvider
                        │
                        └─ ComboCalloutEngine listens to state changes
                            ├─ work phase start → onWorkPhaseStart()
                            ├─ each tick → onTick(remaining, warningTime)
                            ├─ pause → onPause()
                            ├─ resume → onResume()
                            └─ phase end → onPhaseEnd()
```

The `ComboCalloutEngine` is created when a session with `comboConfig.enabled == true` starts, and disposed when the session ends.

### Integration in timer_controller.dart

```dart
/// Provider for the combo callout engine. Null if combo callouts are disabled
/// for the active session.
final comboCalloutEngineProvider = Provider<ComboCalloutEngine?>((ref) {
  final session = ref.watch(activeSessionProvider);
  if (session == null) return null;

  final config = session.comboConfig;
  if (config == null || !config.enabled) return null;

  final voiceService = ref.watch(voiceServiceProvider);
  final comboPool = ref.watch(filteredCombosProvider(config));

  return ComboCalloutEngine(
    voiceService: voiceService,
    config: config,
    comboPool: comboPool,
  );
});
```

### When Callouts Fire

- **Work phase** (`_EnginePhase.work`): combos fire throughout.
- **Segment phase** (`_EnginePhase.segment`): combos fire only in segments with `color == 'work'` (not rest/warmup segments).
- **Rest phase**: no combos.
- **Warmup phase**: no combos.
- **Paused**: combos paused.
- **Warning zone** (last N seconds of round): no combos -- the fighter needs to hear the warning bell clearly and wind down.
- **Auto-stop buffer**: no combo fires if fewer than 3 seconds remain before the warning zone (so the fighter has time to execute the last combo).

---

## UI Changes

### Timer Screen: Combo Display Overlay

When a combo is called, display it visually on the timer screen for 3-4 seconds. The combo appears as a horizontal row of technique badges below the phase label.

```
┌─────────────────────────────┐
│         ROUND 3 / 8         │
│                             │
│      ┌─────────────┐        │
│      │   2:47      │        │
│      │  ╭───────╮  │        │
│      └─────────────┘        │
│                             │
│         WORK                │
│                             │
│  ┌───┬───┬────┬───┐         │  ← Combo overlay (fades in/out)
│  │ 1 │ 2 │ SR │ 2 │         │    Numbers in colored badges
│  └───┴───┴────┴───┘         │
│                             │
│   ┌───┐   ┌───┐   ┌───┐    │
│   │ ◀ │   │ ⏸ │   │ ▶ │    │
│   └───┘   └───┘   └───┘    │
│                             │
│    Total: 12:33 elapsed     │
└─────────────────────────────┘
```

**Badge colors**:
- Punches: white text on green background (work color)
- Defense: white text on amber background (warning color)
- Footwork: white text on blue background (warmup color)
- Kicks/Elbows/Knees: white text on orange-red background

**Animation**: Fade in over 200ms, hold for 3s, fade out over 500ms. New combo replaces old one immediately if timing overlaps.

### Session Editor: Combo Settings Section

Add a collapsible section to the session editor after the existing toggle switches:

```
┌──────────────────────────────────┐
│ Combo Callouts                   │
│ ┌────────────────────────────┐   │
│ │ Enable combo callouts  [✓] │   │
│ └────────────────────────────┘   │
│                                  │
│ Sport                            │
│ [Boxing] [Muay Thai] [MMA] [KB]  │  ← SegmentedButton
│                                  │
│ Difficulty                       │
│ [Beginner] [Intermediate] [Adv]  │  ← SegmentedButton
│                                  │
│ Intensity                        │
│ [Relaxed] [Moderate] [Intense]   │  ← Chips
│ [Hurricane]                      │
│                                  │
│ ☐ Include defense cues           │
│ ☐ Include footwork cues          │
│                                  │
│ Preview: 16 combos in pool       │  ← Live count
└──────────────────────────────────┘
```

The section is collapsed by default. When "Enable combo callouts" is toggled on, it expands to show the options.

### Session Summary View (Pre-Workout)

When combo callouts are enabled, show in the session summary:

```
Combo Callouts    Boxing - Beginner
Intensity         Moderate
```

### TimerState Extension

Add a field to carry the current combo display text to the UI:

```dart
class TimerState {
  // ... existing fields ...
  final String? activeComboDisplay;   // e.g., '1-2-SR-2' or null
  final List<String>? activeComboTechniques; // e.g., ['1', '2', 'slip_r', '2'] for badge rendering
}
```

Alternatively (simpler approach): use a separate `StreamController<Combo?>` in the `ComboCalloutEngine` that the UI subscribes to independently. This avoids modifying `TimerState` and keeps combo display decoupled.

**Decision: Use a separate stream.** This keeps `TimerEngine` and `TimerState` unchanged (they have no combo knowledge), and the combo display is a purely additive UI layer.

```dart
/// In ComboCalloutEngine:
final _displayController = StreamController<Combo?>.broadcast();
Stream<Combo?> get activeComboStream => _displayController.stream;

/// When a combo is called:
_displayController.add(combo);

/// After display duration:
Future.delayed(const Duration(seconds: 4), () {
  _displayController.add(null);
});
```

---

## Preset Updates

### Existing Presets That Get Combo Callouts Enabled

These presets are natural fits for combo callouts and will have `comboConfig` set:

| Preset | Sport | Difficulty | Intensity | Defense | Footwork |
|--------|-------|-----------|-----------|---------|----------|
| Shadow Boxing | Boxing | Beginner | Moderate | Yes | No |
| Heavy Bag | Boxing | Intermediate | Moderate | No | No |
| Pad Work | Boxing | Intermediate | Moderate | No | No |
| Muay Thai | Muay Thai | Beginner | Moderate | No | No |
| MMA | MMA | Beginner | Moderate | No | No |
| Kickboxing | Kickboxing | Beginner | Moderate | No | No |

Presets that do NOT get combos: Pro Boxing, Amateur Boxing, Sparring (these simulate fights, not drills), Speed Bag (rhythm, not combos), Conditioning/Tabata/EMOM (cardio, not technique), Beginner (keep it simple), Youth Boxing, Offense/Defense, Bag+Conditioning, Burnout Rounds.

### New Combo-Specific Presets

| Preset | Rounds | Work | Rest | Sport | Difficulty | Intensity | Defense | Footwork |
|--------|--------|------|------|-------|-----------|-----------|---------|----------|
| Combo Drill - Beginner | 4 | 2:00 | 1:00 | Boxing | Beginner | Relaxed | No | No |
| Combo Drill - Intermediate | 6 | 3:00 | 1:00 | Boxing | Intermediate | Moderate | Yes | No |
| Combo Drill - Advanced | 8 | 3:00 | 1:00 | Boxing | Advanced | Intense | Yes | Yes |
| Shadow Boxing + Combos | 5 | 3:00 | 0:30 | Boxing | Beginner | Moderate | Yes | Yes |
| Muay Thai Combo Drill | 5 | 3:00 | 1:00 | Muay Thai | Intermediate | Moderate | No | No |
| MMA Combo Drill | 3 | 5:00 | 1:00 | MMA | Beginner | Moderate | No | No |

---

## File Changes

### New Files to Create

| File | Description |
|------|-------------|
| `lib/features/combos/domain/technique.dart` | `Technique` class and `TechniqueCategory` enum |
| `lib/features/combos/domain/combo_model.dart` | `Combo`, `ComboDifficulty`, `ComboSport` freezed model |
| `lib/features/combos/domain/combo_set.dart` | `ComboSet` freezed model |
| `lib/features/combos/domain/combo_callout_config.dart` | `ComboCalloutConfig`, `ComboIntensity` freezed model |
| `lib/features/combos/data/technique_library.dart` | All technique definitions (punches, defense, footwork, MT kicks, etc.) |
| `lib/features/combos/data/combo_library.dart` | All preset combos for all sports and difficulty levels |
| `lib/features/combos/data/combo_set_library.dart` | Preset combo sets (default groupings per sport+difficulty) |
| `lib/features/combos/data/combo_repository.dart` | CRUD for custom combos and combo sets (Hive persistence) |
| `lib/features/combos/domain/combo_callout_engine.dart` | `ComboCalloutEngine` -- timing, random selection, TTS triggering |
| `lib/features/combos/presentation/combo_callout_provider.dart` | Riverpod providers for combo engine, filtered combos, active combo stream |
| `lib/features/combos/presentation/combo_display_widget.dart` | Overlay widget showing active combo as technique badges on timer screen |
| `lib/features/combos/presentation/combo_settings_section.dart` | Session editor section for combo config (sport, difficulty, intensity, toggles) |
| `lib/features/combos/presentation/combo_preview_sheet.dart` | Bottom sheet to preview the combo pool (what combos will be called) |
| `test/features/combos/combo_callout_engine_test.dart` | Unit tests for combo engine timing and selection |
| `test/features/combos/combo_library_test.dart` | Tests for combo data integrity (all techniques exist, TTS text complete) |

### Files to Modify

| File | Change |
|------|--------|
| `lib/features/sessions/domain/session_model.dart` | Add `ComboCalloutConfig? comboConfig` field to `SessionModel` |
| `lib/features/sessions/domain/session_model.freezed.dart` | Regenerated |
| `lib/features/sessions/domain/session_model.g.dart` | Regenerated |
| `lib/features/audio/data/voice_service.dart` | Add `speakCombo(String text)` method with configurable speech rate; add `comboSpeechRate` field |
| `lib/features/timer/presentation/timer_controller.dart` | Add `comboCalloutEngineProvider` and `filteredCombosProvider`; wire combo engine lifecycle to timer state stream |
| `lib/features/timer/presentation/timer_screen.dart` | Add `ComboDisplayWidget` overlay to `_ActiveTimerView`; subscribe to active combo stream; show combo info in session summary |
| `lib/features/sessions/presentation/session_editor_screen.dart` | Add `ComboSettingsSection` widget below existing toggle switches |
| `lib/core/constants/preset_sessions.dart` | Add `comboConfig` to 6 existing presets; add 6 new combo-specific presets |
| `lib/l10n/app_en.arb` | Add localization keys for combo UI (section title, sport names, difficulty names, intensity names, toggle labels) |
| `lib/l10n/app_es.arb` | Spanish translations for combo UI |
| `lib/l10n/app_pt.arb` | Portuguese translations for combo UI |
| `pubspec.yaml` | No new packages needed |

### Build Runner Regeneration Required

After modifying `session_model.dart` and creating the new freezed models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Localization Keys to Add

```json
{
  "comboSectionTitle": "Combo Callouts",
  "comboEnable": "Enable combo callouts",
  "comboEnableDescription": "Coach calls out punch combinations during work phases",
  "comboSport": "Sport",
  "comboSportBoxing": "Boxing",
  "comboSportMuayThai": "Muay Thai",
  "comboSportMMA": "MMA",
  "comboSportKickboxing": "Kickboxing",
  "comboDifficulty": "Difficulty",
  "comboDifficultyBeginner": "Beginner",
  "comboDifficultyIntermediate": "Intermediate",
  "comboDifficultyAdvanced": "Advanced",
  "comboIntensity": "Intensity",
  "comboIntensityRelaxed": "Relaxed",
  "comboIntensityModerate": "Moderate",
  "comboIntensityIntense": "Intense",
  "comboIntensityHurricane": "Hurricane",
  "comboIncludeDefense": "Include defense cues",
  "comboIncludeFootwork": "Include footwork cues",
  "comboPoolSize": "{count} combos in pool",
  "comboPreviewTitle": "Combo Pool Preview",
  "comboSummaryLabel": "Combo Callouts",
  "comboSummaryValue": "{sport} - {difficulty}",
  "comboIntensityLabel": "Intensity"
}
```

---

## Dependencies

No new packages are needed. The feature uses:
- `flutter_tts` (existing) -- for TTS combo speech
- `freezed_annotation` / `freezed` (existing) -- for combo data models
- `hive` / `hive_flutter` (existing) -- for custom combo persistence
- `flutter_riverpod` (existing) -- for state management

---

## Implementation Order

The implementation should proceed in this order to allow incremental testing:

1. **Data models** (`technique.dart`, `combo_model.dart`, `combo_callout_config.dart`, `combo_set.dart`)
2. **Technique & combo libraries** (`technique_library.dart`, `combo_library.dart`, `combo_set_library.dart`)
3. **ComboCalloutEngine** (`combo_callout_engine.dart`) + unit tests
4. **VoiceService changes** (`voice_service.dart` -- add `speakCombo`)
5. **SessionModel changes** (`session_model.dart` -- add `comboConfig`) + build_runner
6. **Provider wiring** (`combo_callout_provider.dart`, `timer_controller.dart` changes)
7. **Combo display widget** (`combo_display_widget.dart`)
8. **Timer screen integration** (`timer_screen.dart`)
9. **Session editor section** (`combo_settings_section.dart`, `session_editor_screen.dart`)
10. **Preset updates** (`preset_sessions.dart`)
11. **Localization** (all .arb files)
12. **Integration testing**

---

## Acceptance Criteria

### Core Engine
- [ ] `ComboCalloutEngine` fires combos at correct intervals for each intensity level
- [ ] No combo fires during rest phases, warmup, or paused state
- [ ] No combo fires during the warning zone (last N seconds of round)
- [ ] No combo fires within 3 seconds before the warning zone
- [ ] First combo fires 3 seconds after round start (after bell + "Round N" announcement)
- [ ] Same combo never fires twice consecutively
- [ ] Combo pool correctly filters by sport, difficulty, defense, and footwork settings
- [ ] Pausing the timer pauses combo callouts; resuming resumes them without immediate fire

### Voice
- [ ] TTS speaks combo text at appropriate speech rate (faster than round announcements)
- [ ] Bell sounds take priority over combo speech (TTS stops, bell plays)
- [ ] Combo speech does not overlap with "Round N" or "Rest" announcements
- [ ] Combo speech works in all three locales (en, es, pt)

### UI
- [ ] Combo display overlay appears on timer screen when combo is called
- [ ] Technique badges show with correct category colors
- [ ] Overlay fades in/out smoothly (200ms in, 500ms out)
- [ ] Overlay does not obscure the countdown display or controls
- [ ] Combo settings section appears in session editor when creating/editing sessions
- [ ] Sport, difficulty, intensity, defense, and footwork options all functional
- [ ] Combo pool size preview updates live as settings change
- [ ] Session summary shows combo config when enabled

### Data
- [ ] All 16 beginner boxing combos render correctly (display + TTS)
- [ ] All 18 intermediate boxing combos render correctly
- [ ] All 16 advanced boxing combos render correctly
- [ ] All 30 Muay Thai combos render correctly
- [ ] All 10 MMA combos render correctly
- [ ] All 10 kickboxing combos render correctly
- [ ] All 10 defense combos render correctly
- [ ] All 10 footwork combos render correctly
- [ ] `SessionModel` with `comboConfig` serializes/deserializes correctly (JSON + Hive)
- [ ] Custom combos persist across app restart

### Presets
- [ ] 6 existing presets have combo callouts enabled with correct defaults
- [ ] 6 new combo-specific presets appear in the session list
- [ ] New presets are categorized correctly in the home screen

### Integration
- [ ] Full workout with combo callouts runs without crashes
- [ ] Combos work correctly with compound rounds (segments)
- [ ] Combos work correctly with per-round template overrides
- [ ] `flutter analyze` passes with zero errors
- [ ] `flutter test` passes all combo-related tests

---

## Technique Reference: Complete ID Registry

This is the definitive list of all technique IDs used in the combo library. Every combo's `techniqueIds` list references these IDs. The implementor must create a `Technique` object for each entry in `technique_library.dart`.

### Punches

| ID | Display | TTS (en) | TTS (es) | TTS (pt) |
|----|---------|----------|----------|----------|
| `1` | 1 | Jab | Jab | Jab |
| `2` | 2 | Cross | Cross | Cross |
| `3` | 3 | Hook | Gancho | Gancho |
| `4` | 4 | Rear hook | Gancho trasero | Gancho traseiro |
| `5` | 5 | Uppercut | Uppercut | Uppercut |
| `6` | 6 | Rear uppercut | Uppercut trasero | Uppercut traseiro |
| `1b` | 1b | Jab body | Jab cuerpo | Jab corpo |
| `2b` | 2b | Cross body | Cross cuerpo | Cross corpo |
| `3b` | 3b | Hook body | Gancho cuerpo | Gancho corpo |
| `4b` | 4b | Rear hook body | Gancho trasero cuerpo | Gancho traseiro corpo |
| `5b` | 5b | Uppercut body | Uppercut cuerpo | Uppercut corpo |
| `6b` | 6b | Rear uppercut body | Uppercut trasero cuerpo | Uppercut traseiro corpo |

### Defense

| ID | Display | TTS (en) | TTS (es) | TTS (pt) |
|----|---------|----------|----------|----------|
| `slip_l` | SL | Slip left | Esquiva izquierda | Esquiva esquerda |
| `slip_r` | SR | Slip right | Esquiva derecha | Esquiva direita |
| `roll` | R | Roll | Rolar | Rolar |
| `block` | B | Block | Bloquear | Bloquear |
| `parry` | P | Parry | Desviar | Defletir |
| `pull` | PB | Pull back | Retroceder | Recuar |
| `catch` | C | Catch | Atrapar | Pegar |
| `duck` | D | Duck | Agacharse | Agachar |
| `cover` | CV | Cover | Cubrirse | Cobrir |
| `shoulder_roll` | ShR | Shoulder roll | Shoulder roll | Shoulder roll |

### Footwork

| ID | Display | TTS (en) | TTS (es) | TTS (pt) |
|----|---------|----------|----------|----------|
| `pivot_l` | PvL | Pivot left | Pivote izquierda | Pivo esquerda |
| `pivot_r` | PvR | Pivot right | Pivote derecha | Pivo direita |
| `angle_l` | AL | Angle left | Angulo izquierda | Angulo esquerda |
| `angle_r` | AR | Angle right | Angulo derecha | Angulo direita |
| `step_back` | SB | Step back | Paso atras | Passo atras |
| `cut_off` | CO | Cut off | Cortar | Cortar |
| `circle_l` | CiL | Circle left | Circular izquierda | Circular esquerda |
| `circle_r` | CiR | Circle right | Circular derecha | Circular direita |
| `in_out` | IO | In and out | Entrar y salir | Entrar e sair |
| `lateral` | LT | Lateral | Lateral | Lateral |

### Muay Thai Strikes

| ID | Display | TTS (en) | TTS (es) | TTS (pt) |
|----|---------|----------|----------|----------|
| `lk` | LK | Low kick | Patada baja | Chute baixo |
| `hk` | HK | High kick | Patada alta | Chute alto |
| `bk` | BK | Body kick | Patada cuerpo | Chute corpo |
| `switch_kick` | SK | Switch kick | Patada switch | Chute switch |
| `teep` | T | Teep | Teep | Teep |
| `rear_teep` | RT | Rear teep | Teep trasero | Teep traseiro |
| `lead_elbow` | E | Elbow | Codo | Cotovelada |
| `rear_elbow` | RE | Rear elbow | Codo trasero | Cotovelada traseira |
| `up_elbow` | UE | Up elbow | Codo ascendente | Cotovelada ascendente |
| `lead_knee` | K | Knee | Rodilla | Joelhada |
| `rear_knee` | RK | Rear knee | Rodilla trasera | Joelhada traseira |
| `clinch` | CL | Clinch | Clinch | Clinch |

### MMA-Specific

| ID | Display | TTS (en) | TTS (es) | TTS (pt) |
|----|---------|----------|----------|----------|
| `level_change` | LC | Level change | Cambio de nivel | Mudanca de nivel |
| `sprawl` | SP | Sprawl | Sprawl | Sprawl |
| `superman` | SM | Superman punch | Golpe superman | Soco superman |

---

## Future Enhancements (Out of Scope for This Sprint)

1. **Progressive combo building** (Precision Boxing Coach style): start with "1-2", then build to "1-2-slip right", then "1-2-slip right-2". Requires a `ComboProgression` engine.
2. **Custom combo creator UI**: let users tap technique buttons to build combos visually.
3. **Combo history/stats**: track which combos were called, how many per round.
4. **Combo audio packs**: pre-recorded coach voices instead of TTS (male/female, different styles).
5. **Counter-punching mode**: call out an incoming attack, user responds with the counter. E.g., "Incoming hook" → user rolls and throws 3-2.
6. **Combo difficulty auto-progression**: start round at beginner, escalate to intermediate midway if the user sets "progressive" mode.
7. **Apple Watch / wearable combo display**: show current combo on wrist.
