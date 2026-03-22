# Sprint 11: Combo Premium — From Timer Feature to Coach Experience

## Sprint Goal

Transform the combo callout system from a "random number generator with good timing" into a coaching experience worth paying for. Three areas: engine intelligence (make it feel coached), voice quality (make it sound coached), and UX visibility (make the feature discoverable, prominent, and trackable).

**Context**: Market research confirmed people pay $3.99-$9.99 for combo callout apps (Shadow Boxing App, Heavy Bag Pro, Precision Boxing Coach). The value isn't "configurations" — it's "the feeling of not training alone." Our engine and library are 70% there; this sprint closes the gap.

---

## Research Findings

### Market Validation

| App | Price | Stars | What Users Say |
|-----|-------|-------|----------------|
| Shadow Boxing App | $9.99/month | 4.9 (2,705) | "Like having a one-to-one boxing trainer" |
| Heavy Bag Pro | Subscription | 4.9 (63K users) | "Almost as good as having an instructor with you" |
| Precision Boxing Coach | $4.99 one-time | 4.5 | "Great boxing trainer app, worth the investment for solo training" |
| Boxing Coach Workout Timer | $2.99 | 4.5 (582) | "Virtual trainer calling out keeps my mind active and engaged" |

### What Makes Users Pay vs Delete

**Pay**: Timing variation, end-of-round push, defense cues mixed in, progressive difficulty, first session demonstrates value before paywall.

**Delete**: Robotic voice, constant metronome cadence, random combos with no logic, silence at round end, combos cut off mid-word at high intensity.

### Current Engine Audit (Pre-Sprint)

| Criterion | Rating | Gap |
|-----------|--------|-----|
| Timing variation | GOOD | Random intervals within bands (3-12s) |
| End-of-round escalation | **MISSING** | Last ~15s goes SILENT. Coach pushes hardest here. |
| Combo selection intelligence | BASIC | Only avoids back-to-back repeats. No recency, weighting, or sequencing. |
| Pacing by combo length | **MISSING** | 7-technique combo at hurricane (2-3s) is physically impossible. |
| Segment awareness | GOOD | Per-segment combo pools work correctly. |
| Defense/footwork callouts | GOOD | 20 cues, toggleable, mixed naturally. |
| Cumulative difficulty | **MISSING** | Round 1 = Round 8. No training arc. |
| TTS overlap prevention | **MISSING** | Hurricane mode cuts off combos mid-word. |
| Voice quality | 5/10 | Flat pitch, no voice selection, GPS-like. |
| Body shot TTS | **BROKEN** | "2b" spoken as "two bee" instead of "two body". |
| Combo visibility on cards | **MISSING** | No icon showing which sessions have combos. |
| Combo display size | 5/10 | 18sp badges unreadable from 2m. |
| Combo preview | **MISSING** | No way to hear combos before starting. |
| Post-session combo stats | **MISSING** | Zero combo feedback after workout. |
| Combo settings position | Poor | Buried at position 9/10 in editor. |
| Combo settings i18n | **MISSING** | Hardcoded English strings. |

---

## Deliverables

### Phase A: Engine Intelligence (3 fixes)

#### E1: Combo-Length Minimum Intervals
**Problem**: A 7-technique combo at hurricane (2-3s) is physically impossible to execute.

**Solution**: Add minimum interval floor: `1.5s base + 0.5s per technique beyond 2`.

| Combo Length | Min Interval | Hurricane Still Feels Fast? |
|-------------|-------------|---------------------------|
| 2 techniques | 1.5s | Yes (hurricane max = 3s) |
| 3 techniques | 2.0s | Yes |
| 5 techniques | 3.0s | Yes, but breathable |
| 7 techniques | 4.0s | Slowed, but executable |

**Implementation**:
- Add `_minIntervalForCombo(Combo)` helper in `combo_callout_engine.dart`
- Apply floor in `_scheduleNext()` after combo fires: `max(randomInterval, minInterval)`
- ~10 lines changed

**Files**: `combo_callout_engine.dart`

#### E2: End-of-Round Escalation
**Problem**: Engine goes SILENT in last ~15s. Real coaches push hardest here.

**Solution**: Add 20-second escalation zone before the warning buffer. Intervals compress to hurricane pace (2-3s).

```
Round timeline (3:00, 10s warning):
0:00 ─── normal intensity ─── 2:27 ── ESCALATION (20s) ── 2:47 ── SILENCE (13s) ── 3:00
                                      (hurricane pace)          (warning bell zone)
```

**Implementation**:
- Add `_escalationZoneSec = 20` and `_escalationInterval = (min: 2, max: 3)` constants
- In `_scheduleNext()`, detect escalation zone: `remaining <= bufferThreshold + escalationZone && remaining > bufferThreshold`
- Use escalation intervals when in zone, normal intervals otherwise
- Automatic, not configurable. Short rounds naturally have shorter/no escalation.
- ~15 lines changed

**Files**: `combo_callout_engine.dart`

