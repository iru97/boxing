# Sprint 7: Ads & Monetization

**Goal**: Integrate non-intrusive AdMob ads (banner + interstitial) with a one-time in-app purchase to remove them, ensuring ads NEVER appear during active timer/workout screens.

---

## Research Findings

### Package Selection: google_mobile_ads

The `google_mobile_ads` package (latest stable: `^6.0.0`) is the official Google-maintained Flutter plugin for AdMob. It supports banner, interstitial, rewarded, and native ad formats across Android and iOS. It is the industry standard for Flutter ad monetization with high reliability, active maintenance, and direct Google support.

Alternatives considered:
- **Unity Ads** (`unity_ads_plugin`): Better for gaming, overkill for a utility app. Lower fill rates for non-game categories.
- **Ad mediation** (AppLovin MAX, ironSource): Adds complexity. Not worth it until the app reaches significant scale (100K+ DAU). Can be added later without architectural changes.

**Decision**: Use `google_mobile_ads` directly. Simple, well-documented, highest fill rates for utility apps. Mediation can be layered on later.

### Ad Formats for This App

| Format | Where | Why |
|--------|-------|-----|
| **Adaptive Banner** | Bottom of home screen (session list) | Non-intrusive, always visible, steady revenue. Adaptive banners auto-size to device width. |
| **Interstitial** | After completing or stopping a workout (on return to home) | Natural transition point. User has finished their activity. Low annoyance at this moment. |

Formats explicitly rejected:
- **Rewarded ads**: No natural reward to offer in a timer app. Would feel forced.
- **Native ads**: High implementation cost, marginal benefit for a list-based UI.
- **App open ads**: Too aggressive for a utility app. Users open the app to start training immediately.

### Ad Placement Rules

1. **NEVER during active timer** -- no ads on `TimerScreen` in any state (warmup, work, rest, paused, complete overlay).
2. **NEVER on session editor** -- user is configuring, don't interrupt.
3. **NEVER on settings** -- user is adjusting preferences, don't annoy.
4. **Banner on home screen only** -- anchored to bottom, below session list content.
5. **Interstitial at natural transitions only** -- after workout ends and user navigates back to home. Frequency-capped to max 1 per 3 minutes to avoid spamming users who do multiple short sessions.

### Interstitial Frequency Capping

Best practices recommend 1-3 interstitial impressions per session with 3-5 minute intervals. For a boxing timer app where users may chain multiple short sessions (e.g., 3-round amateur bouts of ~12 minutes each), the strategy is:

- Show interstitial on return to home screen AFTER a workout completes or is stopped.
- Enforce a minimum cooldown of 3 minutes between interstitials.
- Never show on first app launch.
- Track last interstitial timestamp in memory (not persisted -- resets on app restart, which is user-friendly).
- Pre-load the next interstitial immediately after showing one, so it is ready for the next natural break.

### Revenue Expectations

Based on 2025-2026 benchmarks:

| Format | eCPM (US) | eCPM (Global Avg) |
|--------|-----------|-------------------|
| Banner (adaptive) | $0.50-$1.50 | $0.30-$0.80 |
| Interstitial | $8.00-$15.00 | $4.00-$8.00 |

For a small fitness app with ~1,000 DAU showing 1 banner session + 1 interstitial per user per day:
- Banner: ~$0.50-1.50/day
- Interstitial: ~$4.00-15.00/day
- **Estimated total: $150-$500/month at 1K DAU**

### In-App Purchase: Remove Ads

**Package**: `in_app_purchase` (latest stable: `^3.2.0`) -- the official Flutter team plugin for App Store and Google Play IAP. Simpler than RevenueCat for a single non-consumable product with no subscriptions.

RevenueCat (`purchases_flutter`) was considered but rejected for now:
- Adds server-side dependency and SDK overhead.
- For a single non-consumable "Remove Ads" product, the official `in_app_purchase` plugin is sufficient.
- RevenueCat becomes valuable when adding subscriptions (Phase 2+ coaching content). Can migrate later.

**Product type**: Non-consumable (one-time purchase, permanently unlocks ad-free experience).

**Product ID**: `remove_ads` (must match exactly in App Store Connect and Google Play Console).

