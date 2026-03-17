# Design System — Boxing Timer App

## Brand Identity

**App Name**: Boxing
**Tagline**: The timer that never stops.
**Personality**: Raw, disciplined, reliable. Not flashy — functional. Built for fighters, not fitness tourists.

---

## Color System

### Brand Palette

| Token | Hex | Usage |
|-------|-----|-------|
| `brandRed` | `#E53935` | Primary accent — buttons, FAB, active selections, app icon |
| `brandRedDark` | `#C62828` | Pressed/active state of brand elements |
| `brandGold` | `#FFB300` | Achievement, completion, premium features, app icon bell |

### Dark Surface System (True Black for OLED)

Timer apps don't scroll — OLED smearing is irrelevant. True black saves battery on Samsung (the #1 complaint device) and maximizes contrast for phase colors.

| Token | Hex | Usage |
|-------|-----|-------|
| `background` | `#000000` | Timer screen, scaffold base — OLED off, max contrast |
| `cardSurface` | `#111111` | Session cards on home screen — slight lift |
| `raisedSurface` | `#1A1A1A` | Elevated cards, modals, bottom sheets |
| `divider` | `#2A2A2A` | Subtle borders, dividers |
| `ringTrack` | `#222222` | Progress ring background track |

### Phase Colors (Semantic — Timer-Specific)

These colors carry functional meaning during workouts. They are NOT part of the brand palette — they exist to communicate timer state at a glance from across a gym.

Calibrated for a `#000000` background with sufficient contrast while avoiding eye strain. Based on the traffic-light mental model ("go/caution/stop") used universally across competing boxing timer apps.

| Phase | Color | Hex | Rationale |
|-------|-------|-----|-----------|
| Work | Green | `#00C853` | "Go" signal — Material Green A700, vibrant, readable |
| Warning | Amber | `#FFB300` | "Caution" — Amber 700, punchy without being yellow |
| Rest | Red | `#E53935` | "Stop" — Red 600, authoritative but not alarming |
| Warmup | Blue | `#1E88E5` | "Prepare" — Blue 600, calm and preparatory |
| Complete | Blue-grey | `#B0BEC5` | Neutral cooldown |
| Idle | Gray | `#9E9E9E` | Standby — nothing happening |
| Paused | Dark Gray | `#757575` | Suspended — muted, dimmed |

### Phase Background Tints

During active timer, the scaffold background takes a subtle tint of the current phase color at **10% opacity** over `#000000`. This provides ambient phase awareness without the jarring "the whole screen turned color" effect. The user knows at a glance what phase they are in without reading the label.

| Phase | Tint | Hex (10% over black) |
|-------|------|---------------------|
| Work | Green | `#1A00C853` |
| Warning | Amber | `#1AFFB300` |
| Rest | Red | `#1AE53935` |
| Warmup | Blue | `#1A1E88E5` |

### Session Category Colors

Color-coded accent dots on session cards for quick visual identification:

| Category | Color | Hex | Sessions |
|----------|-------|-----|----------|
| Boxing | Green | `#00C853` | Pro Boxing, Amateur, Sparring |
| Bag Work | Deep Orange | `#FF6D00` | Heavy Bag, Speed Bag |
| Conditioning | Red | `#E53935` | Tabata, EMOM, Conditioning |
| Combat Sports | Purple | `#7E57C2` | Muay Thai, MMA, Kickboxing |
| Beginner | Blue | `#1E88E5` | Beginner, Youth Boxing |
| Custom | Amber | `#FFB300` | User-created sessions |

### Text Opacity Scale

| Level | Alpha | Usage |
|-------|-------|-------|
| Primary | 1.0 | Timer digits, phase labels, primary actions |
| High | 0.87 | Titles, headings, important labels |
| Medium | 0.60 | Body text, secondary information |
| Subtle | 0.40 | Hints, placeholders, tertiary info |
| Disabled | 0.30 | Disabled controls, inactive elements |

---

## Typography

### Font Strategy: Bundled Assets (Not Runtime Fetch)

All fonts are **bundled as assets** in `assets/fonts/`, not fetched at runtime via the `google_fonts` package network call. The countdown font is the most critical visual element — it must render correctly on frame one. A timer that opens and shows the wrong font for 200ms, even once, undercuts the "reliable" positioning.

Configuration: `GoogleFonts.config.allowRuntimeFetching = false` in `main.dart`. The `google_fonts` package API calls continue unchanged — they auto-detect bundled files by filename.

### Type Scale

Three font roles — all free, open-source, bundled locally:

| Role | Font | Weight | Usage | Why This Font |
|------|------|--------|-------|---------------|
| **Display** | Roboto Condensed | Bold (700) | Timer countdown digits — the hero element | The ONLY free font where `FontFeature.tabularFigures()` actually works. No layout shift between "1:08" and "0:59". Reads from 2+ meters. Pre-installed on Android = zero-ms render. |
| **Heading** | Teko | SemiBold (600) | Phase labels, round indicators, section headers | Square condensed proportions = scoreboard feel. Industrial, squared. |
| **Body** | Barlow Condensed | Regular/Medium (400/500) | Session names, settings, navigation, form labels | Designed for data-dense interfaces. Highway signage heritage = functional clarity. |

