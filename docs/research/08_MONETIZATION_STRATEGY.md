# 08: Monetization Strategy — Store-Managed IAP Without Backend

## Executive Summary

The app currently captures only the lowest-value segment of willing payers — users who dislike ads — with a single "Remove Ads" non-consumable at $2.99. This document lays out a layered IAP strategy using store-managed purchases (no backend, no auth) that can 3-5x revenue per install.

**Core insight**: Users pay for "the feeling of not training alone", not for configurations. Multiple apps charging $3-$50 for combo callout features have sustained user bases and high ratings.

---

## Current State

- **Free tier**: Full app with banner ads (home) + interstitial ads (after workout, 3min cooldown)
- **Paid tier**: Single non-consumable "Remove Ads" (~$2.99)
- **No auth, no backend**: Purchases managed entirely by Google Play / App Store
- **Purchase persistence**: Hive cache for instant UI, store as source of truth, restore via store API

## Why Non-Consumable Packs (Not Subscriptions)

| Factor | Non-Consumable | Subscription |
|--------|---------------|-------------|
| Recurring justification needed | No | Yes — users must feel new value each billing cycle |
| Restore without backend | Yes — stores track non-consumables permanently | Yes, but churn is the problem |
| User trust | High — pay once, own it | Risk of backlash (Boxing Timer Pro lesson) |
| Revenue predictability | Lumpy | Smooth but requires retention |
| Content cadence needed | No | Yes — monthly new content expected |

**Boxing Timer Pro cautionary tale**: Switched from $3 one-time to subscription. Users left 1-star reviews in volume: "Moved to a subscription model, completely ignoring those people that paid for the app in the past."

**Post-Google Billing Client 8**: Consumed purchases and non-renewing subscriptions cannot be queried from billing history without an account system. Non-consumables are the only IAP type that restores cleanly without auth.

## Recommended Product Structure

### Tier 1: Remove Ads — $2.99 (exists, no change)
Entry-level conversion. Every 1-star review mentioning ads is a potential $2.99.

### Tier 2: Combo Callouts Pack — $3.99
**Unlocks**: Intermediate + advanced combo difficulties, defense/footwork callout modes, combo frequency configuration.

**Free forever**: Beginner difficulty (10-16 combos per sport). Every user gets a taste of combo coaching.

**Pricing rationale**: Boxing Coach Workout Timer charges $2.99 for simpler callouts. Precision Boxing Coach charges $4.99 for full app. At $3.99, we undercut both with a larger library and better timer reliability.

### Tier 3: Programs Pack — $4.99
**Unlocks**: Week 2+ of all guided programs, progress tracking, streak data.

**Free forever**: First week of each program.

**Pricing rationale**: PRO BOXING charges $59.99-$89.99 per individual module. We're dramatically cheaper and position as exceptional value.

### Tier 4: Sport Packs — $1.99 each or $5.99 bundle
- **Muay Thai Pack**: MT-specific combos (teep, roundhouse, clinch, knee, elbow)
- **MMA Pack**: Mixed striking/grappling callouts, position transitions
- **BJJ Pack**: Positional drilling cues, competition format timers
- **Wrestling Pack**: Shot drills, chain wrestling, period-based formats

**Individual pricing**: Sport-specific users self-identify as buyers. A BJJ practitioner pays $1.99 without hesitation.

**Bundle**: $5.99 for all four (vs $7.96 individual) for multi-sport users.

### Tier 5: Everything Bundle — $9.99 (launch after individual packs)
Remove Ads + Combos + Programs + All Sport Packs. One price, complete app.

**Positioning**: 3x cheaper than one month of PunchLab ($17.99). 13x cheaper than PRO BOXING lifetime ($129.99).

## What Must Stay Free (Non-Negotiable)

- Timer engine and all background/audio features
- At least one solid preset per sport
- Custom session editor
- Training history
- Sound packs
- i18n
- Beginner combo callouts
- First week of each program

**Rule**: The moment a user can say "they locked the timer behind a paywall" is the moment the review score falls.

