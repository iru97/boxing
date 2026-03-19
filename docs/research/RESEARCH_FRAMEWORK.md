# V2 Research Framework: Feature Discovery & Strategic Direction

## Objective

Identify, validate, and prioritize the next evolution of Boxing — whether that's deeper timer features, a pivot toward coaching/social, gym tooling, or an entirely new value proposition. We start open-minded and let the data narrow us down.

## Core Questions

1. **What do users actually value?** — Not features, but underlying needs. Reliability? Community? Progress tracking? Coaching? Convenience?
2. **Where is money being spent?** — What are users willing to pay for? What business models work? What causes revolt?
3. **What's broken everywhere?** — Systemic problems no competitor has solved well.
4. **What's newly possible?** — Technology capabilities (AI, wearables, sensors) that didn't exist or weren't mature 2 years ago.
5. **Where's the underserved audience?** — Who is being ignored by current apps?
6. **What would make someone switch?** — From their current app to ours. What's the switching trigger?

---

## Research Phases

### Phase 1: Value Analysis
**File:** `01_VALUE_ANALYSIS.md`
**Question:** What do users fundamentally value in training apps? What makes them love, pay for, or abandon an app?

#### Methodology
- Extract and categorize 500+ user reviews across top 10 apps (App Store + Play Store)
- Mine Reddit threads: r/boxing, r/amateur_boxing, r/MuayThai, r/mmafightcards, r/kickboxing, r/homegym
- YouTube comment analysis on "best boxing app" videos
- Identify **value drivers** (not features): reliability, simplicity, authenticity, progress visibility, motivation, coaching, community
- Map each competitor's implicit value proposition

#### Deliverables
- Value hierarchy: ranked list of what users care about most → least
- Value-feature mapping: which features serve which values
- Unmet values: things users want that no app delivers
- Anti-values: things users explicitly reject (subscriptions for timers, bloat, ads)

---

### Phase 2: Competitor Deep-Dive
**File:** `02_COMPETITOR_DEEP_DIVE.md`
**Question:** What is every relevant competitor doing, betting on, and failing at?

#### Scope — 4 tiers of competitors

**Tier 1: Direct competitors (boxing timers)**
- Boxing Interval Timer
- Boxing Timer Pro
- Boxing iTimer
- KruBoss
- Boxing Round Timer Pro
- Boxing Timer Champ
- Round Timer Pro
- Any new entrants (2025-2026)

**Tier 2: Training + coaching apps**
- Shadow Boxing App
- Heavy Bag Pro
- Precision Boxing Coach
- FightCamp
- Boxbollen
- Liteboxer

**Tier 3: Adjacent combat sport apps**
- Muay Thai-specific apps
- MMA timers
- BJJ timers (e.g., BJJ Timer, Grapple Timer)
- Wrestling training apps

**Tier 4: Adjacent fitness/interval apps**
- Seconds Pro (interval timer)
- Tabata Timer
- SmartWOD
- HIIT/CrossFit timers

#### Per-competitor analysis template
```
App Name:
Platform: iOS / Android / Both
Last Updated:
Rating / Review Count:
Price Model:
Monthly Active Users (estimated):

Feature Matrix:
  - Timer reliability (background/lock screen):
  - Audio quality/ducking:
  - Glove-friendly controls:
  - Per-round customization:
  - Compound/circuit rounds:
  - Voice coaching/announcements:
  - Wearable support:
  - Social/sharing:
  - Video/visual coaching:
  - AI features:
  - Progress tracking:
  - Coach mode:
  - Music integration:

Value Proposition (1 sentence):
What they do best:
What they do worst:
Recent trajectory (new features, pivots):
User sentiment (top 3 praises, top 3 complaints):
Revenue model analysis:
```

#### Deliverables
- Complete competitor matrix (spreadsheet-style comparison)
- Feature saturation map: which features are table-stakes vs. differentiators
- Competitor trajectory analysis: where is each heading?
- White space identification: gaps no one fills

---

### Phase 3: User Pain Point Mining
**File:** `03_USER_PAIN_POINTS.md`
**Question:** What are real people actually complaining about, wishing for, and hacking together?