### Critical Note: Why Not Bebas Neue for Countdown

The free Bebas Neue on Google Fonts **does not include the `tnum` OpenType table**. `FontFeature.tabularFigures()` silently does nothing. Digits "1" through "0" render at natural proportional widths — the "1" is narrower than "8". At 96sp, the countdown text block shifts horizontally every time a digit changes. This is visually jarring and unprofessional.

Bebas Neue remains available for secondary display text (session names, marketing) where digit layout shift is not an issue.

### Premium Fonts Evaluated (Not Needed for MVP)

| Font | Foundry | Price | Why Skipped |
|------|---------|-------|-------------|
| Knockout | Hoefler & Co | $169+ | Literally named after boxing, gorgeous — but no free equivalent close enough |
| DIN 2014 | Fontwerk | $200+ | Industrial scoreboard perfection — more "autobahn" than "boxing gym" |
| Bebas Neue Pro | Dharma Type | ~$35-50 | Fixes the `tnum` problem but adds procurement overhead |

### Specific Sizes

| Element | Font | Size | Weight | Letter Spacing | Notes |
|---------|------|------|--------|----------------|-------|
| Main countdown | Roboto Condensed | 96sp | 700 | 2px | Tabular figures enabled, works correctly |
| Phase label | Teko | 32sp | 600 | 3px | Uppercase |
| Round indicator | Teko | 24sp | 500 | 2px | Uppercase |
| Session name (list) | Barlow Condensed | 18sp | 500 | 0 | Title case |
| Body text | Barlow Condensed | 16sp | 400 | 0 | |
| Button text | Barlow Condensed | 18sp | 600 | 1px | Uppercase |
| Summary label | Barlow Condensed | 18sp | 400 | 0 | |
| Elapsed time | Barlow Condensed | 14sp | 400 | 0 | 40% opacity |

### Bundled Font Files

Located in `assets/fonts/`:

| File | Size | Role |
|------|------|------|
| `RobotoCondensed-Bold.ttf` | ~160KB | Timer countdown digits |
| `Teko-Medium.ttf` | ~80KB | Round indicators |
| `Teko-SemiBold.ttf` | ~80KB | Phase labels, headings |
| `BarlowCondensed-Regular.ttf` | ~50KB | Body text |
| `BarlowCondensed-Medium.ttf` | ~50KB | Session names |
| `BarlowCondensed-SemiBold.ttf` | ~50KB | Buttons, labels |
| `BarlowCondensed-Bold.ttf` | ~50KB | Emphasis |

Total: ~520KB — trivial addition to APK.

---

## Spacing & Dimensions

### Spacing Scale (4px base)

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Micro gaps (between text lines) |
| `sm` | 8px | Small gaps (list items, icon padding) |
| `md` | 16px | Standard padding (screen edges, cards, forms) |
| `lg` | 24px | Large gaps (section separators, widget spacing) |
| `xl` | 32px | Extra large (screen padding on detail views) |
| `xxl` | 48px | Maximum spacing (completion screen) |

### Component Dimensions

| Component | Size | Notes |
|-----------|------|-------|
| Progress ring | 280 x 280px | Circular progress around countdown |
| Progress ring stroke | 12px | Round caps, thicker for glanceability |
| Ring background track | `#222222` | Barely visible ghost ring |
| Pause button | 80 x 80px | Center control — glove-friendly |
| Skip buttons | 64 x 64px | Side controls — glove-friendly |
| Session card height | ~72px | Card content + 16px padding |
| FAB | 56px (default) | Material 3 standard |
| Start button | 80px height, full width | Session summary CTA |
| Bottom action buttons | 64px height, full width | REPEAT, DONE on complete screen |
| Card border radius | 12px | Consistent across all cards |
| App bar height | 56px (default) | Material 3 standard |
| Min touch target | 48dp | WCAG minimum |
| Glove-safe touch target | 64dp+ | Boxing-specific minimum |

---

## Timer Display Design

### Progress Ring Specification

- **Style**: Solid color (NOT gradient) — the phase color IS the information
- **Thickness**: 12dp — thick enough to be glanceable, not dominant
- **Background track**: `#222222` — barely visible ghost ring
- **Cap style**: Round (`StrokeCap.round`) — modern, not harsh
- **Direction**: Clockwise depletion (full at top, empties rightward)
- **Animation**: Direct repaint from timer tick, no interpolated tween

### Phase Transitions

**Immediate color switch, not fade.** The gym clock bell rings — there is no gentle crossfade. The abruptness is functional: it signals the phase change clearly to peripheral vision.

Optional: single-frame white flash overlay at 30% opacity for one frame (16ms) at transition, creating a subliminal "bell flash" effect.

### Last 10 Seconds (Warning)

**Do NOT animate or pulse the digits.** The user is mid-punch, 2 meters from the phone, needing to glance for a half-second. Any animation adds processing load to that read. The warning signal is:
1. Audio: the clapper bell sound
2. Color: amber phase color transition
3. Visual: progress ring can pulse at 0.5s intervals (peripheral vision-friendly)