## Paywall UX Rules

**When to show (acceptable)**:
- User taps a combo-enabled session and beginner callouts are exhausted
- User navigates to Programs and tries to access week 2+
- User taps a sport-specific preset requiring a pack they don't own

**When to NEVER show**:
- During an active timer session
- When starting a basic (timer-only) preset
- As an interstitial during any training flow

**Required elements** (Apple mandate + good practice):
- "Restore Purchases" on all paywall screens
- Clear description of what each product contains
- No dark patterns, no fake countdown timers

## IAP Management: Adapty Recommended

| Factor | Adapty | RevenueCat |
|--------|--------|-----------|
| Free tier | $10K MTR with full analytics | No revenue limit, limited analytics |
| Flutter SDK | `adapty_flutter` | `purchases_flutter` |
| Non-consumable support | Yes | Yes (Android SDK 7.11.0+) |
| When to switch | If exceeding $10K MTR | If needing larger community support |

**Local caching**: Hive stores active entitlements for instant offline access. Adapty validates in background. Non-consumables don't expire.

## Revenue Projections (Illustrative)

At 10,000 installs/month:

| Product | Conversions/Mo | Price | Revenue/Mo |
|---------|---------------|-------|-----------|
| Remove Ads | 200 | $2.99 | ~$510 |
| Combo Pack | 100 | $3.99 | ~$340 |
| Sport Packs (avg) | 50 | $2.49 blended | ~$106 |
| Programs Pack | 50 | $4.99 | ~$212 |
| Everything Bundle | 30 | $9.99 | ~$255 |
| **Total** | | | **~$1,423/mo** |

(After 15% store commission on Small Business Program)

## Launch Sequence

**Phase 1** (Sprint 11 complete + paywall sprint):
- Combo Callouts Pack ($3.99): gate intermediate/advanced, leave beginner free
- Integrate Adapty Flutter SDK

**Phase 2** (4-8 weeks post-launch):
- Programs Pack ($4.99): first week free, weeks 2+ gated
- Muay Thai + MMA sport packs ($1.99 each)

**Phase 3** (content library expansion):
- BJJ + Wrestling packs ($1.99 each)
- Everything Bundle ($9.99)

## Competitor Pricing Reference

| App | Model | Price | What's Gated |
|-----|-------|-------|-------------|
| Boxing Interval Timer | One-time | $5.99 | Custom profiles + ad removal |
| Boxing Coach Workout Timer | One-time | $2.99 | Combo callouts, 6 voice coaches |
| Precision Boxing Coach Pro | Paid upfront | $4.99 | Full app (combo callouts, 4 modes) |
| PRO BOXING Training Timer | Subscription | $9.99-$14.99/mo, $129.99 lifetime | All workout content |
| PunchLab | Subscription | $17.99/mo | Full workout library |
| Heavy Bag Pro | Subscription | Varies | All 1,000+ combos (3 free) |
| Shadow Boxing App | Free | $0 | Nothing (studying model change) |

## Market Benchmarks (RevenueCat 2025)

- H&F median trial-to-paid: 39.9% (top 10%: 68.3%)
- H&F Revenue Per Install (Day 14): $0.44-$0.63 (highest of any category)
- One-time purchases growing: 6.4% → 10.3% of app revenue (2023→2025)
- H&F category revenue: $3.4B, up 24.5% YoY

## Key Decision Log

| Decision | Rationale |
|----------|-----------|
| Non-consumable only (no subs) | Static content, no recurring value justification, restore works without backend |
| No consumables | Post-Billing Client 8, consumed purchases can't be restored without account system |
| Adapty over RevenueCat (initially) | $10K MTR free tier with full analytics |
| Beginner combos free forever | Demonstrates value before paywall, drives conversion |
| First program week free | Same — show value, then ask |
| Never gate previously-free features | Boxing Timer Pro backlash is documented proof this destroys trust |
| Sport packs individual + bundle | Sport-specific users self-identify; bundle handles multi-sport |
| $9.99 Everything Bundle | Massively undercuts all subscription competitors |
