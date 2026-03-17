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
  B ◯ X I N G
    ^
    |__ Timer ring: circle with red progress arc (~270deg)
        Inner: remaining time indicator (white dot at arc end)
```

### Variants

| Variant | Background | Wordmark | Ring Accent | Use Case |
|---------|-----------|----------|-------------|----------|
| Primary (dark) | `#121212` | White | `#E53935` | App, marketing on dark |
| Reversed (light) | `#FFFFFF` | `#121212` | `#E53935` | Print, light backgrounds |
| Monochrome (dark) | `#121212` | White | White | Single-color contexts |
| Monochrome (light) | `#FFFFFF` | `#121212` | `#121212` | Single-color print |
| Icon only | `#1A1A1A` | — | `#E53935` | App launcher, favicon |

### App Icon

- **Shape**: Rounded square (per platform guidelines)
- **Background**: `#1A1A1A`
- **Element**: Timer ring with red progress arc
- **Inner**: Stylized "B" letterform or boxing bell silhouette
- **Size**: Renders clearly at 48x48dp (minimum launcher size)

---

## Color Palette

### Primary

| Swatch | Hex | RGB | Usage |
|--------|-----|-----|-------|
| Brand Red | `#E53935` | 229, 57, 53 | Primary accent, CTA buttons, active states |
| Brand Red Dark | `#C62828` | 198, 40, 40 | Pressed states, hover |
| Brand Red Light | `#EF5350` | 239, 83, 80 | Highlights, badges |

### Neutrals

| Swatch | Hex | RGB | Usage |
|--------|-----|-----|-------|
| Black | `#000000` | 0, 0, 0 | True black (OLED, borders) |
| Dark BG | `#121212` | 18, 18, 18 | Primary background |
| Dark Surface | `#1E1E1E` | 30, 30, 30 | Cards, sheets |
| Dark Elevated | `#2C2C2C` | 44, 44, 44 | Elevated surfaces |
| Border | `#333333` | 51, 51, 51 | Subtle dividers |
| Gray 600 | `#757575` | 117, 117, 117 | Disabled, paused |
| Gray 400 | `#9E9E9E` | 158, 158, 158 | Idle, placeholder |
| White | `#FFFFFF` | 255, 255, 255 | Primary text, icons |

### Accent (Achievement)

| Swatch | Hex | RGB | Usage |
|--------|-----|-----|-------|
| Gold | `#FFC107` | 255, 193, 7 | Achievements, streaks (future) |
| Gold Dark | `#FFA000` | 255, 160, 0 | Pressed gold state |

### Phase Colors (Functional)

| Phase | Hex | Usage |
|-------|-----|-------|
| Work Green | `#4CAF50` | Active round |
| Warning Amber | `#FF9800` | 10s warning |
| Rest Red | `#F44336` | Rest period |
| Warmup Blue | `#2196F3` | Pre-round countdown |

---

## Typography

### Font Stack

| Priority | Font | Source | Fallback |
|----------|------|--------|----------|
| Display | Bebas Neue | Google Fonts | Impact, system condensed sans |
| Heading | Teko | Google Fonts | Arial Narrow, system sans |
| Body | Barlow Condensed | Google Fonts | Roboto Condensed, system sans |
| Mono | Roboto Mono | System | Courier New |

### Scale

| Name | Font | Size | Weight | Tracking |
|------|------|------|--------|----------|
| displayLarge | Bebas Neue | 96sp | 400 | +2 |
| displayMedium | Bebas Neue | 64sp | 400 | +2 |
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
| Completion | WORKOUT COMPLETE |

---

## Do's and Don'ts

### Do

- Use dark backgrounds as the primary surface
- Use phase colors only for timer-state communication
- Keep the UI information-dense but uncluttered
- Prioritize legibility at distance (gym use)
- Make all touch targets 64dp+ during active workout
- Use the brand red sparingly — it's an accent, not a surface

### Don't

- Use gradients (they feel generic/fitness, not boxing)
- Use rounded, bubbly fonts (Nunito, Poppins — wrong personality)
- Use purple, teal, or mint (generic fitness app colors)
- Add photography or illustrations to functional UI
- Use glassmorphism, neumorphism, or trendy effects
- Place text over phase-colored backgrounds without ensuring contrast
- Use the brand red for rest phase (red already means "rest" in phase context)
