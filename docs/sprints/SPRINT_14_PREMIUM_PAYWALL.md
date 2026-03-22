# Sprint 14: Premium & Paywall Infrastructure

## Sprint Goal

Build the entitlement layer that maps IAP products to feature access, drives UI locking, and handles graceful degradation at runtime. After this sprint, the app can sell the Combo Callouts Pack ($3.99) with intermediate/advanced combos gated behind a paywall while keeping beginner combos free forever.

**Context**: The app already has `google_mobile_ads` for ads and `in_app_purchase` for a "Remove Ads" non-consumable IAP. This sprint adds a second IAP product and the infrastructure to support all 5 planned tiers from the monetization strategy.

**Core principle**: Never interrupt a workout with a paywall. The free tier must be genuinely useful. The paywall shows value before asking for money.

---

## Research Findings

### Store-Managed IAP Without Backend

Non-consumable purchases are the only IAP type that restores cleanly without auth. Post-Google Billing Client 8, consumed purchases can't be queried from billing history without an account system. The app uses no auth and no backend — non-consumables are the correct choice.

The stores (Google Play / Apple App Store) act as the identity layer. Purchase validation via `in_app_purchase` package. Local Hive cache for instant UI access. Store as source of truth.

### Graceful Degradation (Option C)

Three options were evaluated for handling users who select premium content without owning the pack:

| Option | Behavior | User Trust |
|---|---|---|
| A: Block | Show paywall, prevent starting session | Lowest — feels like ransom |
| B: Warn | Show dialog, let user decide | Medium — interrupts flow |
| **C: Degrade** | Run with beginner combos silently, nudge after session | **Highest** — never interrupts training |

**Decision: Option C.** The session runs. The user trains. After the session, a subtle nudge appears: "You trained with beginner combos. Unlock 120+ advanced combos." This matches the "never gate the timer" principle.

### Apple Requirements

App Store Review Guidelines 3.1.1 mandates:
- "Restore Purchases" button on every screen that offers a purchase
- Clear description of what each product contains
- No fake countdown timers or urgency mechanics
- Non-subscription products must be clearly labeled as one-time purchases

---

## Deliverables

### Phase A: Domain Layer

#### P1: EntitlementStatus Model

New file: `lib/features/entitlements/domain/entitlement_status.dart`

Plain Dart class (not Freezed — no code-gen overhead, no `part` file needed):

```dart
class EntitlementStatus {
  final bool adsRemoved;
  final bool comboPack;       // $3.99
  final bool programsPack;    // $4.99 (future)
  final Map<String, bool> sportPacks; // per-sport (future)
  final bool everythingBundle; // $9.99 (future)

  const EntitlementStatus({
    this.adsRemoved = false,
    this.comboPack = false,
    this.programsPack = false,
    this.sportPacks = const {},
    this.everythingBundle = false,
  });

  // Derived accessors
  bool get hasComboAccess => comboPack || everythingBundle;
  bool get hasProgramsAccess => programsPack || everythingBundle;
  bool sportPackOwned(String sportId) =>
      (sportPacks[sportId] ?? false) || everythingBundle;
  bool get hasAnyPremium =>
      adsRemoved || comboPack || programsPack ||
      sportPacks.values.any((v) => v) || everythingBundle;

  // copyWith, toJson, fromJson
  static const empty = EntitlementStatus();
}
```

**Estimated**: ~65 lines

#### P2: EntitlementConfig — Product ID Registry

New file: `lib/features/entitlements/data/entitlement_config.dart`

```dart
class EntitlementConfig {
  static const String removeAds = 'remove_ads';
  static const String comboPack = 'combo_callouts_pack';
  static const String programsPack = 'programs_pack';       // future
  static const String everythingBundle = 'everything_bundle'; // future

  static const Set<String> allProductIds = {
    removeAds,
    comboPack,
  };

  static EntitlementStatus applyPurchase(
    EntitlementStatus current, String productId,
  );
}
```

Maps product IDs to `EntitlementStatus` field mutations via switch expression. Sport packs handled via `productId.startsWith('sport_pack_')` pattern.

**Estimated**: ~45 lines

#### P3: EntitlementService