#### E3: Round-Over-Round Difficulty Progression
**Problem**: Round 1 and round 8 use the exact same pool. No training arc.

**Solution**: User's difficulty setting = ceiling. Engine progressively unlocks difficulty tiers across the session.

| Session Third | Pool (if user picks "advanced") |
|---|---|
| First third | Beginner only |
| Middle third | Beginner + Intermediate |
| Final third | Beginner + Intermediate + Advanced |

**Formula**: `fraction = (currentRound - 1) / (totalRounds - 1)` → map to difficulty tier.

**Special cases**:
- 1 round: use full configured difficulty
- User picks "beginner": stays beginner throughout (ceiling can't escalate beyond setting)

**Implementation**:
- Add `setRoundContext(currentRound, totalRounds)` to engine
- Add static `progressiveDifficulty(round, total, configuredMax)` method
- In `_driveComboEngine()` (timer_screen.dart), rebuild pool with effective difficulty on each round transition
- ~70 lines across 2 files

**Files**: `combo_callout_engine.dart`, `timer_screen.dart`

**Dependencies**: E1 (min intervals prevent beginner-only combos from being squished), E2 (escalation draws from progressive pool)

---

### Phase B: Voice Quality (3 fixes)

#### V1: Body Shot TTS Fix
**Problem**: "2b" spoken as "two bee" instead of "two body".

**Solution**: In `ttsTextForStyle` numbers branch, detect `endsWith('b') && length == 2`, replace with `"${digit} body"`. Locale-aware: en=body, es=cuerpo, pt=corpo.

**Affected IDs**: `1b`, `2b`, `3b`, `4b`, `5b`, `6b`

**Files**: `combo_model.dart` (~10 lines)

#### V2: TTS Overlap Prevention
**Problem**: Hurricane intensity cuts off combos mid-word via `_tts.stop()` before each `speak()`.

**Solution**: Add `_isSpeaking` flag + completion/error/cancel handlers in VoiceService. Skip (not queue) combos that arrive while speaking. 5s timeout fallback for flaky Android TTS engines.

**Design decision**: Skip, not queue. Queuing creates backlogs that fire rapid-fire. Skipping is natural — real coaches occasionally overlap.

**Key behaviors**:
- `speakCombo()`: if `_isSpeaking`, skip silently (visual display still updates)
- `announce()` (phase announcements): always interrupt — higher priority than combos
- Timeout: 5s safety reset for devices where completion handler doesn't fire

**Files**: `voice_service.dart` (~30 lines)

#### V3: Voice Selection & Pitch
**Problem**: Default system voice with flat pitch 1.0. Sounds like GPS.

**Solution**:
- Call `getVoices()` at init, score by quality (enhanced/neural +10), locale match (+2)
- Set pitch 1.1 for combos (urgency), 1.0 for announcements (neutral)
- Graceful fallback if voice selection fails

**Motivational interjections** ("Let's go!", "Again!", "Good!"): Designed but **deferred** until V2/V3 are stable. Architecture: 15% random chance per callout, separate pitch (1.15), audio-only (no visual).

**Files**: `voice_service.dart` (~60 lines)

---

### Phase C: UX Visibility (6 fixes)

#### U1: Session Card Combo Badge
**Problem**: No indicator showing which sessions have combos.

**Solution**: `Icons.record_voice_over` (16px, amber) on session cards when `session.comboConfig?.enabled == true`. Apply to both `_SessionCard` and `_QuickStartCard`.

**Files**: `session_list_screen.dart`

#### U2: Prominent Combo Display
**Problem**: 18sp badges unreadable from 2m.

**Solution**: Two-line stacked display:
- Line 1: Combo notation at 28sp bold monospace ("1-2-3")
- Line 2: Technique names at 14sp muted ("Jab, Cross, Hook")
- Scale-pulse animation (1.0→1.08→1.0, 300ms) on new combo

**Files**: `combo_display_widget.dart`

#### U3: Combo Preview Button
**Problem**: Can't hear combos before starting.

**Solution**: "Preview Combos" button on session summary screen. Picks 3 random combos, speaks with 2s gaps. Cancel-able. Disabled during playback.

**Files**: `timer_screen.dart` (_SessionSummaryView)

#### U4: Move Combo Settings Higher
**Problem**: Buried at position 9/10.

**Solution**: Move to after rest duration (position 5/10). 5 lines of code moved.

**Files**: `session_editor_screen.dart`

#### U5: Post-Session Combo Stats
**Problem**: Zero combo feedback after workout.

**Solution**:
- Add `_combosFired` counter to engine, increment in `_fireCombo()`
- Display on complete screen: "24 combos called · Boxing · Beginner"
- Difficulty nudge: "Ready for Intermediate?" after sessions at beginner
- Save to TrainingRecord for history

**Files**: `combo_callout_engine.dart`, `timer_screen.dart`, `training_record.dart`, `history_repository.dart`, `history_screen.dart`

#### U6: Localize Combo Settings
**Problem**: All labels hardcoded English.

**Solution**: Wire 18 existing ARB keys + add 15 new keys across EN/ES/PT. Run `flutter gen-l10n`.

**Files**: `combo_settings_section.dart`, `app_en.arb`, `app_es.arb`, `app_pt.arb`

---

## Implementation Order

| Step | Fix | Complexity | Rationale |
|------|-----|-----------|-----------|
| 1 | V1: Body shot TTS | Trivial | Fix broken experience |
| 2 | E1: Min intervals | Low | Prevent impossible combos |
| 3 | V2: TTS overlap | Low-Med | Stop mid-word cutoffs |
| 4 | E2: Escalation | Low | Make rounds feel coached |
| 5 | U1: Card badge | Low | Make combos visible |
| 6 | U4: Move settings | Low | Discoverability |
| 7 | U2: Combo display | Medium | Workout visual impact |
| 8 | V3: Voice selection | Medium | Better voice quality |
| 9 | E3: Round progression | Medium | Training arc |
| 10 | U3: Preview button | Medium | Try before you buy |
| 11 | U5: Combo stats | High | Engagement + progression |
| 12 | U6: Localization | Medium | Correctness for ES/PT |

---

## Dependency Graph

```
V1 (body shot) ← standalone
E1 (min intervals) ← standalone
V2 (overlap) ← standalone
E2 (escalation) ← uses E1's floor for long combos
U1 (card badge) ← standalone
U4 (move settings) ← standalone
U2 (combo display) ← standalone
V3 (voice selection) ← depends on V2 (completion handlers)
E3 (progression) ← depends on E1 (floor), changes pool that E2 draws from
U3 (preview) ← depends on V2 (speaking state)
U5 (combo stats) ← depends on engine counter, touches history model
U6 (localization) ← standalone, do last
```

---

## Risk Register

| Risk | Severity | Mitigation |
|------|----------|------------|
| TTS completion handler doesn't fire on some Android TTS engines | Medium | 5s timeout fallback resets `_isSpeaking` |
| `getVoices()` returns empty on some devices | Low | Guard clause, fall back to default voice |
| Escalation zone on very short rounds (30s) | Low | Naturally shrinks/disappears; no special casing |
| Min interval floor reduces perceived intensity for advanced-only sessions | Low | Acceptable — alternative (impossible combos) is worse |
| freezed rebuild for TrainingRecord | Low | Run `dart run build_runner build` before dependent code |
| Long translated strings overflow SegmentedButton | Low | Test with ES locale, add ellipsis overflow |
| Timer/background/audio guarantees affected | **None** | All changes in combo/voice/UI layer only |

---

## Acceptance Criteria

### Engine Intelligence
- [ ] Hurricane intensity with 7-technique combos: minimum 4s between calls
- [ ] Last 25s of each round: combo frequency increases to hurricane pace
- [ ] Last 13s: silence (warning bell zone preserved)
- [ ] Round 1 of a 9-round advanced session: beginner combos only
- [ ] Round 9: full advanced pool available
- [ ] Single-round sessions: use full configured difficulty

### Voice Quality
- [ ] "2b" spoken as "two body" (en), "two cuerpo" (es), "two corpo" (pt)
- [ ] Hurricane session with advanced combos: no mid-word cutoffs
- [ ] Phase announcements always interrupt combo speech
- [ ] Voice sounds noticeably better than default on iOS and Pixel
- [ ] Pitch difference audible between combos (1.1) and announcements (1.0)

### UX Visibility
- [ ] Session cards show amber voice icon when combos enabled
- [ ] Combo display readable from 2m on a 5.5" phone (28sp+)
- [ ] New combo fires with visible scale-pulse animation
- [ ] Both number and name format shown simultaneously
- [ ] Preview button on summary screen plays 3 combos with 2s gaps
- [ ] Combo settings appear after rest duration in editor (position 5)
- [ ] Session complete shows "X combos called · Sport · Difficulty"
- [ ] All combo settings labels display correctly in EN, ES, PT

---

## Monetization Context

This sprint does NOT implement paywalls. It makes the free experience good enough that paywalls become viable in a future sprint. The research-backed monetization plan:

| Product | Price | What's Gated | Free Preview |
|---------|-------|-------------|--------------|
| Remove Ads (exists) | $2.99 | All ads | — |
| Combo Callouts Pack | $3.99 | Intermediate + Advanced combos | Beginner combos free forever |
| Programs Pack | $4.99 | Week 2+ of guided programs | First week free |
| Sport Packs (MT/MMA/BJJ/Wrestling) | $1.99 each / $5.99 bundle | Sport-specific callouts | Boxing free |
| Everything Bundle | $9.99 | All of the above | — |

**Model**: Non-consumable only (no subscriptions). Restore works without backend via Google Play / App Store. Adapty recommended over RevenueCat for free-tier analytics.

**Key rules**: Never gate the timer. Never gate anything currently free. Never show paywall during active training. Free preview must demonstrate value before asking for money.
