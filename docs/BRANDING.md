# Branding Guide — Boxing Timer App

## Brand Overview

| Attribute | Value |
|-----------|-------|
| **Name** | Boxing |
| **Tagline** | The timer that never stops. |
| **Category** | Sports / Boxing / Timer |
| **Personality** | Raw, disciplined, reliable |
| **Tone** | Direct, functional, zero fluff |
| **Target** | Serious fighters, gym boxers, home trainers |

---

## Logo

### Wordmark (Primary)

The primary logo is a **typographic wordmark** — "BOXING" in Bebas Neue with the "O" stylized as a timer ring with a progress arc.

The HTML reference files for the logo are located at:
- `assets/branding/logo.html` — Full logo in all variants (open in browser to view)

### Construction

```
  B O X I N G
    ^
    |__ Timer ring: circle with red progress arc (~270deg)
        Inner: remaining time indicator (white dot at arc end)
```

### Variants

| Variant | Background | Wordmark | Ring Accent | Use Case |
|---------|-----------|----------|-------------|----------|
| Primary (dark) | `#000000` | White | `#E53935` | App, marketing on dark |
| Reversed (light) | `#FFFFFF` | `#000000` | `#E53935` | Print, light backgrounds |
| Monochrome (dark) | `#000000` | White | White | Single-color contexts |
| Monochrome (light) | `#FFFFFF` | `#000000` | `#000000` | Single-color print |
| Icon only | `#000000` | — | `#FFB300` | App launcher, favicon |

---

## App Icon

### Design Direction: The Bell

The boxing bell is the singular object that represents "time is being kept in a boxing match." It is more unique to boxing-specific timing than a glove (shared with training apps, games, workout apps).

**Specification:**
- **Background**: `#000000` (true black, matches app aesthetic)
- **Bell shape**: Bold, stylized, not realistic — thick strokes, approximately 60% of icon area
- **Bell color**: `#FFB300` (amber/gold) — the color of brass bells and boxing championship belts
- **Accent**: Small circular sound-wave rings to the right of the bell clapper (2-3 arcs, same amber)
- **No text in icon** — unreadable at notification size

**Why the bell, not the glove:**
- A glove icon is shared with boxing training apps, games, workout apps — it does not differentiate "timer"
- The bell connects to the primary audio identity of the app
- Gold-on-black is distinctive in a sea of green fitness icons and red/black boxing icons
- Can be rendered with bold geometry that reads clearly at 29x29 pixels (notification icon size)

### What to Avoid

- Gradient backgrounds (wash out in dark app grid contexts)
- Realistic illustration style (unreadable at 29px)
- Clock hands overlaid on a glove (too much information)
- Red background (too similar to 40% of fitness apps)

---

## Color Palette

### Primary

| Swatch | Hex | RGB | Usage |
|--------|-----|-----|-------|
| Brand Red | `#E53935` | 229, 57, 53 | Primary accent, CTA buttons, active states |
| Brand Red Dark | `#C62828` | 198, 40, 40 | Pressed states, hover |
| Brand Red Light | `#EF5350` | 239, 83, 80 | Highlights, badges |

### Neutrals (True Black Layered System)

| Swatch | Hex | RGB | Usage |
|--------|-----|-----|-------|
| True Black | `#000000` | 0, 0, 0 | Timer screen, scaffold — OLED pixels off |
| Card Surface | `#111111` | 17, 17, 17 | Session cards — slight lift |
| Raised Surface | `#1A1A1A` | 26, 26, 26 | Modals, bottom sheets |
| Divider | `#2A2A2A` | 42, 42, 42 | Subtle separators |
| Ring Track | `#222222` | 34, 34, 34 | Progress ring background |
| Gray 600 | `#757575` | 117, 117, 117 | Disabled, paused |
| Gray 400 | `#9E9E9E` | 158, 158, 158 | Idle, placeholder |
| White | `#FFFFFF` | 255, 255, 255 | Primary text, icons |

### Accent (Achievement)

| Swatch | Hex | RGB | Usage |
|--------|-----|-----|-------|
| Gold | `#FFB300` | 255, 179, 0 | Achievements, app icon bell, premium features |
| Gold Dark | `#FFA000` | 255, 160, 0 | Pressed gold state |

### Phase Colors (Functional)

| Phase | Hex | Source | Usage |
|-------|-----|--------|-------|
| Work Green | `#00C853` | Material Green A700 | Active round |
| Warning Amber | `#FFB300` | Amber 700 | 10s warning |
| Rest Red | `#E53935` | Red 600 | Rest period |
| Warmup Blue | `#1E88E5` | Blue 600 | Pre-round countdown |
| Complete | `#B0BEC5` | Blue-grey 300 | Session finished |