**Price**: $2.99 (positioned below competitors' $3.99-$4.99 to encourage impulse purchase; can be adjusted per-region in store consoles).

**Restore purchases**: Required by Apple App Store guidelines. A "Restore Purchases" button must be available in Settings for users who reinstall or switch devices.

### Platform Configuration Requirements

#### Android (`AndroidManifest.xml`)
- Add `<meta-data>` tag with AdMob Application ID: `com.google.android.gms.ads.APPLICATION_ID`.
- Add `INTERNET` permission (usually already present, but explicit is safer).
- No additional permissions needed for ads.

#### iOS (`Info.plist`)
- Add `GADApplicationIdentifier` key with AdMob App ID.
- Add `NSUserTrackingUsageDescription` key for App Tracking Transparency (ATT) dialog. Required on iOS 14.5+ for IDFA access, which improves ad revenue by 2-4x.
- Add `SKAdNetworkItems` array with Google's SKAdNetwork identifier (`cstr6suwn9.skadnetwork`) and other buyer network IDs.

#### AdMob Account Setup
- Create AdMob account at https://admob.google.com
- Register app (Android + iOS) to get Application IDs.
- Create ad units: 1 banner unit + 1 interstitial unit per platform (4 total).
- Use test ad unit IDs during development (see Test Mode section below).

### Test Ad Unit IDs (Google-provided, safe for development)

| Format | Platform | Test Ad Unit ID |
|--------|----------|----------------|
| Banner | Android | `ca-app-pub-3940256099942544/6300978111` |
| Banner | iOS | `ca-app-pub-3940256099942544/2934735716` |
| Interstitial | Android | `ca-app-pub-3940256099942544/1033173712` |
| Interstitial | iOS | `ca-app-pub-3940256099942544/4411468910` |
| App ID | Android | `ca-app-pub-3940256099942544~3347511713` |
| App ID | iOS | `ca-app-pub-3940256099942544~1458002511` |

These test IDs are provided by Google and do not generate real impressions. They must be replaced with production IDs before release.

### SDK Initialization

`MobileAds.instance.initialize()` must be called early in the app lifecycle (in `main()` after `WidgetsFlutterBinding.ensureInitialized()`). It returns a `Future` that completes once initialization is finished or after a 30-second timeout. Ad loading should not begin until after initialization completes.

---

## Deliverables

### 1. Ad Service (`lib/features/ads/data/ad_service.dart`)

A centralized service that manages all ad lifecycle operations:

```dart
class AdService {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isInitialized = false;
  DateTime? _lastInterstitialShown;

  static const _interstitialCooldown = Duration(minutes: 3);

  /// Initialize the Mobile Ads SDK. Call once at app startup.
  Future<void> initialize();

  /// Load an adaptive banner ad for the home screen.
  Future<void> loadBannerAd(double screenWidth);

  /// Get the currently loaded banner ad (null if not loaded or user is ad-free).
  BannerAd? get bannerAd;

  /// Pre-load an interstitial ad so it's ready when needed.
  Future<void> preloadInterstitial();

  /// Show the interstitial if loaded and cooldown has elapsed.
  /// Returns true if the ad was shown.
  Future<bool> showInterstitialIfReady();

  /// Dispose all loaded ads.
  void dispose();
}
```

Key behaviors:
- Banner uses `AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize()` for responsive sizing.
- Interstitial is pre-loaded immediately after SDK init and again after each show.
- Interstitial respects a 3-minute cooldown between shows.
- All ad operations check `isAdFree` status first and no-op if user has purchased ad removal.
- All ad load failures are caught and logged (never crash the app over an ad).

### 2. Ad-Free Purchase Service (`lib/features/ads/data/purchase_service.dart`)

Manages the "Remove Ads" non-consumable IAP:

```dart
class PurchaseService {
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAdFree = false;

  static const productId = 'remove_ads';

  /// Whether the user has purchased ad removal.
  bool get isAdFree;

  /// Initialize: check for existing purchases and listen to purchase stream.
  Future<void> initialize();

  /// Query the store for the "remove_ads" product details (price, description).
  Future<ProductDetails?> getRemoveAdsProduct();

  /// Initiate the purchase flow.
  Future<bool> purchaseRemoveAds();

  /// Restore previous purchases (required by Apple).
  Future<void> restorePurchases();

  /// Dispose the purchase stream subscription.
  void dispose();
}
```

Key behaviors:
- On init, check Hive for cached purchase status (`isAdFree` flag) for instant UI response.
- Subscribe to `InAppPurchase.instance.purchaseStream` to handle purchase updates.
- On `PurchaseStatus.purchased` or `PurchaseStatus.restored`: set `isAdFree = true`, persist to Hive, call `completePurchase()`.
- On `PurchaseStatus.error`: show user-friendly error, do not set ad-free.
- On `PurchaseStatus.pending`: show loading indicator.

### 3. Riverpod Providers (`lib/features/ads/presentation/ads_controller.dart`)

```dart
/// Provides the AdService singleton, initialized in main.dart.
final adServiceProvider = Provider<AdService>((ref) {
  throw UnimplementedError('adServiceProvider must be overridden');
});

/// Provides the PurchaseService singleton, initialized in main.dart.
final purchaseServiceProvider = Provider<PurchaseService>((ref) {
  throw UnimplementedError('purchaseServiceProvider must be overridden');
});

/// Whether the user has purchased ad removal. Drives conditional ad display.
final isAdFreeProvider = StateProvider<bool>((ref) => false);

/// The currently loaded banner ad, or null.
final bannerAdProvider = StateProvider<BannerAd?>((ref) => null);
```

### 4. Banner Ad Widget (`lib/features/ads/presentation/widgets/banner_ad_widget.dart`)

A reusable widget that displays the banner ad:

```dart
class BannerAdWidget extends ConsumerStatefulWidget {
  const BannerAdWidget({super.key});

  @override
  ConsumerState<BannerAdWidget> createState() => _BannerAdWidgetState();
}
```

Key behaviors:
- Returns `SizedBox.shrink()` if user is ad-free or ad failed to load.
- Loads adaptive banner on `initState` using screen width from `MediaQuery`.
- Wraps `AdWidget` in a `SizedBox` matching the ad's dimensions.
- Wrapped in `SafeArea` with bottom padding to avoid system nav overlap.
- Disposes the ad on widget disposal.

### 5. Interstitial Ad Logic

No dedicated widget needed -- interstitials are full-screen overlays managed by the ad SDK. The logic lives in `AdService` and is triggered from navigation callbacks.

The interstitial trigger point is the `onDone` and `onStop` callbacks in `TimerScreen` that navigate back to home (`context.go('/')`). A wrapper method handles:

1. Check `isAdFree` -- if true, skip.
2. Check cooldown -- if less than 3 minutes since last interstitial, skip.
3. Show interstitial if loaded.
4. Pre-load next interstitial after the current one is dismissed.
5. Navigate to home regardless of whether ad was shown.

### 6. Home Screen Integration

Modify `SessionListScreen` to include the banner ad at the bottom:

- Wrap the existing `Scaffold` body in a `Column` with the `ListView` in an `Expanded` widget.
- Add `BannerAdWidget()` at the bottom of the `Column`, outside the scrollable area.
- The banner only renders if the user is NOT ad-free and an ad is loaded.

### 7. Settings Screen Integration

Add to `SettingsScreen`:

- A new section header: "Subscription" (or localized equivalent).
- If NOT ad-free: A `ListTile` with "Remove Ads - $2.99" that triggers `PurchaseService.purchaseRemoveAds()`.
- If ad-free: A `ListTile` showing "Ad-Free" with a checkmark icon (non-interactive).
- A `ListTile` "Restore Purchases" that calls `PurchaseService.restorePurchases()`. Always visible regardless of ad-free status (Apple requirement).

### 8. Platform Configuration

#### Android: `android/app/src/main/AndroidManifest.xml`

Add inside `<application>`:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-3940256099942544~3347511713"/>
```
(Use test app ID during development. Replace with production ID before release.)

#### iOS: `ios/Runner/Info.plist`

Add the following keys:
```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>

<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>

<key>SKAdNetworkItems</key>
<array>
  <dict>
    <key>SKAdNetworkIdentifier</key>
    <string>cstr6suwn9.skadnetwork</string>
  </dict>
</array>
```
(Use test app ID during development. Replace with production ID before release.)

### 9. App Initialization Updates (`lib/main.dart`)

Add to the `main()` function, after existing initialization:

```dart
// Initialize Mobile Ads SDK
await MobileAds.instance.initialize();

// Initialize ad and purchase services
final adService = AdService();
final purchaseService = PurchaseService(settingsBox);
await purchaseService.initialize();
```

Add provider overrides in `ProviderScope`:
```dart
adServiceProvider.overrideWithValue(adService),
purchaseServiceProvider.overrideWithValue(purchaseService),
isAdFreeProvider.overrideWith((ref) => purchaseService.isAdFree),
```

### 10. Test Mode Configuration

For development, use a centralized config class:

```dart
/// lib/features/ads/data/ad_config.dart
class AdConfig {
  AdConfig._();

  /// Set to false for production builds.
  static const bool testMode = true;

  // --- Test Ad Unit IDs (Google-provided, safe for development) ---
  static const String testBannerAndroid = 'ca-app-pub-3940256099942544/6300978111';
  static const String testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const String testInterstitialAndroid = 'ca-app-pub-3940256099942544/1033173712';
  static const String testInterstitialIos = 'ca-app-pub-3940256099942544/4411468910';

  // --- Production Ad Unit IDs (replace before release) ---
  static const String prodBannerAndroid = 'YOUR_BANNER_ANDROID_ID';
  static const String prodBannerIos = 'YOUR_BANNER_IOS_ID';
  static const String prodInterstitialAndroid = 'YOUR_INTERSTITIAL_ANDROID_ID';
  static const String prodInterstitialIos = 'YOUR_INTERSTITIAL_IOS_ID';

  static String get bannerAdUnitId {
    if (testMode) {
      return Platform.isAndroid ? testBannerAndroid : testBannerIos;
    }
    return Platform.isAndroid ? prodBannerAndroid : prodBannerIos;
  }

  static String get interstitialAdUnitId {
    if (testMode) {
      return Platform.isAndroid ? testInterstitialAndroid : testInterstitialIos;
    }
    return Platform.isAndroid ? prodInterstitialAndroid : prodInterstitialIos;
  }

  /// IAP product ID -- must match store configuration exactly.
  static const String removeAdsProductId = 'remove_ads';
}
```

---

## Ad Placement Map

```
Screen                      Ad Type          Position / Trigger
─────────────────────────── ──────────────── ─────────────────────────────────────
SessionListScreen (Home)    Adaptive Banner  Anchored at bottom, below session list
TimerScreen (pre-start)     NONE             No ads on session summary view
TimerScreen (active)        NONE             No ads during warmup/work/rest/pause
TimerScreen (complete)      NONE             No ads on completion overlay
TimerScreen -> Home nav     Interstitial     Shown on navigate-back after workout
                                             ends or is stopped (3-min cooldown)
SessionEditorScreen         NONE             No ads during session creation/editing
SettingsScreen              NONE             No ads; contains "Remove Ads" purchase
HistoryScreen               NONE             No ads on training history
```

Visual layout of home screen with banner:

```
┌─────────────────────────────┐
│    [History]  [Settings]    │
│                             │
│         B O X I N G         │
│     ────── ● ──────         │
│     TRAINING TIMER          │
│                             │
│  [In Progress Card]         │
│                             │
│  My Sessions                │
│  ┌─────────────────────┐    │
│  │ Session Card         │    │
│  └─────────────────────┘    │
│                             │
│  Quick Start                │
│  [Card] [Card] [Card]       │
│                             │
│  Presets                    │
│  > Boxing (3)               │
│  > Bag Work (2)             │
│  ...                        │
│                             │ ← Scrollable content ends here
├─────────────────────────────┤
│  ┌─────────────────────┐    │ ← Fixed banner ad (adaptive height)
│  │   BANNER AD          │    │    Hidden if ad-free or load failed
│  └─────────────────────┘    │
└─────────────────────────────┘
```

---

## Data Model Changes

### AppSettings (`lib/features/settings/domain/app_settings.dart`)

Add one field to the existing `AppSettings` freezed model:

```dart
@Default(false) bool isAdFree,
```

This field is persisted in Hive and acts as a cache so the app can immediately hide ads on startup without waiting for the store query. It is set to `true` when a purchase is confirmed or restored, and never set back to `false`.

### No Other Model Changes

The ad system is self-contained. No changes to `SessionModel`, `TimerState`, `TimerPhase`, or any other existing model.

---

## Dependencies

Add to `pubspec.yaml` under `dependencies`:

```yaml
google_mobile_ads: ^6.0.0
in_app_purchase: ^3.2.0
app_tracking_transparency: ^2.0.6
```

No new dev_dependencies are needed.

---

## File Changes

### New Files to Create

| File | Purpose |
|------|---------|
| `lib/features/ads/data/ad_config.dart` | Ad unit IDs, test/prod toggle, IAP product ID |
| `lib/features/ads/data/ad_service.dart` | Banner and interstitial ad lifecycle management |
| `lib/features/ads/data/purchase_service.dart` | In-app purchase for ad removal |
| `lib/features/ads/presentation/ads_controller.dart` | Riverpod providers for ads and purchase state |
| `lib/features/ads/presentation/widgets/banner_ad_widget.dart` | Reusable banner ad widget for home screen |

### Existing Files to Modify

| File | Changes |
|------|---------|
| `pubspec.yaml` | Add `google_mobile_ads`, `in_app_purchase`, `app_tracking_transparency` |
| `lib/main.dart` | Initialize `MobileAds`, create `AdService` and `PurchaseService`, add provider overrides |
| `lib/features/settings/domain/app_settings.dart` | Add `isAdFree` field (bool, default false) |
| `lib/features/settings/domain/app_settings.freezed.dart` | Re-generate after model change (`dart run build_runner build`) |
| `lib/features/settings/domain/app_settings.g.dart` | Re-generate after model change |
| `lib/features/sessions/presentation/session_list_screen.dart` | Wrap body in Column, add `BannerAdWidget` at bottom |
| `lib/features/settings/presentation/settings_screen.dart` | Add "Remove Ads" / "Restore Purchases" section |
| `lib/features/timer/presentation/timer_screen.dart` | Trigger interstitial on `onDone` / `onStop` navigation back to home |
| `android/app/src/main/AndroidManifest.xml` | Add AdMob Application ID `<meta-data>` tag |
| `ios/Runner/Info.plist` | Add `GADApplicationIdentifier`, `NSUserTrackingUsageDescription`, `SKAdNetworkItems` |
| `lib/l10n/app_en.arb` (and `app_es.arb`, `app_pt.arb`) | Add localization strings for ads section in settings |

### Localization Strings to Add

Add to each `.arb` file (English shown):

```json
"sectionSubscription": "Subscription",
"removeAdsTitle": "Remove Ads",
"removeAdsSubtitle": "One-time purchase to remove all ads",
"removeAdsPrice": "Remove Ads - {price}",
"@removeAdsPrice": { "placeholders": { "price": { "type": "String" } } },
"adFreeStatus": "Ad-Free",
"adFreeDescription": "Thank you for your purchase!",
"restorePurchases": "Restore Purchases",
"restorePurchasesDescription": "Restore a previous ad removal purchase",
"purchaseRestored": "Purchase restored successfully",
"purchaseRestoredNone": "No previous purchases found",
"purchaseError": "Purchase failed. Please try again.",
"purchasePending": "Purchase pending..."
```

---

## Detailed Implementation Patterns

### AdService Implementation Pattern

```dart
// lib/features/ads/data/ad_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:boxing/features/ads/data/ad_config.dart';

class AdService {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  bool _isBannerLoaded = false;
  bool _isInterstitialLoaded = false;
  DateTime? _lastInterstitialShown;
  bool Function() _isAdFreeCheck = () => false;

  static const _interstitialCooldown = Duration(minutes: 3);

  /// Set a callback to check ad-free status.
  void setAdFreeCheck(bool Function() check) {
    _isAdFreeCheck = check;
  }

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  Future<void> loadBannerAd(double screenWidth) async {
    if (_isAdFreeCheck()) return;

    final adSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      screenWidth.truncate(),
    );
    if (adSize == null) return;

    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isBannerLoaded = true;
          _onBannerLoaded?.call(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: $error');
          _isBannerLoaded = false;
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  // Callback for notifying the UI when banner loads
  void Function(BannerAd)? _onBannerLoaded;
  set onBannerLoaded(void Function(BannerAd)? callback) =>
      _onBannerLoaded = callback;

  BannerAd? get bannerAd => _isBannerLoaded ? _bannerAd : null;

  Future<void> preloadInterstitial() async {
    if (_isAdFreeCheck()) return;
    if (_isInterstitialLoaded) return;

    await InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: $error');
          _isInterstitialLoaded = false;
        },
      ),
    );
  }

  Future<bool> showInterstitialIfReady() async {
    if (_isAdFreeCheck()) return false;
    if (!_isInterstitialLoaded || _interstitialAd == null) return false;

    // Enforce cooldown
    if (_lastInterstitialShown != null) {
      final elapsed = DateTime.now().difference(_lastInterstitialShown!);
      if (elapsed < _interstitialCooldown) return false;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialLoaded = false;
        // Pre-load next interstitial
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial failed to show: $error');
        ad.dispose();
        _interstitialAd = null;
        _isInterstitialLoaded = false;
        preloadInterstitial();
      },
    );

    await _interstitialAd!.show();
    _lastInterstitialShown = DateTime.now();
    return true;
  }

  void disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isBannerLoaded = false;
  }

  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _bannerAd = null;
    _interstitialAd = null;
    _isBannerLoaded = false;
    _isInterstitialLoaded = false;
  }
}
```

### PurchaseService Implementation Pattern

```dart
// lib/features/ads/data/purchase_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:boxing/features/ads/data/ad_config.dart';