### Session Complete Screen

Boxing-appropriate, not generic fitness confetti:
- Black background
- Total time elapsed in large digits
- "SESSION COMPLETE" in all-caps condensed at 48sp
- Subtle radial pulse animation (1 second, then idle)
- Prominent "Done" button and secondary "Go Again" button

---

## Icon System

### Style

- **Material Icons** (built-in) for all functional icons
- **Rounded** variant preferred for controls (`Icons.play_arrow_rounded`, `Icons.pause_rounded`)
- **Outline** variant for navigation and secondary actions (`Icons.settings`, `Icons.arrow_back`)

### Icon Inventory

| Context | Icon | Size | Notes |
|---------|------|------|-------|
| Play/Resume | `Icons.play_arrow_rounded` | 40dp (50% of button) | Filled button |
| Pause | `Icons.pause_rounded` | 40dp | Filled button |
| Skip Next | `Icons.skip_next_rounded` | 32dp | Outlined button |
| Skip Previous | `Icons.skip_previous_rounded` | 32dp | Outlined button |
| Close/Stop | `Icons.close` | 28dp | Top-left corner |
| Settings | `Icons.settings` | 24dp | App bar action |
| Back | `Icons.arrow_back` | 24dp | App bar leading |
| Add Session | `Icons.add` | 24dp | FAB |
| Edit | `Icons.edit` | 24dp | Bottom sheet action |
| Duplicate | `Icons.copy` | 24dp | Bottom sheet action |
| Delete | `Icons.delete` | 24dp | Bottom sheet (red) |
| Custom Session | `Icons.person` | 20dp | Session card badge |
| Complete | `Icons.check_circle_outline` | 96dp | Completion screen |
| Rounds +/- | `Icons.add_circle_outline` / `Icons.remove_circle_outline` | 24dp | Stepper |
| Chevron | `Icons.chevron_right` | 24dp | Settings navigation |

### No Custom Icons Needed for MVP

The Material Icons set covers all functional requirements. Custom boxing-specific icons (gloves, heavy bag, bell) are reserved for:
1. App launcher icon (Phase 1)
2. Marketing materials (Phase 2)
3. Empty-state illustrations (Phase 2)

---

## Layout Patterns

### Timer Screen (Active Workout)

```
+------------------------------+
| [X]                          |  <- Close button, top-left
|                              |
|       ROUND 3 / 8           |  <- Teko 24sp, white 87%
|                              |
|    +--------------------+    |
|    |                    |    |
|    |      2:47          |    |  <- Roboto Condensed Bold 96sp, phase color
|    |                    |    |
|    +--------------------+    |  <- 280px progress ring, 12dp stroke, phase color
|                              |
|          WORK                |  <- Teko 32sp, phase color
|                              |
|   [<<]    [||]    [>>]       |  <- 64dp / 80dp / 64dp circles
|                              |
|    Total: 12:33 elapsed      |  <- Barlow 14sp, white 40%
+------------------------------+

Background: #000000 + phase color @ 10% opacity
Ring track: #222222
```

### Session List (Home)

```
+------------------------------+
| Boxing Timer        [gear]   |  <- App bar
|------------------------------|
| QUICK START                  |  <- 3 recently used, horizontal scroll
| [Heavy Bag] [Pro] [Shadow]   |
|                              |
| PRESETS                      |  <- Full list, grouped
| +---------------------------+|
| |[*] Pro Boxing (Men) 8rds >||  <- [*] = category color dot
| +---------------------------+|
| |[*] Heavy Bag       8rds >||
| +---------------------------+|
|                              |
| MY SESSIONS                  |
| +---------------------------+|
| |[*] Custom Workout  4rds >||
| +---------------------------+|
|                         [+]  |  <- FAB
+------------------------------+

Background: #000000
Cards: #111111, 12px radius
```

### Session Card Content

```
+-------------------------------------------+
|  [*] Heavy Bag                      8 rds |
|       3:00 work . 1:00 rest . 32 min      |
+-------------------------------------------+
```

- Left accent dot in category color
- Session name in 18sp medium weight
- Round count right-aligned
- Duration summary in 13sp secondary text

---

## Dark Mode Priority

Dark theme is the **primary** theme. Light theme exists for accessibility but is secondary.

**Rationale:**
- Gym environments have poor contrast for light screens
- OLED battery savings on Samsung (dominant Android brand)
- Every serious boxing app ships dark-first
- Timer digits and phase colors pop against dark backgrounds
- True black (#000000) with OLED = pixels off = max battery, max contrast

---

## Accessibility

| Requirement | Implementation |
|-------------|---------------|
| WCAG AA contrast (4.5:1 min) | White text on `#000000` = 21:1 ratio |
| Large text contrast (3:1 min) | Phase colors on `#000000` all pass |
| Touch targets | 64-80dp for timer controls (exceeds 48dp minimum) |
| Semantic labels | All icon buttons have `Semantics(label:)` |
| Screen reader | Timer state announced via label updates |
| Reduced motion | No gratuitous animation; phase changes are immediate |
| Color blindness | Phase identity reinforced by text labels ("WORK", "REST"), not color alone |