### Session Category Colors

| Category | Hex | Sessions |
|----------|-----|----------|
| Boxing | `#00C853` | Pro Boxing (Men/Women), Amateur, Sparring, Pad Work |
| Bag Work | `#FF6D00` | Heavy Bag, Speed Bag |
| Conditioning | `#E53935` | Conditioning, Tabata, EMOM |
| Combat Sports | `#7E57C2` | Muay Thai, MMA, Kickboxing |
| Beginner | `#1E88E5` | Beginner, Youth Boxing, Shadow Boxing |
| Custom | `#FFB300` | User-created sessions |

---

## Typography

### Font Stack

| Priority | Font | Source | Fallback | Role |
|----------|------|--------|----------|------|
| Display | Roboto Condensed | Bundled TTF | System sans | Timer countdown digits (working tabular figures) |
| Heading | Teko | Bundled TTF | Arial Narrow | Phase labels, round indicators |
| Body | Barlow Condensed | Bundled TTF | Roboto | Session names, settings, forms |
| Secondary Display | Bebas Neue | Bundled TTF | Impact | Marketing, session titles (NOT countdown) |

### Scale

| Name | Font | Size | Weight | Tracking |
|------|------|------|--------|----------|
| displayLarge | Roboto Condensed | 96sp | 700 | +2 |
| displayMedium | Roboto Condensed | 64sp | 700 | +2 |
| headlineLarge | Teko | 32sp | 600 | +3 |
| headlineMedium | Teko | 24sp | 500 | +2 |
| headlineSmall | Teko | 20sp | 500 | +1 |
| titleLarge | Barlow Condensed | 20sp | 600 | +0.5 |
| titleMedium | Barlow Condensed | 18sp | 500 | 0 |
| titleSmall | Barlow Condensed | 16sp | 500 | 0 |
| bodyLarge | Barlow Condensed | 16sp | 400 | 0 |
| bodyMedium | Barlow Condensed | 14sp | 400 | 0 |
| bodySmall | Barlow Condensed | 12sp | 400 | 0 |
| labelLarge | Barlow Condensed | 18sp | 600 | +1 |
| labelMedium | Barlow Condensed | 14sp | 500 | +0.5 |

---

## Voice & Tone

### Writing Style

- **Imperative mood**: "Start", "Stop", "Edit Session" (not "Would you like to...")
- **No exclamation marks** in UI copy
- **No emoji** in UI (reserved for marketing only)
- **Uppercase** for phase labels and section headers
- **Title case** for session names and settings labels
- **Sentence case** for descriptions and help text

### Example Copy

| Context | Text |
|---------|------|
| CTA button | START |
| Phase label | WORK |
| Section header | QUICK START |
| Setting label | Default Warning |
| Setting description | Show 3-2-1 countdown when resuming |
| Empty state | Create your first session |
| Delete confirm | Delete "Heavy Bag"? This cannot be undone. |
| Completion | SESSION COMPLETE |

---

## Do's and Don'ts

### Do

- Use true black backgrounds as the primary surface
- Use phase colors only for timer-state communication
- Keep the UI information-dense but uncluttered
- Prioritize legibility at distance (gym use)
- Make all touch targets 64dp+ during active workout
- Use the brand red sparingly — it's an accent, not a surface
- Bundle fonts for instant first-frame rendering

### Don't

- Use gradients (they feel generic/fitness, not boxing)
- Use rounded, bubbly fonts (Nunito, Poppins — wrong personality)
- Use purple, teal, or mint as brand colors (generic fitness app)
- Add photography or illustrations to functional UI
- Use glassmorphism, neumorphism, or trendy effects
- Place text over phase-colored backgrounds without ensuring contrast
- Use the brand red for rest phase (red already means "rest" in phase context)
- Animate or pulse countdown digits (readability > decoration)
- Use split-flap/retro clock aesthetics (gimmick at 96sp update speed)
- Rely on `google_fonts` runtime fetching for the countdown font

---

## App Store Visual Strategy

### Screenshots
- Dark backgrounds matching app aesthetic
- Show timer screen prominently (the hero feature)
- Feature comparison callout: "Works with Spotify", "Never stops in background"
- Show preset session variety

### Feature Graphic (Google Play)
- Gold bell icon on black background
- App name in Roboto Condensed Bold
- Tagline: "The timer that never stops."

### Naming Considerations
"Boxing" is the working name. If unavailable on app stores, alternatives to consider:
- RoundBell, BellWork, CornerTimer
- BoxRound, FightClock, GymBell
- The Bell (simple, memorable)