#### Sources
- App Store reviews (1-3 star, filtered by recent)
- Google Play reviews (same)
- Reddit: r/boxing, r/amateur_boxing, r/MuayThai, r/kickboxing, r/homegym, r/bodyweightfitness
- Boxing forums: Sherdog, BoxingScene, BoxingForum24
- YouTube comments on boxing training/app review videos
- Twitter/X: #boxingtraining, #boxingtimer, #fightcamp
- Coach/trainer perspectives: what do trainers need that apps don't give them?

#### Pain point taxonomy
```
Category: [Timer Reliability | Audio | UX | Customization | Training Quality |
           Progress | Social | Hardware | Pricing | Platform | Coach Tools]

Pain Point: [description]
Severity: [Critical | High | Medium | Low]
Frequency: [how often mentioned]
Current Solutions: [workarounds users employ]
Example Quotes: [3-5 direct quotes]
Opportunity Score: severity × frequency × (1 - current_solution_quality)
```

#### Deliverables
- Top 30 pain points ranked by opportunity score
- Pain point clusters (grouped by underlying need)
- Workaround analysis: what are users doing today to solve these?
- Quote bank: 100+ direct user quotes organized by theme

---

### Phase 4: Technology & Capability Scan
**File:** `04_TECHNOLOGY_SCAN.md`
**Question:** What's newly possible in mobile/Flutter/wearable that could create step-change features?

#### Areas to investigate

**AI/ML on device**
- On-device punch counting (accelerometer + ML)
- Form analysis via camera (MediaPipe/TFLite)
- Adaptive training: AI adjusts rounds/rest based on performance
- Voice coaching generation (conversational AI calling combos)
- Personalized workout generation

**Wearables**
- Apple Watch: WatchOS capabilities, health data, haptics
- Wear OS: current state of boxing apps on watch
- Galaxy Watch: sensor access
- AirPods: motion detection, heart rate (AirPods Pro 2)
- Smart jump ropes, punch trackers

**Sensors & Hardware**
- Phone accelerometer for punch detection (no extra hardware)
- Camera-based rep counting
- Heart rate via camera (rPPG)
- Bluetooth heart rate monitors (Polar, Garmin)
- Smart heavy bag sensors

**Platform Capabilities**
- Flutter 2025-2026: new APIs, improved background, widgets
- iOS Live Activities / Dynamic Island
- Android widgets, Wear OS tiles
- Cross-device experiences (phone + watch + TV)
- Offline-first AI models

**Social & Connected**
- Real-time sparring sync (two phones, same timer)
- Coach-athlete live connection
- Leaderboards, challenges
- Session sharing (QR/link)
- Gym-wide timer broadcast

#### Deliverables
- Technology readiness matrix: capability × maturity × effort
- "Wow factor" features: technically feasible, nobody doing it
- Build vs. buy analysis for key capabilities
- Flutter package landscape for each capability

---

### Phase 5: Market & Audience Expansion
**File:** `05_MARKET_EXPANSION.md`
**Question:** Who else could we serve, and what would that require?

#### Audience segments to analyze

| Segment | Current Service Level | Size | Willingness to Pay |
|---------|----------------------|------|-------------------|
| Solo home boxers | Well served (us + competitors) | Large | Low-medium |
| Gym boxers | Moderately served | Large | Medium |
| Boxing beginners | Moderately served | Very large | Low |
| Boxing coaches/trainers | Poorly served | Medium | High |
| Boxing gyms (as businesses) | Very poorly served | Small-medium | Very high |
| Cardio/fitness boxers | Well served by FightCamp etc | Very large | High |
| MMA fighters | Moderately served | Large | Medium |
| Muay Thai practitioners | Poorly served | Medium | Medium |
| BJJ practitioners | Poorly served | Medium | Medium |
| Wrestlers | Very poorly served | Medium | Low |
| Personal trainers (general) | Served by generic apps | Very large | Medium |
| Amateur competition organizers | Very poorly served | Small | Medium |
| Boxing content creators | Not served | Small-medium | Medium |