New file: `lib/features/entitlements/data/entitlement_service.dart`

- Owns Hive cache for all entitlement flags (reuses `settingsBox`)
- Subscribes to `in_app_purchase` purchase stream alongside `PurchaseService`
- Exposes `EntitlementStatus` value object
- `onStatusChanged` callback for Riverpod reactivity
- `restorePurchases()` method (triggers store restore flow)

**Compatibility**: `PurchaseService` continues unchanged — it drives `isAdFreeProvider` which the ads system already watches. Two listeners on the same broadcast stream is explicitly supported by `in_app_purchase`.

**Estimated**: ~65 lines

---

### Phase B: Provider Architecture

#### P4: Entitlement Providers

New file: `lib/features/entitlements/presentation/entitlement_provider.dart`

```dart
final entitlementServiceProvider = Provider<EntitlementService>((ref) {
  throw UnimplementedError('overridden in main()');
});

final entitlementStatusProvider = StateProvider<EntitlementStatus>((ref) {
  return EntitlementStatus.empty;
});
```

#### P5: main.dart Wiring

In `main()`:
1. Create `EntitlementService(settingsBox)`
2. Call `await entitlementService.initialize()`
3. Switch from `ProviderScope` to `UncontrolledProviderScope` with externally-created `ProviderContainer`
4. Wire `onStatusChanged` callback to update `entitlementStatusProvider`
5. Set initial state from cache

```dart
final container = ProviderContainer(overrides: [
  // ... existing overrides
  entitlementServiceProvider.overrideWithValue(entitlementService),
]);

entitlementService.onStatusChanged = () {
  container.read(entitlementStatusProvider.notifier).state =
      entitlementService.status;
};

container.read(entitlementStatusProvider.notifier).state =
    entitlementService.status;

runApp(UncontrolledProviderScope(
  container: container,
  child: const BoxingApp(),
));
```

**Estimated**: ~30 lines provider + ~20 lines main.dart

#### P6: effectiveComboConfigProvider

Add to `combo_callout_provider.dart`:

```dart
final effectiveComboConfigProvider = Provider.family<ComboCalloutConfig?, ComboCalloutConfig?>((ref, config) {
  if (config == null) return null;
  final entitlements = ref.watch(entitlementStatusProvider);
  if (entitlements.hasComboAccess) return config;
  if (config.difficulty == 'beginner') return config;
  return config.copyWith(difficulty: 'beginner');
});
```

**Integration in timer_screen.dart**: Replace `session.comboConfig!` with `ref.read(effectiveComboConfigProvider(session.comboConfig))` in `_startSession()`. Track `_wasDowngraded` flag for post-session nudge.

**Estimated**: ~15 lines new + ~15 lines modified

---

### Phase C: UI Layer

#### P7: Difficulty Selector Lock

Modify `_DifficultySelector` in `combo_settings_section.dart`:
- Convert from `StatelessWidget` to `ConsumerWidget`
- Add lock icon (`Icons.lock_outline`, 14px) to intermediate and advanced segments when pack not owned
- Tapping locked segment opens upgrade bottom sheet instead of selecting

```dart
ButtonSegment(
  value: 'intermediate',
  label: Text(s.comboDifficultyIntermediate),
  icon: hasComboAccess ? null : const Icon(Icons.lock_outline, size: 14),
),
```

Add hint text below selector when locked:
```
"Beginner is free. Unlock 120+ intermediate and advanced combos."
```

**Estimated**: ~40 lines modified + ~20 lines for lock handler

#### P8: Pool Size Indicator Enhancement

Modify `_PoolSizeIndicator` in `combo_settings_section.dart`:
- Convert from `StatelessWidget` to `ConsumerWidget`
- When user wants intermediate/advanced without pack: show `"42 combos (unlock 100+ with PRO)"`
- Normal display unchanged when pack owned or beginner selected

**Estimated**: ~20 lines modified

#### P9: Combo Pack Paywall Bottom Sheet

New file: `lib/features/entitlements/presentation/combo_pack_paywall_sheet.dart`

