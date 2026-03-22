# Sprint 12: Combo Intelligence & Post-Session Engagement

## Sprint Goal

Close the remaining engine intelligence gaps and build the data infrastructure for combo engagement. After this sprint, the engine feels noticeably less repetitive, combo training data is persisted to history, users get progression nudges, and all strings are localized.

**Context**: Sprint 11 added escalation, minimum intervals, progressive difficulty, TTS overlap prevention, and voice selection. This sprint addresses what the second audit identified: combo repetition perception, data loss (combo stats not saved), hardcoded strings, and no progression feedback loop.

---

## Research Findings

### Combo Repetition: The Spotify Problem

The current engine uses single anti-repeat (avoids back-to-back same combo). With a pool of 16 beginner combos and ~20 callouts per 3-minute round at moderate intensity, the human brain reliably perceives repetition even though raw randomness looks acceptable. This is the well-documented "Spotify shuffle problem" — pure randomness never *feels* random because humans over-weight coincidences.

The proven fix across music shuffle, game enemy spawners, and card games: a **no-repeat window** (FIFO queue of recently-used items excluded from selection).

Real coaching behavior: coaches in a 3-minute pad round cycle through 4-8 distinct combos, occasionally revisiting favorites. A window of 3-5 matches this.

### Escalation Scaling Bug

Current escalation always jumps to hurricane pace (2-3s) regardless of configured intensity. A relaxed user (8-12s intervals) suddenly gets 7-10 combos in the last 20 seconds instead of 2-3. This contradicts their explicit preference.

Boxing coaching methodology (Sherdog, Boxing Science) describes end-of-round surges as *proportional* increases, not absolute maximums.

### Combo Stats Data Gap

`TrainingRecord` has 7 fields. None capture combo data. The engine's `combosFired` counter is available at session end but `historyController.addRecord()` never receives it. This data is needed for: history screen display, progression nudge logic, and future analytics.

### Progression Nudge Research

Three completed sessions at the same difficulty is the sweet spot for suggesting level-up — one session isn't enough, five is too long. The nudge should be inline on the complete screen (not a dialog), dismissable, and not fire again at the same level once dismissed.

---

## Deliverables

### Phase A: Engine Intelligence (2 fixes)

#### E1: Recency Window

**Problem**: Single anti-repeat (1 combo exclusion) still feels repetitive.

**Solution**: Replace `_lastCombo` with a FIFO queue (`ListQueue<String>` from `dart:collection`) that excludes the last N combos from selection.

| Difficulty | Window Size | Smallest Pool | Valid Choices Always Available |
|---|---|---|---|
| beginner | 3 | 8 | 5 (safe) |
| intermediate | 4 | 20 | 16 (safe) |
| advanced | 5 | 26 | 21 (safe) |

Safety clamp: `min(windowForDifficulty, pool.length - 1)`. Never blocks all picks.

**Implementation**:
- Remove `Combo? _lastCombo`
- Add `ListQueue<String> _recentIds` + `Combo? _lastFiredCombo` (kept for min interval timing)
- Add `_recencyWindowBeginner = 3`, `_recencyWindowIntermediate = 4`, `_recencyWindowAdvanced = 5`
- New `_pickCombo()`: filter pool by `!_recentIds.contains(c.id)`, fallback to full pool if empty
- New `_effectiveWindowSize()`: returns window size based on `_config.difficulty`
- Clear `_recentIds` in `configure()` and `onWorkPhaseStart()`

**Files**: `combo_callout_engine.dart` (~30 lines changed)

#### E2: Escalation Intensity Scaling

**Problem**: Escalation always uses hurricane pace (2-3s) regardless of configured intensity.

**Solution**: Escalation = one tier above configured, capped at hurricane.

| Configured Intensity | Escalation Interval |
|---|---|
| relaxed (8-12s) | moderate (5-8s) |
| moderate (5-8s) | intense (3-5s) |
| intense (3-5s) | hurricane (2-3s) |
| hurricane (2-3s) | hurricane (2-3s) |

**Implementation**:
- Remove `static const _escalationInterval = (min: 2, max: 3)`
- Add `_escalationIntensityFor(ComboIntensity)` helper method
- In `_scheduleNext()`, use `_intervals[escalationIntensity]` instead of hardcoded range

**Files**: `combo_callout_engine.dart` (~12 lines changed)

---

### Phase B: Data Infrastructure (2 fixes)

#### D1: Combo Stats Persistence