class PurchaseService {
  final Box<String> _settingsBox;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _isAdFree = false;
  ProductDetails? _removeAdsProduct;

  static const _adFreeKey = 'is_ad_free';

  PurchaseService(this._settingsBox);

  bool get isAdFree => _isAdFree;

  /// Called when purchase status changes. Set by the controller.
  VoidCallback? onPurchaseStatusChanged;

  Future<void> initialize() async {
    // Check cached status first for instant UI
    _isAdFree = _settingsBox.get(_adFreeKey) == 'true';

    final available = await InAppPurchase.instance.isAvailable();
    if (!available) return;

    // Listen to purchase updates
    _subscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        debugPrint('Purchase stream error: $error');
      },
    );

    // Query product details
    final response = await InAppPurchase.instance.queryProductDetails(
      {AdConfig.removeAdsProductId},
    );
    if (response.productDetails.isNotEmpty) {
      _removeAdsProduct = response.productDetails.first;
    }
  }

  ProductDetails? get removeAdsProduct => _removeAdsProduct;

  Future<bool> purchaseRemoveAds() async {
    if (_removeAdsProduct == null) return false;
    final purchaseParam = PurchaseParam(
      productDetails: _removeAdsProduct!,
    );
    return InAppPurchase.instance.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  Future<void> restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final details in purchaseDetailsList) {
      if (details.productID != AdConfig.removeAdsProductId) continue;

      switch (details.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _setAdFree(true);
          if (details.pendingCompletePurchase) {
            InAppPurchase.instance.completePurchase(details);
          }
          break;
        case PurchaseStatus.error:
          debugPrint('Purchase error: ${details.error}');
          break;
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.canceled:
          break;
      }
    }
  }

  void _setAdFree(bool value) {
    _isAdFree = value;
    _settingsBox.put(_adFreeKey, value.toString());
    onPurchaseStatusChanged?.call();
  }

  void dispose() {
    _subscription?.cancel();
  }
}
```

### Timer Screen Interstitial Trigger Pattern

In `_TimerScreenState`, modify the `onDone` and end-of-workout callbacks:

```dart
// In timer_screen.dart, the onDone and onStop callbacks become:

void _navigateHomeWithAd() async {
  final adService = ref.read(adServiceProvider);
  // Show interstitial at natural transition (workout just ended)
  await adService.showInterstitialIfReady();
  if (mounted) {
    context.go('/');
  }
}

// Then use _navigateHomeWithAd() in place of context.go('/') in:
// - onDone callback (session complete -> go home)
// - onStop dialog "End" button (user stops early -> go home)
// Do NOT show interstitial on "Save & Exit" (user intends to resume)
```

### Home Screen Banner Integration Pattern

```dart
// In session_list_screen.dart, modify the Scaffold body:

// Before (current):
body: SafeArea(
  child: ListView(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    children: [ /* existing content */ ],
  ),
),

// After (with banner):
body: SafeArea(
  child: Column(
    children: [
      Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [ /* existing content */ ],
        ),
      ),
      const BannerAdWidget(), // Shows nothing if ad-free
    ],
  ),
),
```

### Settings Screen Purchase Section Pattern

```dart
// Add after the existing _SectionHeader(s.sectionAbout) and its children:

_SectionHeader(s.sectionSubscription),

if (!ref.watch(isAdFreeProvider))
  ListTile(
    leading: const Icon(Icons.remove_circle_outline),
    title: Text(s.removeAdsTitle),
    subtitle: Text(s.removeAdsSubtitle),
    trailing: FilledButton(
      onPressed: () async {
        final purchaseService = ref.read(purchaseServiceProvider);
        await purchaseService.purchaseRemoveAds();
      },
      child: Text(
        purchaseService.removeAdsProduct?.price ?? '\$2.99',
      ),
    ),
  )