Material 3 bottom sheet (not full screen) with:
- Title: "Combo Callouts Pack"
- Subtitle: "Train like you have a coach"
- Feature comparison list:
  - Beginner (free): X beginner combos
  - Intermediate + Advanced: 120+ combos (locked)
  - Defense callouts (included)
  - Footwork cues (included)
- Primary button: "$3.99 — Unlock Now"
- Text button: "Restore Purchases" (MANDATORY per Apple)
- Guard: never shown if pack already owned

Triggered from:
1. Tapping locked difficulty segment
2. Post-session nudge SnackBar
3. Future: Settings screen "Upgrade" row

**Estimated**: ~120 lines

#### P10: Post-Session Upgrade Nudge

In `timer_screen.dart` after session completes:
- Check `_wasDowngraded && !entitlementStatus.hasComboAccess`
- Show `SnackBar` with "You trained with beginner combos. Unlock 120+ advanced combos." + "Upgrade" action
- SnackBar duration: 6 seconds
- "Upgrade" tap opens `ComboPackPaywallSheet`

**Estimated**: ~15 lines

---

## File Structure

```
lib/features/entitlements/
├── domain/
│   └── entitlement_status.dart          # Value object (65 lines)
├── data/
│   ├── entitlement_config.dart          # Product IDs + mapping (45 lines)
│   └── entitlement_service.dart         # Purchase stream + Hive (65 lines)
└── presentation/
    ├── entitlement_provider.dart        # Riverpod providers (30 lines)
    └── combo_pack_paywall_sheet.dart    # Bottom sheet UI (120 lines)
```

Modified files:
- `main.dart` (+20 lines)
- `combo_callout_provider.dart` (+15 lines)
- `timer_screen.dart` (+30 lines)
- `combo_settings_section.dart` (+60 lines)

---

## Implementation Order

| Step | Fix | Complexity | Rationale |
|---|---|---|---|
| 1 | P1: EntitlementStatus | Low | Pure data model, no dependencies |
| 2 | P2: EntitlementConfig | Low | Product IDs, depends on P1 |
| 3 | P3: EntitlementService | Medium | Purchase stream, depends on P1+P2 |
| 4 | P4: Providers | Low | Riverpod wiring, depends on P3 |
| 5 | P5: main.dart wiring | Medium | Container refactor, depends on P3+P4 |
| 6 | P6: effectiveComboConfig | Low | Derived provider, depends on P4 |
| 7 | P7: Difficulty lock | Medium | UI, depends on P4 |
| 8 | P8: Pool size indicator | Low | UI, depends on P4 |
| 9 | P9: Paywall sheet | Medium | UI, depends on P3+P4 |
| 10 | P10: Post-session nudge | Low | Depends on P6+P9 |

---

## Dependency Graph

```
P1 (EntitlementStatus) ← standalone
P2 (EntitlementConfig) ← depends on P1
P3 (EntitlementService) ← depends on P1, P2
P4 (Providers) ← depends on P3
P5 (main.dart) ← depends on P3, P4
P6 (effectiveComboConfig) ← depends on P4
P7 (Difficulty lock) ← depends on P4, P9
P8 (Pool indicator) ← depends on P4
P9 (Paywall sheet) ← depends on P3, P4
P10 (Post-session nudge) ← depends on P6, P9
```

---

## Tests to Write

### EntitlementStatus
- `EntitlementStatus.empty` — all fields false
- `hasComboAccess` true when `comboPack == true`
- `hasComboAccess` true when `everythingBundle == true`
- `sportPackOwned('muayThai')` works with sportPacks map
- `fromJson({})` — all fields false, no crash
- `toJson()` → `fromJson()` roundtrip

### EntitlementService
- Purchase of `combo_callouts_pack` → `comboPack == true`
- Purchase of `remove_ads` → `adsRemoved == true`
- Unknown product ID → status unchanged
- `restorePurchases()` triggers store flow
- Cache persistence: init → read from Hive → matches last saved state

### effectiveComboConfigProvider
- With `comboPack == true`: returns config unchanged
- With `comboPack == false` and `difficulty: 'advanced'`: returns `difficulty: 'beginner'`
- With `comboPack == false` and `difficulty: 'beginner'`: returns config unchanged
- With `config == null`: returns null