**Problem**: Combo data exists at session end but is never saved to training history.

**Solution**: Add three nullable fields to `TrainingRecord`:

```dart
int? combosCompleted,
String? comboDifficulty,
String? comboSport,
```

**Backward compatibility**: Nullable fields with no `@Default` — `json_serializable` maps missing keys to `null`. Existing Hive records deserialize cleanly. No migration needed.

**Implementation**:
- Add 3 fields to `TrainingRecord` Freezed model
- Add 3 optional params to `HistoryRepository.addRecord()` and `HistoryController.addRecord()`
- Wire both `addRecord` call sites in `timer_screen.dart` (lines 264 and 444):
  ```dart
  combosCompleted: ref.read(comboCalloutEngineProvider)?.combosFired,
  comboDifficulty: _session!.comboConfig?.difficulty,
  comboSport: _session!.comboConfig?.sport,
  ```
- Show combo count in `_RecordCard` on history screen: `"8/8 rounds · 24:00 · [mic] 18 combos"`
- Run `dart run build_runner build` for Freezed regeneration

**Files**: `training_record.dart`, `history_repository.dart`, `history_controller.dart`, `timer_screen.dart`, `history_screen.dart` (~40 lines across 5 files + generated)

#### D2: Progression Nudge

**Problem**: No feedback loop suggesting difficulty advancement.

**Solution**: Inline nudge widget on complete screen when user has completed 3+ sessions at current difficulty.

**Trigger conditions** (all must be true):
1. Session used combo callouts (`combosCompleted > 0`)
2. Session completed fully
3. Configured difficulty is not `'advanced'` (ceiling)
4. User has completed 3+ sessions at current difficulty (query `TrainingRecord` history)
5. User has not dismissed nudge for this difficulty level

**Dismiss state**: Add `dismissedProgressionNudge` field (String, default `''`) to `AppSettings`. Stores the difficulty level at which user dismissed. Reset when user moves to next level.

**UI**: Inline card on complete screen between combo row and buttons:
```
Level up?
You've completed 3 sessions at Beginner.
Ready to try Intermediate?
[Try Intermediate]  [Not yet]
```

"Try Intermediate" navigates home. "Not yet" writes dismiss state to settings.

**Implementation**:
- Add `dismissedProgressionNudge` to `AppSettings` Freezed model
- Compute nudge eligibility in `_TimerScreenState.build()` (reads history, counts sessions)
- Pass `showProgressionNudge` bool + callbacks to `_SessionCompleteView`
- Nudge widget: `Card` with amber accent, two `TextButton`s
- Run `dart run build_runner build` for AppSettings regeneration

**Files**: `app_settings.dart`, `timer_screen.dart` (~60 lines + generated)

---

### Phase C: Localization Cleanup (1 fix)

#### L1: Fix All Hardcoded Strings

**Problem**: Several combo-related strings missed in Sprint 11's localization pass.

| Location | Line | Hardcoded String | ARB Key |
|---|---|---|---|
| `timer_screen.dart` | ~636 | `'Preview Combos'` | `comboPreviewButton` |
| `timer_screen.dart` | ~636 | `'Playing...'` | `comboPreviewPlaying` |
| `timer_screen.dart` | ~1266 | `'${n} combos'` | `sessionCompleteCombos` |
| `timer_screen.dart` | ~1267 | raw difficulty string | Use existing `comboDifficultyX` keys |

**New ARB keys** (across en/es/pt):

```
comboPreviewButton: "Preview Combos" / "Vista Previa" / "Previa"
comboPreviewPlaying: "Playing..." / "Reproduciendo..." / "Reproduzindo..."
sessionCompleteCombos: "{count} combos" (parameterized, all locales)
historyRecordCombos: "{count} combos" (for history screen)
progressionNudgeTitle: "Level up?" / "Subir nivel?" / "Subir de nivel?"
progressionNudgeMessage: "You've completed {count} sessions at {level}..."
progressionNudgeCta: "Try {next}" / "Probar {next}" / "Tentar {next}"
progressionNudgeDismiss: "Not yet" / "Todavia no" / "Ainda nao"
```

**Implementation**:
- Add 7 new keys to each ARB file (21 entries total)
- Replace hardcoded strings with `S.of(context).keyName` calls
- Add `_localizedDifficulty()` helper for mapping raw difficulty to localized label
- Run `flutter gen-l10n`

