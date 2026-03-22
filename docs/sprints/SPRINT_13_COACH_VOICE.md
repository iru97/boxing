# Sprint 13: Coach Voice & Motivational Interjections

## Sprint Goal

Add a motivational interjections system that makes the combo callout engine sound like a real boxing coach — not just calling combos, but encouraging, correcting, and pushing the fighter through the round. This is the single highest-impact feature for the "feeling of not training alone" that drives $3-$10 payments in competitor apps.

**Context**: Sprint 11 improved voice quality (TTS overlap prevention, voice selection, pitch differentiation). Sprint 12 improved combo selection intelligence and data persistence. This sprint adds the emotional/motivational layer on top of the technical foundation.

---

## Research Findings

### Real Boxing Coach Communication

Academic research on ringside coaching cues (Halperin & Wulf, UNLV) shows coaches use roughly 29% positive vs 12% negative feedback. Padwork coaching research confirms that 1-2 word commands dominate because multi-syllable instructions get lost during exertion. Single-word exclamations ("Good!", "Harder!", "Work!") are the most effective coaching cues during high-intensity training.

Apps like Shadow Boxing App (4.9 stars, 6,500+ reviews) and FightCamp use voice coaching between combos. The pattern: coach-like audio fills silence between technique calls, creating the "training with someone" perception.

### Architecture Decision

Three options were evaluated for emitting interjections alongside combos:

| Option | Approach | Impact on Existing Code |
|---|---|---|
| A: Sealed union | `CalloutEmission = ComboCallout \| InterjectionCallout` | Changes stream type everywhere |
| B: Separate stream | Second `StreamController<String>.broadcast()` | Zero impact on existing consumers |
| C: Flag on ComboCallout | `ComboCallout` with `isInterjection` flag | Conceptually wrong model |

**Decision: Option B — separate stream.** The combo stream, `ComboDisplayWidget`, `activeComboProvider`, and all Riverpod providers are completely unchanged. Timer screen adds one subscription. Interjections are audio-only (no visual display change).

### Timing & Probability

Real coaches don't intersperse encouragement at fixed intervals. Analysis of padwork session recordings shows:

- Encouragement clusters around moments *between* combo sets (not during)
- Coaches increase verbal intensity near round end
- First 10-15 seconds of a round: combo-only (fighter is settling in)
- Technique corrections (Category C) are delivered during recovery moments, not escalation

---

## Deliverables

### Phase A: Interjection Library

#### I1: Phrase Library — `interjection_library.dart`

New file: `lib/features/combos/data/interjection_library.dart`

**102 phrases total** — 34 per locale (en/es/pt) across 4 categories.

**Storage**: Static `const Map` in Dart code (not ARB files). Follows the same pattern as `Technique.ttsText['en']` and the rest of the training content. ARB is for UI strings requiring translation tooling — training content lives in code.

```
Category A: Encouragement (10 per locale)
  EN: "Good!" "Nice!" "That's it!" "Let's go!" "Beautiful!"
      "Keep it up!" "There you go!" "Yes!" "Sharp!" "Clean!"
  ES: "Bien!" "Eso es!" "Vamos!" "Asi se hace!" "Perfecto!"
      "Sigue asi!" "Ahi esta!" "Si!" "Preciso!" "Limpio!"
  PT: "Bom!" "Isso!" "Vamos!" "Muito bem!" "Perfeito!"
      "Continue!" "E isso ai!" "Sim!" "Preciso!" "Limpo!"

Category B: Intensity (10 per locale)
  EN: "Work!" "Harder!" "Faster!" "Don't stop!" "Push it!"
      "Stay busy!" "More power!" "Go!" "Keep moving!" "Non-stop!"
  ES: "Trabaja!" "Mas fuerte!" "Mas rapido!" "No pares!" "Empuja!"
      "Mantente activo!" "Mas potencia!" "Venga!" "Sigue moviendote!" "Sin parar!"
  PT: "Trabalha!" "Mais forte!" "Mais rapido!" "Nao para!" "Empurra!"
      "Fica ativo!" "Mais potencia!" "Vai!" "Continua se movendo!" "Sem parar!"

Category C: Technique (10 per locale)
  EN: "Hands up!" "Stay tight!" "Move your head!" "Breathe!" "Snap it!"
      "Work the body!" "Stay loose!" "Reset!" "Chin down!" "Stay on your toes!"
  ES: "Manos arriba!" "Mantente cerrado!" "Mueve la cabeza!" "Respira!" "Chasquealo!"
      "Trabaja el cuerpo!" "Relajate!" "Posicion!" "Barbilla abajo!" "Punta de los pies!"
  PT: "Maos para cima!" "Fica fechado!" "Mexe a cabeca!" "Respira!" "Estalido!"
      "Trabalha o corpo!" "Relaxa!" "Posicao!" "Queixo abaixo!" "Na ponta dos pes!"

Category D: Round-Context (4 per locale, time-triggered only)
  EN: "Last thirty!" "Finish strong!" "Dig in!" "One more!"
  ES: "Ultimos treinta!" "Termina fuerte!" "Aguanta!" "Un ultimo esfuerzo!"
  PT: "Ultimos trinta!" "Termina forte!" "Aguenta!" "Mais um!"
```