else
  ListTile(
    leading: const Icon(Icons.check_circle, color: Colors.green),
    title: Text(s.adFreeStatus),
    subtitle: Text(s.adFreeDescription),
  ),

ListTile(
  leading: const Icon(Icons.restore),
  title: Text(s.restorePurchases),
  subtitle: Text(s.restorePurchasesDescription),
  onTap: () async {
    final purchaseService = ref.read(purchaseServiceProvider);
    await purchaseService.restorePurchases();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.purchaseRestored)),
      );
    }
  },
),
```

---

## iOS App Tracking Transparency (ATT)

On iOS 14.5+, requesting ATT permission before loading ads improves ad revenue significantly (personalized ads have 2-4x higher eCPM).

### Implementation

In `main.dart`, after `MobileAds.instance.initialize()`:

```dart
// Request ATT permission on iOS before loading ads
if (Platform.isIOS) {
  final status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    // Slight delay recommended by Apple for better UX
    await Future.delayed(const Duration(seconds: 1));
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}
```

The ATT dialog will show once. If denied, ads still show but with lower eCPM (non-personalized). The app works identically regardless of the user's choice.

---

## Acceptance Criteria

- [ ] `google_mobile_ads`, `in_app_purchase`, and `app_tracking_transparency` added to `pubspec.yaml` and resolve successfully
- [ ] `flutter analyze` passes with zero errors
- [ ] `flutter build apk --debug` succeeds with ads integration
- [ ] `flutter build ios --no-codesign` succeeds with ads integration
- [ ] AdMob SDK initializes on app launch (verified via debug log)
- [ ] Adaptive banner ad loads and displays at the bottom of the home screen
- [ ] Banner ad is NOT visible on timer screen, session editor, settings, or history screens
- [ ] Banner ad disappears immediately when user purchases ad removal
- [ ] Interstitial ad shows after a workout completes and user navigates to home
- [ ] Interstitial does NOT show if less than 3 minutes since the last one
- [ ] Interstitial does NOT show on first app launch
- [ ] Interstitial does NOT show during "Save & Exit" flow
- [ ] Interstitial does NOT show if user is ad-free
- [ ] "Remove Ads" button appears in Settings for non-ad-free users
- [ ] "Remove Ads" purchase flow completes successfully (test with sandbox)
- [ ] After purchase, all ads stop showing immediately
- [ ] "Restore Purchases" button works and restores ad-free status
- [ ] Ad-free status persists across app restarts (cached in Hive)
- [ ] No ads appear at any point during active timer operation (warmup, work, rest, pause, complete)
- [ ] Test ad IDs are used during development (no real impressions)
- [ ] App does not crash if ad loading fails (graceful degradation)
- [ ] ATT dialog appears on first iOS launch
- [ ] All new UI strings are localized (EN, ES, PT)

---

## Risk Register

| Risk | Impact | Mitigation |
|------|--------|------------|
| AdMob account suspension from test traffic | Critical | Use Google-provided test ad IDs exclusively during development; never ship with test IDs |
| Ad loading fails on poor network | Low | Graceful fallback: hide banner, skip interstitial. App works perfectly without ads |
| IAP purchase not completing | Medium | Cache ad-free status in Hive; listen to purchase stream on every app launch to catch delayed completions |
| iOS ATT denial tanks ad revenue | Medium | Non-personalized ads still serve; ATT is optional for users. Revenue reduced but not eliminated |
| Interstitial interrupts post-workout user flow | Medium | 3-minute cooldown prevents spam; interstitial only at natural transition (workout done -> home) |
| Banner ad shifts home screen layout | Low | Use fixed-position banner outside `ListView`; content scroll area shrinks but layout stays stable |
| Google Play / App Store rejection | Low | Follow all platform ad policies; no ads in active workout; ATT implemented for iOS |

---

## Sprint Dependencies

```
Sprint 0-6 (All existing sprints)
    │
    ▼
Sprint 7 (Ads & Monetization)
    │
    └── Depends on: Home screen, Timer screen, Settings screen, Hive storage
        (all delivered in Sprints 0-5)
```

This sprint has no blockers and can begin as soon as an AdMob account is created and app IDs are generated. Development uses test IDs, so the AdMob account is only needed before release.
