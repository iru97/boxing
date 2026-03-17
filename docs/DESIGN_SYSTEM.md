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
| `brandGold` | `#FFC107` | Achievement, completion, premium features |
| `darkBackground` | `#121212` | Scaffold background (Material Design dark baseline) |
| `darkSurface` | `#1E1E1E` | Cards, bottom sheets, dialogs |
| `darkSurfaceElevated` | `#2C2C2C` | Elevated surfaces (FAB background, pressed cards) |
| `darkBorder` | `#333333` | Subtle borders, dividers |

### Phase Colors (Semantic — Timer-Specific)

These colors carry functional meaning during workouts. They are NOT part of the brand palette — they exist to communicate timer state at a glance from across a gym.

| Phase | Color | Hex | Rationale |
|-------|-------|-----|-----------|
| Work | Green | `#4CAF50` | "Go" signal — universally understood |
| Warning | Amber | `#FF9800` | "Caution" — heart rate rising, time running out |
| Rest | Red | `#F44336` | "Stop" — recovery, breathe |
| Warmup | Blue | `#2196F3` | "Cool" — preparation, not yet active |
| Complete | White | `#FFFFFF` | Neutral — session finished |
| Idle | Gray | `#9E9E9E` | Standby — nothing happening |
| Paused | Dark Gray | `#757575` | Suspended — muted, dimmed |

### Phase Background Tint

During active timer, the scaffold background takes a subtle tint of the current phase color at **8% opacity** over `#121212`. This makes phase changes visible in peripheral vision without overwhelming the dark aesthetic.

```
Work background:    #121212 + #4CAF50 @ 8%
Warning background: #121212 + #FF9800 @ 8%
Rest background:    #121212 + #F44336 @ 8%
```

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

### Type Scale

Three font roles using Google Fonts (all free, open-source, Flutter-compatible):

| Role | Font | Weight | Usage |
|------|------|--------|-------|
| **Display** | Bebas Neue | Regular (400) | Timer countdown digits — the hero element. All-caps, condensed, fight-poster energy. |
| **Heading** | Teko | SemiBold (600) | Phase labels, round indicators, section headers. Industrial, squared, scoreboard feel. |
| **Body** | Barlow Condensed | Regular/Medium (400/500) | Session names, settings, navigation, form labels. Clean, functional, 18 weights. |

### Specific Sizes

| Element | Font | Size | Weight | Letter Spacing | Notes |
|---------|------|------|--------|----------------|-------|
| Main countdown | Bebas Neue | 96sp | 400 | 2px | Tabular figures enabled |
| Phase label | Teko | 32sp | 600 | 3px | Uppercase |
| Round indicator | Teko | 24sp | 500 | 2px | Uppercase |
| Session name (list) | Barlow Condensed | 18sp | 500 | 0 | Title case |
| Body text | Barlow Condensed | 16sp | 400 | 0 | |
| Button text | Barlow Condensed | 18sp | 600 | 1px | Uppercase |
| Summary label | Barlow Condensed | 18sp | 400 | 0 | |
| Elapsed time | Barlow Condensed | 14sp | 400 | 0 | 40% opacity |

### Why These Fonts?

- **Bebas Neue**: The most recognized athletic display font. Its all-caps condensed form creates fight-poster energy at 96sp. Reads clearly from 3+ meters — gym-ready.
- **Teko**: Industrial squared proportions complement Bebas Neue without competing. Handles mixed-case labels better than Bebas. Scoreboard DNA.
- **Barlow Condensed**: Designed for data-dense interfaces. 18 weights available. California infrastructure origin gives it functional authority. Highly legible at small sizes on mobile.

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
| Progress ring stroke | 10px | Round caps |
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
|    ╭──────────────────╮      |
|    │                  │      |
|    │      2:47        │      |  <- Bebas Neue 96sp, phase color
|    │                  │      |
|    ╰──────────────────╯      |  <- 280px progress ring, phase color
|                              |
|          WORK                |  <- Teko 32sp, phase color
|                              |
|   [<<]    [||]    [>>]       |  <- 64dp / 80dp / 64dp circles
|                              |
|    Total: 12:33 elapsed      |  <- Barlow 14sp, white 40%
+------------------------------+