**API**:
```dart
class InterjectionLibrary {
  static String pick(String locale, InterjectionCategory category, math.Random rng);
}
```

**Estimated**: ~120 lines

---

### Phase B: Engine Integration

#### I2: Second Stream in ComboCalloutEngine

Add to `combo_callout_engine.dart`:
- `StreamController<String>.broadcast()` for interjections
- `Stream<String> get interjectionStream` getter
- `_calloutSlotsThisRound` counter (reset in `onWorkPhaseStart`)
- `_escalationInterjectionFired` flag (reset in `onWorkPhaseStart`)

**Slot allocation per callout slot**:

| Configured Intensity | Combo % | Interjection % |
|---|---|---|
| relaxed / moderate | 80% | 20% |
| intense | 85% | 15% |
| hurricane | 90% | 10% |

**Rules**:
- No interjection on first 2 callout slots of each round (grace period)
- Category B (intensity) only after slot 2
- Category C (technique) never during escalation zone
- Category D (round-context) fires once per round when entering escalation zone — independent of slot allocation

**`_fireCalloutSlot()` replaces current `_fireCombo()` call point**:
```dart
void _fireCalloutSlot() {
  _calloutSlotsThisRound++;

  if (!_config.enableCoachEncouragement || _calloutSlotsThisRound <= 2) {
    _fireCombo();
    return;
  }

  final roll = _rng.nextDouble();
  final interjectionThreshold = _interjectionProbability();

  if (roll < interjectionThreshold) {
    _fireInterjection();
  } else {
    _fireCombo();
  }
}
```

**`_fireInterjection()`**:
```dart
void _fireInterjection() {
  final category = _pickInterjectionCategory();
  final text = InterjectionLibrary.pick(_locale, category, _rng);
  if (!_interjectionController.isClosed) {
    _interjectionController.add(text);
  }
}
```

**Estimated**: ~60 lines added to engine

#### I3: VoiceService — `speakInterjection()`

Add to `voice_service.dart`:
```dart
Future<void> speakInterjection(String text) async {
  if (!_initialized) return;
  if (_isSpeaking) return; // Same skip-if-busy policy as combos
  try {
    _isSpeaking = true;
    _speakingTimeoutTimer?.cancel();
    await _tts.setPitch(1.15); // More energetic than combos (1.1)
    await _tts.setSpeechRate(0.65); // Deliberate cadence, not hurried
    await _tts.speak(text);
    _speakingTimeoutTimer = Timer(_maxSpeakingDuration, () {
      _isSpeaking = false;
    });
  } catch (e) {
    _isSpeaking = false;
    debugPrint('VoiceService: speakInterjection failed: $e');
  }
}
```

**Estimated**: ~20 lines

#### I4: Timer Screen Subscription

In `timer_screen.dart` `_startSession()`:
```dart
// After existing combo stream subscription:
_interjectionSubscription = comboEngine.interjectionStream.listen((text) {
  voiceService.speakInterjection(text);
});
```

Add `StreamSubscription<String>? _interjectionSubscription` field, cancel in `dispose()`.

**Estimated**: ~12 lines

---

### Phase C: Configuration

#### I5: Config Toggle

Add to `ComboCalloutConfig`:
```dart
@Default(true) bool enableCoachEncouragement,
```

Freezed rebuild required. Old sessions without this key deserialize to `true` via `@Default`.

Add UI toggle in `combo_settings_section.dart`:
```dart
SwitchListTile(
  contentPadding: EdgeInsets.zero,
  title: Text(s.comboCoachEncouragement),
  subtitle: Text(s.comboEncouragementDescription),
  value: config.enableCoachEncouragement,
  onChanged: (v) => onChanged(config.copyWith(enableCoachEncouragement: v)),
),
```

Position: after the footwork toggle, before the pool size indicator.

**New ARB strings** (2 per locale):
```
comboCoachEncouragement: "Coach encouragement" / "Animo del coach" / "Incentivo do treinador"
comboEncouragementDescription: "Motivational cues between combos" / "Frases motivacionales entre combos" / "Frases motivacionais entre combos"
```

**Estimated**: ~12 lines UI + 1 line model + Freezed rebuild + 6 ARB entries

---

## Implementation Order