### UI
- Locked difficulty segment shows lock icon
- Tapping locked segment opens bottom sheet (not changes selection)
- Paywall sheet has "Restore Purchases" button
- Paywall sheet not shown when pack already owned

---

## Risk Register

| Risk | Severity | Mitigation |
|---|---|---|
| Apple rejection for missing Restore button | Critical | `ComboPackPaywallSheet` always renders Restore Purchases button |
| Purchase stream consumed by two services | Low | Broadcast stream supports multiple listeners — tested and documented |
| `isAdFreeProvider` desync from `entitlementStatus.adsRemoved` | Low | Two sources of truth for ad-free. Acceptable short-term — unify later |
| `ProviderScope` → `UncontrolledProviderScope` breaks tests | Medium | Widget tests use `ProviderScope` internally — not affected by main.dart bootstrap |
| Downgrade is silent, user notices different combos | Low | Beginner combos are the same pool they've used before. No jarring jump. |
| Post-session nudge fires too often | Medium | Add daily frequency cap via Hive timestamp if users complain (~10 lines) |
| Product not yet created in store consoles | None | Code works without store products — `allProductIds` drives query, empty result is handled |

---

## Acceptance Criteria

### Entitlement Infrastructure
- [ ] `EntitlementService` initializes from Hive cache on cold start
- [ ] Purchase of `combo_callouts_pack` → `hasComboAccess == true`
- [ ] `restorePurchases()` triggers store restore flow
- [ ] Two services on purchase stream: no conflicts, no missed events

### Graceful Degradation
- [ ] User selects advanced difficulty without pack → session runs with beginner combos
- [ ] No paywall or dialog during active session
- [ ] `_wasDowngraded` flag tracks that degradation occurred
- [ ] Post-session SnackBar shows "Unlock 120+ advanced combos"

### UI Indicators
- [ ] Lock icon on intermediate/advanced segments when pack not owned
- [ ] Tapping locked segment opens paywall sheet
- [ ] Pool indicator shows "X combos (unlock Y+ with PRO)" when relevant
- [ ] Paywall sheet has title, feature list, price button, Restore Purchases button
- [ ] Paywall sheet never shown to pack owners

### Provider Architecture
- [ ] `effectiveComboConfigProvider` downgrades difficulty when not entitled
- [ ] `entitlementStatusProvider` updates reactively on purchase
- [ ] `main.dart` wiring works with `UncontrolledProviderScope`

---

## Estimated Effort

| Phase | Lines | Time |
|---|---|---|
| A: Domain Layer | ~175 | 3-4 hours |
| B: Provider Architecture | ~80 | 2-3 hours |
| C: UI Layer | ~275 | 4-5 hours |
| **Total** | **~530** | **9-12 hours** |

---

## Monetization Product Table

| Product | Store ID | Price | What's Gated | Free Preview |
|---|---|---|---|---|
| Remove Ads (exists) | `remove_ads` | $2.99 | All ads | -- |
| **Combo Callouts Pack** | `combo_callouts_pack` | **$3.99** | Intermediate + Advanced combos | Beginner combos free forever |
| Programs Pack (future) | `programs_pack` | $4.99 | Week 2+ of guided programs | First week free |
| Sport Packs (future) | `sport_pack_{id}` | $1.99 each | Sport-specific callouts | Boxing free |
| Everything Bundle (future) | `everything_bundle` | $9.99 | All of the above | -- |

---

## Deferred Items

| Item | Reason | Revisit Condition |
|---|---|---|
| PRO badge on home screen session cards | Low signal-to-noise; most sessions don't have combos | When combo usage is > 30% of sessions |
| Settings screen "Upgrade" row | Single `ListTile` in 30 minutes when needed | When paywall sheet is polished |
| Programs Pack gate | Programs pack not yet for sale | Sprint 15+ |
| Sport Pack gates | Sport packs not yet for sale | Sprint 15+ |
| `isAdFreeProvider` consolidation | Cleanup — two sources of truth for ad-free | After launch stabilizes |
| Nudge frequency cap | Implement if users complain | After user feedback |
| Adapty integration | $10K MTR free tier with full analytics | When approaching $10K MTR |