**Files**: `app_en.arb`, `app_es.arb`, `app_pt.arb`, `timer_screen.dart` (~25 lines code + ~40 lines per ARB)

---

## Implementation Order

| Step | Fix | Complexity | Rationale |
|---|---|---|---|
| 1 | E1: Recency window | Low | Highest ROI engine change, independent |
| 2 | E2: Escalation scaling | Very low | 3-line behavioral fix, independent |
| 3 | D1: Combo stats persistence | Low | Data foundation, unblocks D2 |
| 4 | L1: Hardcoded strings | Low | Localization cleanup, independent |
| 5 | D2: Progression nudge | Medium | Depends on D1 data being saved |

---

## Dependency Graph

```
E1 (recency window) ← standalone
E2 (escalation scaling) ← standalone
D1 (combo stats) ← standalone
L1 (localization) ← standalone
D2 (progression nudge) ← depends on D1 (needs combo stats in history)
                       ← depends on L1 (nudge strings must be localized)
```

E1 and E2 touch the same file but different methods — can be implemented together.

---

## Tests to Write

### E1: Recency Window
- Pool of 8, window clamps to 7 — engine never picks same combo twice in 7 consecutive draws
- Pool of 1 — same combo fires every time, no crash
- `configure()` clears recency queue (old pool IDs don't carry over)
- `onWorkPhaseStart()` clears recency queue
- `_lastFiredCombo` set correctly for min interval timing

### E2: Escalation Scaling
- `relaxed` configured → escalation uses moderate range (5-8s), not (2-3s)
- `hurricane` configured → escalation stays hurricane
- `moderate` → escalation is intense (3-5s)

### D1: Combo Stats
- `TrainingRecord.fromJson({})` — all new fields null, no crash
- `addRecord` with combo params → fields stored and retrievable
- Existing records without combo fields deserialize cleanly

---

## Risk Register

| Risk | Severity | Mitigation |
|---|---|---|
| Recency window on tiny pool (2 combos) causes same-combo repeat | Low | Clamp to `pool.length - 1`, fallback to full pool |
| Freezed rebuild for TrainingRecord + AppSettings | Low | Run `dart run build_runner build`, verify both |
| Progression nudge query over large history list | Low | O(n) in-memory filter, history is already loaded |
| Dismissed nudge state persists in AppSettings Hive | None | Empty string default, backward compatible |
| Timer/background/audio unaffected | None | All changes in combo/history/UI layer |

---

## Acceptance Criteria

### Engine Intelligence
- [ ] 10 consecutive combo calls from pool of 16: no combo appears more than once in any 3-combo window
- [ ] Relaxed session escalation zone: intervals are 5-8s (moderate), not 2-3s
- [ ] Hurricane session escalation: stays at 2-3s (unchanged)

### Data Infrastructure
- [ ] Training history records include combosCompleted, comboDifficulty, comboSport
- [ ] History screen shows combo count on records that have it
- [ ] Existing records without combo data display normally (no crash)

### Progression Nudge
- [ ] After 3 completed beginner sessions: "Level up?" nudge appears on complete screen
- [ ] Tapping "Not yet" suppresses nudge until difficulty changes
- [ ] No nudge at advanced difficulty (ceiling)
- [ ] No nudge on first combo session ever

### Localization
- [ ] All combo strings display correctly in EN, ES, PT
- [ ] "Preview Combos" and complete screen combo row are localized
- [ ] Progression nudge text is localized in all 3 languages

---

## Estimated Effort

| Phase | Lines | Time |
|---|---|---|
| A: Engine Intelligence | ~42 | 2-3 hours |
| B: Data Infrastructure | ~100 | 4-5 hours |
| C: Localization | ~65 | 1-2 hours |
| **Total** | **~207** | **7-10 hours** |

---

## Deferred Items

| Item | Reason | Revisit Condition |
|---|---|---|
| "Again!" repeat logic | Random "Again!" without performance context feels like a bug 80% of the time. TTS delivery is robotic. | After drill mode or pre-recorded "Again!" asset |
| Weighted combo selection | Already solved by pool curation (difficulty filter) and combo-length minimum interval (implicit time-based weighting) | If combo library grows beyond 300+ and balance becomes an issue |
| Personal best announcement | Requires history query on complete screen; nice-to-have | After D1 combo stats are shipped and validated |
| Unique combo count tracking | `_usedComboIds` Set in engine, `combosUnique` field in TrainingRecord | After D1, if users request variety metrics |