| Step | Fix | Complexity | Rationale |
|---|---|---|---|
| 1 | I1: InterjectionLibrary | Low | Pure data, no dependencies, new file |
| 2 | I5: Config toggle | Low | Freezed rebuild, simple UI addition |
| 3 | I2: Engine second stream | Medium | Core logic, depends on I1 and I5 |
| 4 | I3: VoiceService method | Low | Independent, simple addition |
| 5 | I4: Timer screen wiring | Low | Depends on I2 and I3 |

---

## Dependency Graph

```
I1 (InterjectionLibrary) ← standalone, new file
I5 (Config toggle) ← standalone, Freezed rebuild
I2 (Engine stream) ← depends on I1 (picks phrases) + I5 (reads config flag)
I3 (VoiceService) ← standalone
I4 (Timer wiring) ← depends on I2 (stream) + I3 (speak method)
```

---

## Tests to Write

### InterjectionLibrary
- All 3 locales have all 4 categories populated
- `pick()` returns non-empty string for every locale/category combination
- Random picks are within bounds (no index errors)

### Engine Interjection Logic
- With `enableCoachEncouragement: false`: zero interjections fired over 100 slots
- With encouragement enabled: interjections appear in stream (statistical test: 100 slots, at least 5 interjections)
- First 2 slots of a round: always combos, never interjections
- Category D fires exactly once per round during escalation zone
- `_escalationInterjectionFired` resets on `onWorkPhaseStart()`

### VoiceService
- `speakInterjection()` skipped when `_isSpeaking` is true
- Pitch set to 1.15 for interjections (vs 1.1 for combos, 1.0 for announcements)
- Rate set to 0.65 regardless of intensity setting

---

## Risk Register

| Risk | Severity | Mitigation |
|---|---|---|
| Interjection overlaps with combo in TTS | Medium | `_isSpeaking` guard in `speakInterjection()` skips if busy — same policy as `speakCombo()` |
| Two consecutive interjections without a combo | Low | 80-90% combo allocation + 2-slot grace period makes this statistically rare |
| Round-context fires with wrong timing on very short rounds | Medium | Suppress when escalation zone start <= round start |
| Freezed rebuild breaks persisted sessions | Low | `@Default(true)` handles null deserialize; test `ComboCalloutConfig.fromJson({})` |
| es/pt phrases feel unidiomatic | Medium | Phrases reviewed against boxing coaching vocabulary sources; native speaker spot-check recommended |
| `enableCoachEncouragement` annoying at hurricane | Low | Allocation drops to 10% at hurricane; 6-second combo-only stretches are common |
| Timer/background/audio unaffected | None | All changes in combo/voice layer only |

---

## Acceptance Criteria

### Phrase Library
- [ ] 34 phrases per locale (en/es/pt), 102 total
- [ ] 4 categories: encouragement, intensity, technique, round-context
- [ ] All phrases are 1-4 words (TTS duration < 1 second at rate 0.65)

### Engine Integration
- [ ] Interjections fire between combos at configured probability
- [ ] No interjection on first 2 callout slots of each round
- [ ] Round-context interjection fires once when entering escalation zone
- [ ] Category C (technique) never fires during escalation zone
- [ ] With `enableCoachEncouragement: false`: zero interjections
- [ ] Interjection stream is separate from combo stream

### Voice Quality
- [ ] Interjections at pitch 1.15 sound noticeably more energetic than combos (1.1)
- [ ] Fixed rate 0.65 regardless of intensity setting
- [ ] No overlap: interjection skipped if TTS is busy

### Configuration
- [ ] New "Coach encouragement" toggle in combo settings
- [ ] Toggle label and description localized in EN, ES, PT
- [ ] Default: enabled
- [ ] Existing sessions without the field work (default true)

---

## Estimated Effort

| Phase | Lines | Time |
|---|---|---|
| A: InterjectionLibrary | ~120 | 2-3 hours |
| B: Engine Integration | ~92 | 3-4 hours |
| C: Configuration | ~25 | 1 hour |
| **Total** | **~237** | **6-8 hours** |

---

## Deferred Items

| Item | Reason | Revisit Condition |
|---|---|---|
| Visual display of interjections | Showing "Good!" on screen while "1-2-3" is still visible is confusing and teaches nothing. Interjections are audio-only. | If users request visual feedback |
| "Again!" repeat with pre-recorded clip | TTS "Again, one two three" sounds robotic. Needs a pre-recorded audio asset for natural delivery. | After audio asset pipeline is established |
| Interjection analytics | Track which interjections fire and correlate with session completion rates | After history analytics feature |
| Category distribution tuning | Current 50/30/20 (A/B/C) split is research-based but may need real-user feedback | After app launch with user feedback |