Background: #121212 + phase color @ 8% opacity
```

### Session List (Home)

```
+------------------------------+
| Boxing Timer        [gear]   |  <- App bar
|------------------------------|
| MY SESSIONS                  |  <- Teko 16sp, brand red
| +---------------------------+|
| | Heavy Bag Custom    12:00 >||  <- Card with play arrow
| +---------------------------+|
| +---------------------------+|
| | Speed Work          8:00  >||
| +---------------------------+|
|                              |
| QUICK START                  |  <- Teko 16sp, brand red
| +---------------------------+|
| | Pro Boxing (Men)   48:00  >||
| +---------------------------+|
| | Heavy Bag          32:00  >||
| +---------------------------+|
| | Shadow Boxing      17:30  >||
| +---------------------------+|
|                         [+]  |  <- FAB
+------------------------------+

Background: #121212
Cards: #1E1E1E, 12px radius, 2dp elevation
```

### Session Summary (Pre-Workout)

```
+------------------------------+
| [<] Heavy Bag                |
|                              |
|        (spacer)              |
|                              |
|  Rounds              8      |
|  Round Duration      3:00   |
|  Rest Duration       1:00   |
|  Warning             10s    |
|                              |
|  Total Time          32:00  |  <- Bold
|                              |
|        (spacer x2)          |
|                              |
| [========= START =========] |  <- 80px, green, full width
+------------------------------+
```

### Workout Complete

```
+------------------------------+
|        (spacer)              |
|                              |
|         [check]              |  <- 96dp green check icon
|                              |
|    WORKOUT COMPLETE          |  <- Teko 28sp
|                              |
|      Heavy Bag               |  <- Barlow 20sp, 80%
|    8 rounds completed        |  <- Barlow 16sp, 60%
|    Total time: 32:04         |  <- Barlow 16sp, 60%
|                              |
|        (spacer)              |
|                              |
| [========= REPEAT ========] |  <- 64px, green, full width
| [========= DONE ===========] |  <- 64px, outlined, full width
+------------------------------+
```

---

## Logo & Wordmark

### Primary Logo

The logo is a **wordmark-first** design: the word "BOXING" set in Bebas Neue, with the "O" replaced by a circular element that evokes both a boxing ring (top-down view) and a timer dial.

**Construction:**
- "B" + circular ring element + "XING" in Bebas Neue
- The ring element has a small progress arc (brand red) suggesting a timer
- Monochrome: works in white-on-black and black-on-white

**Color variants:**
- **Primary**: White wordmark on `#121212` background
- **Accent**: White wordmark with red ring accent on `#121212`
- **Reversed**: Black wordmark on white (for light contexts)
- **Icon only**: The ring element extracted as a standalone mark

### App Icon

- Dark background (`#1A1A1A`)
- Centered ring element from the wordmark
- Brand red (`#E53935`) progress arc at ~75% sweep
- White inner elements
- No text in the icon (too small to read at launcher size)

### Usage Rules

- Minimum clear space: height of the "B" on all sides
- Minimum display size: 24px height for wordmark, 16px for icon
- Never stretch, rotate, or add effects
- Never place on busy backgrounds without a container

---

## Dark Mode Priority

Dark theme is the **primary** theme. Light theme exists for accessibility but is secondary.

**Rationale:**
- 82% of mobile users prefer dark mode (Android Authority, 2024)
- Gym environments have poor contrast for light screens
- OLED battery savings on Samsung (dominant Android brand)
- Every serious boxing app ships dark-first
- Timer digits and phase colors pop against dark backgrounds

---

## Accessibility

| Requirement | Implementation |
|-------------|---------------|
| WCAG AA contrast (4.5:1 min) | White text on `#121212` = 15.4:1 ratio |
| Large text contrast (3:1 min) | Phase colors on `#121212` all pass |
| Touch targets | 64-80dp for timer controls (exceeds 48dp minimum) |
| Semantic labels | All icon buttons have `Semantics(label:)` |
| Screen reader | Timer state announced via label updates |
| Reduced motion | No gratuitous animation; phase changes are immediate |
| Color blindness | Phase identity reinforced by text labels ("WORK", "REST"), not color alone |