#### Per-segment analysis
- Current app landscape for this segment
- Unique needs vs. boxing (what's different)
- Feature delta: what we'd need to add
- Revenue model that works for them
- Go-to-market: how do we reach them?
- Competitive moat: can we defend this segment?

#### Deliverables
- Segment attractiveness matrix (size × willingness to pay × competitive gap × effort)
- Top 3 expansion segments with detailed profiles
- Feature requirements per segment
- Revenue model options per segment

---

### Phase 6: Business Model & Monetization Research
**File:** `06_BUSINESS_MODELS.md`
**Question:** What monetization approaches work in this space, and what do users accept?

#### Models to analyze
- One-time purchase (current plan)
- Freemium with premium features
- Subscription (content-based: guided workouts, training programs)
- Subscription (tool-based: unlimited sessions, cloud sync, coach mode)
- Hardware + software (FightCamp model)
- B2B / gym licensing
- Coaching marketplace (take a cut of coach-athlete transactions)
- In-app purchases (sound packs, workout programs)
- Ad-supported (user reaction analysis)

#### Per-model analysis
- Examples in market (who does this, how well)
- User acceptance (reviews, sentiment)
- Revenue potential (ARPU, LTV)
- Churn risk
- Implementation complexity
- Brand alignment (does this fit "boxing-first, no BS"?)

#### Deliverables
- Model comparison matrix
- Recommended primary + secondary monetization
- Pricing research (what do users pay for similar?)
- Revenue projections per model

---

### Phase 7: Synthesis & Opportunity Ranking
**File:** `07_OPPORTUNITY_MATRIX.md`
**Question:** Given everything we've learned, what should we build next and why?

#### Opportunity scoring framework
Each opportunity gets scored 1-5 on:

| Dimension | Weight | Description |
|-----------|--------|-------------|
| User Value | 5x | How much does this solve a real, validated pain? |
| Differentiation | 4x | Does this set us apart from competitors? |
| Revenue Potential | 3x | Can this drive revenue directly or indirectly? |
| Technical Feasibility | 3x | Can we build this well with our stack? |
| Strategic Fit | 2x | Does this align with "boxing-first, reliable, no BS"? |
| Market Timing | 2x | Is the market ready for this now? |
| Effort | -3x | How much work to build? (negative weight) |

Score = Σ(dimension × weight)

#### Deliverables
- Top 20 opportunities ranked by composite score
- For top 5: detailed one-pager with user stories, scope, and rough plan
- Strategic recommendation: which direction to take
- Phase 2 sprint plan draft

---

## Research Principles

1. **Evidence over opinion** — Every claim backed by data, quotes, or observable market behavior
2. **Users over features** — We research what people need, not what we could build
3. **Values over features** — Understand WHY users want something, not just WHAT
4. **Quotes are gold** — Direct user language reveals real needs better than our interpretation
5. **Assume nothing** — Our V1 assumptions may be wrong; let the data challenge us
6. **Follow the money** — Where users spend tells us what they truly value
7. **Look for non-consumption** — People who SHOULD use a training app but DON'T — why not?

---

## Execution Plan

| Phase | Estimated Effort | Dependencies |
|-------|-----------------|--------------|
| 1. Value Analysis | Deep | None |
| 2. Competitor Deep-Dive | Deep | None |
| 3. User Pain Points | Deep | None |
| 4. Technology Scan | Medium | None |
| 5. Market Expansion | Medium | Phases 1-3 |
| 6. Business Models | Medium | Phases 2-3, 5 |
| 7. Synthesis | Medium | All previous |

Phases 1-4 can run in parallel. Phases 5-6 depend on earlier findings. Phase 7 synthesizes everything.

---

## Output Structure

```
docs/research/
├── RESEARCH_FRAMEWORK.md          ← This file
├── 01_VALUE_ANALYSIS.md
├── 02_COMPETITOR_DEEP_DIVE.md
├── 03_USER_PAIN_POINTS.md
├── 04_TECHNOLOGY_SCAN.md
├── 05_MARKET_EXPANSION.md
├── 06_BUSINESS_MODELS.md
└── 07_OPPORTUNITY_MATRIX.md
```
