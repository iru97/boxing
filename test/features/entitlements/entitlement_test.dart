import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:boxing/features/combos/domain/combo_callout_config.dart';
import 'package:boxing/features/combos/presentation/combo_callout_provider.dart';
import 'package:boxing/features/entitlements/data/entitlement_config.dart';
import 'package:boxing/features/entitlements/domain/entitlement_status.dart';
import 'package:boxing/features/entitlements/presentation/entitlement_provider.dart';

void main() {
  // ---------------------------------------------------------------------------
  // EntitlementStatus
  // ---------------------------------------------------------------------------

  group('EntitlementStatus - empty constant', () {
    test('has all false boolean fields', () {
      expect(EntitlementStatus.empty.adsRemoved, false);
      expect(EntitlementStatus.empty.comboPack, false);
      expect(EntitlementStatus.empty.programsPack, false);
      expect(EntitlementStatus.empty.everythingBundle, false);
    });

    test('has empty sportPacks map', () {
      expect(EntitlementStatus.empty.sportPacks, isEmpty);
    });
  });

  group('EntitlementStatus - hasComboAccess', () {
    test('true when comboPack is true', () {
      const status = EntitlementStatus(comboPack: true);
      expect(status.hasComboAccess, true);
    });

    test('true when everythingBundle is true', () {
      const status = EntitlementStatus(everythingBundle: true);
      expect(status.hasComboAccess, true);
    });

    test('false when neither comboPack nor everythingBundle', () {
      const status = EntitlementStatus(adsRemoved: true, programsPack: true);
      expect(status.hasComboAccess, false);
    });
  });

  group('EntitlementStatus - hasProgramsAccess', () {
    test('true when programsPack is true', () {
      const status = EntitlementStatus(programsPack: true);
      expect(status.hasProgramsAccess, true);
    });

    test('true when everythingBundle is true', () {
      const status = EntitlementStatus(everythingBundle: true);
      expect(status.hasProgramsAccess, true);
    });

    test('false when neither programsPack nor everythingBundle', () {
      const status = EntitlementStatus(adsRemoved: true, comboPack: true);
      expect(status.hasProgramsAccess, false);
    });
  });

  group('EntitlementStatus - sportPackOwned', () {
    test('true when sport is in sportPacks and set to true', () {
      const status = EntitlementStatus(sportPacks: {'boxing': true});
      expect(status.sportPackOwned('boxing'), true);
    });

    test('false when sport is not in sportPacks', () {
      const status = EntitlementStatus(sportPacks: {'boxing': true});
      expect(status.sportPackOwned('muay_thai'), false);
    });

    test('false when sport is in sportPacks but set to false', () {
      const status = EntitlementStatus(sportPacks: {'boxing': false});
      expect(status.sportPackOwned('boxing'), false);
    });

    test('true for any sport when everythingBundle is true', () {
      const status = EntitlementStatus(everythingBundle: true);
      expect(status.sportPackOwned('boxing'), true);
      expect(status.sportPackOwned('muay_thai'), true);
      expect(status.sportPackOwned('bjj'), true);
    });
  });

  group('EntitlementStatus - hasAnyPremium', () {
    test('true when adsRemoved is true', () {
      const status = EntitlementStatus(adsRemoved: true);
      expect(status.hasAnyPremium, true);
    });

    test('true when comboPack is true', () {
      const status = EntitlementStatus(comboPack: true);
      expect(status.hasAnyPremium, true);
    });

    test('true when programsPack is true', () {
      const status = EntitlementStatus(programsPack: true);
      expect(status.hasAnyPremium, true);
    });

    test('true when everythingBundle is true', () {
      const status = EntitlementStatus(everythingBundle: true);
      expect(status.hasAnyPremium, true);
    });

    test('true when sportPacks has a true entry', () {
      const status = EntitlementStatus(sportPacks: {'boxing': true});
      expect(status.hasAnyPremium, true);
    });

    test('false when everything is at default (empty)', () {
      expect(EntitlementStatus.empty.hasAnyPremium, false);
    });

    test('false when sportPacks only has false entries', () {
      const status = EntitlementStatus(sportPacks: {'boxing': false});
      expect(status.hasAnyPremium, false);
    });
  });

  group('EntitlementStatus - copyWith', () {
    test('preserves unmodified fields', () {
      const original = EntitlementStatus(
        adsRemoved: true,
        comboPack: true,
        programsPack: false,
        sportPacks: {'boxing': true},
        everythingBundle: false,
      );

      final copy = original.copyWith(programsPack: true);

      expect(copy.adsRemoved, original.adsRemoved);
      expect(copy.comboPack, original.comboPack);
      expect(copy.programsPack, true);
      expect(copy.sportPacks, original.sportPacks);
      expect(copy.everythingBundle, original.everythingBundle);
    });

    test('overwrites only the specified field', () {
      const original = EntitlementStatus(adsRemoved: false);
      final copy = original.copyWith(adsRemoved: true);

      expect(copy.adsRemoved, true);
      expect(copy.comboPack, false);
      expect(copy.programsPack, false);
      expect(copy.sportPacks, isEmpty);
      expect(copy.everythingBundle, false);
    });

    test('can update sportPacks map', () {
      const original = EntitlementStatus(sportPacks: {'boxing': true});
      final copy = original.copyWith(
        sportPacks: {'boxing': true, 'muay_thai': true},
      );

      expect(copy.sportPacks['boxing'], true);
      expect(copy.sportPacks['muay_thai'], true);
    });
  });

  group('EntitlementStatus - JSON roundtrip', () {
    test('toJson then fromJson preserves all fields', () {
      const original = EntitlementStatus(
        adsRemoved: true,
        comboPack: true,
        programsPack: false,
        sportPacks: {'boxing': true, 'muay_thai': false},
        everythingBundle: false,
      );

      final json = original.toJson();
      final restored = EntitlementStatus.fromJson(json);

      expect(restored.adsRemoved, original.adsRemoved);
      expect(restored.comboPack, original.comboPack);
      expect(restored.programsPack, original.programsPack);
      expect(restored.everythingBundle, original.everythingBundle);
    });

    test('sportPacks entries survive JSON roundtrip', () {
      const original = EntitlementStatus(
        sportPacks: {'boxing': true, 'muay_thai': false},
      );

      final json = original.toJson();
      final restored = EntitlementStatus.fromJson(json);

      expect(restored.sportPacks['boxing'], true);
      expect(restored.sportPacks['muay_thai'], false);
    });

    test('fromJson uses false defaults for missing boolean fields', () {
      final restored = EntitlementStatus.fromJson({});

      expect(restored.adsRemoved, false);
      expect(restored.comboPack, false);
      expect(restored.programsPack, false);
      expect(restored.everythingBundle, false);
      expect(restored.sportPacks, isEmpty);
    });

    test('roundtrip via jsonEncode / jsonDecode preserves all fields', () {
      const original = EntitlementStatus(
        adsRemoved: true,
        comboPack: true,
        programsPack: true,
        sportPacks: {'bjj': true},
        everythingBundle: true,
      );

      final encoded = jsonEncode(original.toJson());
      final restored = EntitlementStatus.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );

      expect(restored, original);
    });
  });

  group('EntitlementStatus - operator==', () {
    test('two equal instances compare as equal', () {
      const a = EntitlementStatus(adsRemoved: true, comboPack: true);
      const b = EntitlementStatus(adsRemoved: true, comboPack: true);
      expect(a, equals(b));
    });

    test('instances differing by adsRemoved are not equal', () {
      const a = EntitlementStatus(adsRemoved: true);
      const b = EntitlementStatus(adsRemoved: false);
      expect(a, isNot(equals(b)));
    });

    test('instances differing by comboPack are not equal', () {
      const a = EntitlementStatus(comboPack: true);
      const b = EntitlementStatus(comboPack: false);
      expect(a, isNot(equals(b)));
    });

    test('instances differing by sportPacks content are not equal', () {
      // mapEquals is used in ==, so different content means not equal
      const a = EntitlementStatus(sportPacks: {'boxing': true});
      const b = EntitlementStatus(sportPacks: {'boxing': false});
      expect(a, isNot(equals(b)));
    });

    test('instances with same sportPacks content are equal', () {
      const a = EntitlementStatus(sportPacks: {'boxing': true});
      const b = EntitlementStatus(sportPacks: {'boxing': true});
      expect(a, equals(b));
    });

    test('empty status equals empty constant', () {
      expect(const EntitlementStatus(), equals(EntitlementStatus.empty));
    });
  });

  group('EntitlementStatus - hashCode', () {
    test('equal objects have the same hashCode', () {
      const a = EntitlementStatus(adsRemoved: true, comboPack: true);
      const b = EntitlementStatus(adsRemoved: true, comboPack: true);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('hashCode is stable across multiple calls', () {
      const status = EntitlementStatus(
        adsRemoved: true,
        comboPack: true,
        sportPacks: {'boxing': true},
      );
      expect(status.hashCode, equals(status.hashCode));
    });
  });

  // ---------------------------------------------------------------------------
  // EntitlementConfig
  // ---------------------------------------------------------------------------

  group('EntitlementConfig - applyPurchase', () {
    test('removeAds sets adsRemoved=true', () {
      final result = EntitlementConfig.applyPurchase(
        EntitlementStatus.empty,
        EntitlementConfig.removeAds,
      );
      expect(result.adsRemoved, true);
      expect(result.comboPack, false);
      expect(result.programsPack, false);
      expect(result.everythingBundle, false);
    });

    test('comboPack sets comboPack=true', () {
      final result = EntitlementConfig.applyPurchase(
        EntitlementStatus.empty,
        EntitlementConfig.comboPack,
      );
      expect(result.comboPack, true);
      expect(result.adsRemoved, false);
    });

    test('programsPack sets programsPack=true', () {
      final result = EntitlementConfig.applyPurchase(
        EntitlementStatus.empty,
        EntitlementConfig.programsPack,
      );
      expect(result.programsPack, true);
      expect(result.comboPack, false);
    });

    test('everythingBundle sets adsRemoved, comboPack, programsPack and everythingBundle to true', () {
      final result = EntitlementConfig.applyPurchase(
        EntitlementStatus.empty,
        EntitlementConfig.everythingBundle,
      );
      expect(result.adsRemoved, true);
      expect(result.comboPack, true);
      expect(result.programsPack, true);
      expect(result.everythingBundle, true);
    });

    test('sport_pack_boxing sets sportPacks[boxing]=true', () {
      final result = EntitlementConfig.applyPurchase(
        EntitlementStatus.empty,
        'sport_pack_boxing',
      );
      expect(result.sportPacks['boxing'], true);
      expect(result.adsRemoved, false);
      expect(result.comboPack, false);
    });

    test('sport_pack_muay_thai sets sportPacks[muay_thai]=true', () {
      final result = EntitlementConfig.applyPurchase(
        EntitlementStatus.empty,
        'sport_pack_muay_thai',
      );
      expect(result.sportPacks['muay_thai'], true);
    });

    test('unknown product returns status unchanged', () {
      const original = EntitlementStatus(adsRemoved: true, comboPack: true);
      final result = EntitlementConfig.applyPurchase(original, 'unknown_product_xyz');
      expect(result, equals(original));
    });

    test('applyPurchase is additive — preserves existing entitlements', () {
      const existing = EntitlementStatus(adsRemoved: true);
      final result = EntitlementConfig.applyPurchase(
        existing,
        EntitlementConfig.comboPack,
      );
      expect(result.adsRemoved, true);
      expect(result.comboPack, true);
    });

    test('multiple applyPurchase calls accumulate correctly', () {
      var status = EntitlementStatus.empty;
      status = EntitlementConfig.applyPurchase(status, EntitlementConfig.removeAds);
      status = EntitlementConfig.applyPurchase(status, EntitlementConfig.comboPack);
      status = EntitlementConfig.applyPurchase(status, 'sport_pack_boxing');

      expect(status.adsRemoved, true);
      expect(status.comboPack, true);
      expect(status.programsPack, false);
      expect(status.everythingBundle, false);
      expect(status.sportPacks['boxing'], true);
    });

    test('sport_pack prefix strips correctly — sportId has no prefix', () {
      final result = EntitlementConfig.applyPurchase(
        EntitlementStatus.empty,
        'sport_pack_bjj',
      );
      // Key must be 'bjj', not 'sport_pack_bjj'
      expect(result.sportPacks.containsKey('bjj'), true);
      expect(result.sportPacks.containsKey('sport_pack_bjj'), false);
    });
  });

  // ---------------------------------------------------------------------------
  // effectiveComboConfigProvider degradation logic
  // ---------------------------------------------------------------------------

  group('effectiveComboConfigProvider - graceful degradation', () {
    /// Creates a ProviderContainer with entitlements overridden to the given status.
    ProviderContainer buildContainer(EntitlementStatus entitlements) {
      return ProviderContainer(
        overrides: [
          entitlementStatusProvider.overrideWith((ref) => entitlements),
        ],
      );
    }

    test('null config returns null', () {
      final container = buildContainer(EntitlementStatus.empty);
      addTearDown(container.dispose);

      final result = container.read(effectiveComboConfigProvider(null));
      expect(result, isNull);
    });

    test('beginner config returned unchanged when user has no combo access', () {
      final container = buildContainer(EntitlementStatus.empty);
      addTearDown(container.dispose);

      const config = ComboCalloutConfig(enabled: true, difficulty: 'beginner');
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result, isNotNull);
      expect(result!.difficulty, 'beginner');
    });

    test('beginner config returned unchanged when user has combo access', () {
      final container =
          buildContainer(const EntitlementStatus(comboPack: true));
      addTearDown(container.dispose);

      const config = ComboCalloutConfig(enabled: true, difficulty: 'beginner');
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result!.difficulty, 'beginner');
    });

    test('intermediate config returned unchanged when user has combo access (comboPack)', () {
      final container =
          buildContainer(const EntitlementStatus(comboPack: true));
      addTearDown(container.dispose);

      const config =
          ComboCalloutConfig(enabled: true, difficulty: 'intermediate');
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result!.difficulty, 'intermediate');
    });

    test('intermediate config returned unchanged when user has combo access (everythingBundle)', () {
      final container =
          buildContainer(const EntitlementStatus(everythingBundle: true));
      addTearDown(container.dispose);

      const config =
          ComboCalloutConfig(enabled: true, difficulty: 'intermediate');
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result!.difficulty, 'intermediate');
    });

    test('intermediate config downgraded to beginner when user has no combo access', () {
      final container = buildContainer(EntitlementStatus.empty);
      addTearDown(container.dispose);

      const config =
          ComboCalloutConfig(enabled: true, difficulty: 'intermediate');
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result, isNotNull);
      expect(result!.difficulty, 'beginner');
    });

    test('advanced config downgraded to beginner when user has no combo access', () {
      final container = buildContainer(EntitlementStatus.empty);
      addTearDown(container.dispose);

      const config = ComboCalloutConfig(enabled: true, difficulty: 'advanced');
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result!.difficulty, 'beginner');
    });

    test('advanced config returned unchanged when user has combo access', () {
      final container =
          buildContainer(const EntitlementStatus(comboPack: true));
      addTearDown(container.dispose);

      const config = ComboCalloutConfig(enabled: true, difficulty: 'advanced');
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result!.difficulty, 'advanced');
    });

    test('degradation preserves all other config fields unchanged', () {
      final container = buildContainer(EntitlementStatus.empty);
      addTearDown(container.dispose);

      const config = ComboCalloutConfig(
        enabled: true,
        sport: 'muay_thai',
        difficulty: 'advanced',
        intensity: 'intense',
        includeDefense: false,
        includeFootwork: true,
        calloutStyle: 'names',
        enableCoachEncouragement: false,
      );
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result!.difficulty, 'beginner'); // downgraded
      expect(result.sport, 'muay_thai');
      expect(result.enabled, true);
      expect(result.intensity, 'intense');
      expect(result.includeDefense, false);
      expect(result.includeFootwork, true);
      expect(result.calloutStyle, 'names');
      expect(result.enableCoachEncouragement, false);
    });

    test('adsRemoved only does not grant combo access — still degrades', () {
      final container =
          buildContainer(const EntitlementStatus(adsRemoved: true));
      addTearDown(container.dispose);

      const config =
          ComboCalloutConfig(enabled: true, difficulty: 'advanced');
      final result = container.read(effectiveComboConfigProvider(config));

      expect(result!.difficulty, 'beginner');
    });
  });
}
