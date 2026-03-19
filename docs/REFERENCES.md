# References & Resources

## Flutter Open Source Timer Projects

These repos serve as reference implementations, not as code to copy:

| Project | URL | Relevance |
|---------|-----|-----------|
| plinkr/training_timer | github.com/plinkr/training_timer | Most feature-complete: MMA/Boxing timer, circular progress, audio alerts, 10s warning |
| lyushenko/boxing_timer | github.com/lyushenko/boxing_timer | Minimalist boxing timer in Flutter, good starting point reference |
| insin/tabata_timer | github.com/insin/tabata_timer | Tabata interval timer, good reference for interval logic |
| blockbasti/just_another_workout_timer | F-Droid | Full Flutter workout timer with TTS announcements, Material Design, open source |
| Bloc library timer tutorial | bloclibrary.dev/tutorials/flutter-timer/ | Canonical Flutter timer pattern using Bloc |

## Boxing Training Resources

### Round Structure References
- RDX Sports Boxing Round Guide
- Fighters Corner - Understanding Boxing Rounds
- Fairtex Store - How Long Are Boxing Rounds
- YOKKAO - Muay Thai Rules

### Training Methodology
- Boxing Science - Training Camp planning
- Boxing Science - The Boxer's Warm Up
- Evolve MMA - Famous Boxers Training Regimens
- USA Boxing - Strength & Conditioning Plan
- MasterClass - Boxing Workout Guide

### Punch Number System
Standard numbering used by coaches worldwide:
- 1 = Jab
- 2 = Cross (straight right for orthodox)
- 3 = Lead Hook
- 4 = Rear Hook
- 5 = Lead Uppercut
- 6 = Rear Uppercut
- "b" modifier = body shot (e.g., 1b = jab to body)

Common combinations: 1-2, 1-2-3, 1-1-2, 2-3-2, 1-2-3-2, 1-2-5-2

Sources: MPBA, Expert Boxer, FightCamp

## Competitor Apps

### Dedicated Timers
- Boxing Interval Timer (iOS/Android) - 4.8 stars, 23K reviews, $3.99
- Boxing Timer Pro (iOS) - AirPlay, 9 sounds, switched to subscription (backlash)
- Boxing iTimer Lite (iOS) - Free, background mode works, limited features
- KruBoss (Both) - Free, no ads, built by martial artists
- Boxing Round Timer Pro (Android) - Reaction training mode, no ads
- Boxing Timer Champ (iOS) - Background mode, stored routines

### Training Apps
- Shadow Boxing App - 4.9/5, 6,500+ reviews, free, AI voice coaching, Apple Watch haptics
- Heavy Bag Pro - 4.9/5, 1000+ combos, 3D animations, subscription
- Precision Boxing Coach - AI combo callouts, Virtual Padwork, $4.99
- FightCamp - $39/month + equipment, punch tracking sensors

## Flutter Package References

| Package | Purpose | Notes |
|---------|---------|-------|
| just_audio | Sound playback | Low latency, cross-platform |
| audio_service | Background audio + foreground service | Required for background timer |
| just_audio_background | Simple wrapper | For single AudioPlayer cases |
| wakelock_plus | Keep screen on | Enable only during active session |
| flutter_foreground_task | Android foreground service | Alternative to audio_service |
| flutter_riverpod | State management | Testable, composable |
| freezed | Immutable models | Code generation for data classes |
| hive / hive_flutter | Local storage | Fast, no native dependencies |
| vibration | Haptic feedback | For noisy gym environments |

## User Pain Points (Direct Quotes)

> "It's pretty frustrating that it doesn't work in the background. If my phone screen locks or I open another app during the rest period, the timer stops."

> "Needs keepalive functionality because my Samsung phone regularly goes to sleep on it and then I have to shed my gloves, unlock the screen and reopen the app."

> "The audio cues are hardly noticeable when playing Spotify."

> "It always pauses my music every time the app rings at the end of the round."

> "Disappointed with the choices in sounds. There is a boxing bell, of course, but no double/triple tap for 10 seconds remaining. Most of the sounds are the same type of cheesy sounds you might choose as a txt alert, and not fight-related sounds."

> "Moved to a subscription model, completely ignoring those people that paid for the app in the past."

> "5 gigs in a few uses is ridiculous" (data usage for a timer app)

## V2 Research Documents

Deep research conducted March 2026 covering competitive landscape, user values, pain points, technology, market expansion, and business models:

| Document | Focus | Lines |
|----------|-------|-------|
| `docs/research/RESEARCH_FRAMEWORK.md` | Research methodology and framework | — |
| `docs/research/01_VALUE_ANALYSIS.md` | What users fundamentally value | 692 |
| `docs/research/02_COMPETITOR_DEEP_DIVE.md` | 20+ competitor analysis across 4 tiers | 957 |
| `docs/research/03_USER_PAIN_POINTS.md` | Real user complaints and quotes | 913 |
| `docs/research/04_TECHNOLOGY_SCAN.md` | AI, wearables, sensors, platform capabilities | 1,184 |
| `docs/research/05_MARKET_EXPANSION.md` | 15 audience segments analyzed | 1,109 |
| `docs/research/06_BUSINESS_MODELS.md` | 10 monetization models evaluated | 1,029 |
| `docs/research/07_OPPORTUNITY_MATRIX.md` | Ranked opportunities and strategic paths | 675 |

## Combat Sport Training References (V2)

### Boxing Combo System
- 1=Jab, 2=Cross, 3=Lead Hook, 4=Rear Hook, 5=Lead Uppercut, 6=Rear Uppercut
- "b" modifier = body shot
- Sources: MPBA, Expert Boxer, FightCamp

### Muay Thai Technique System
- Kicks: roundhouse, teep (push kick), switch kick, low kick
- Elbows: horizontal, uppercut, spinning
- Knees: straight, diagonal, flying
- Clinch: double collar tie, single collar, body lock
- Sources: YOKKAO, Evolve MMA, Muay Thai Authority

### BJJ Position System
- Guard positions: closed guard, open guard, half guard, butterfly, de la riva
- Top positions: mount, side control, knee on belly, back mount
- Transitions: sweep, pass, escape, submission attempt
- Competition formats: IBJJF (points), ADCC (points + submission), sub-only
- Sources: IBJJF rulebook, Grapplearts, BJJ Fanatics

### MMA Training Structure
- Striking rounds, grappling rounds, mixed rounds
- Cage work: clinch against wall, takedown defense
- Ground and pound positions
- Sources: UFC Performance Institute, MMA Fighting
