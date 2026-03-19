import 'package:boxing/features/combos/domain/technique.dart';

/// Difficulty tier for a combo.
enum ComboDifficulty { beginner, intermediate, advanced }

/// Sport that a combo belongs to.
enum ComboSport { boxing, muayThai, mma, kickboxing, bjj, wrestling, defense, footwork }

/// A combo is an ordered sequence of technique IDs.
///
/// Plain Dart class (not freezed) because there are 100+ built-in combos
/// and code-gen overhead is unnecessary for static const data.
class Combo {
  /// Unique identifier, e.g. 'B1', 'MT-I3', 'D7'.
  final String id;

  /// Ordered list of technique IDs that make up this combo.
  final List<String> techniqueIds;

  /// How hard this combo is to execute.
  final ComboDifficulty difficulty;

  /// Which sport this combo belongs to.
  final ComboSport sport;

  /// Whether this is a user-created combo (false for built-in library).
  final bool isCustom;

  const Combo({
    required this.id,
    required this.techniqueIds,
    required this.difficulty,
    required this.sport,
    this.isCustom = false,
  });

  /// Build display text from technique IDs, e.g. '1-2-3-LK'.
  String displayText(Map<String, Technique> techniques) {
    return techniqueIds
        .map((id) => techniques[id]?.displayText ?? id)
        .join('-');
  }

  /// Build TTS text for a locale, e.g. 'Jab, Cross, Hook, Low kick'.
  String ttsTextForLocale(Map<String, Technique> techniques, String locale) {
    return techniqueIds.map((id) {
      final t = techniques[id];
      return t?.ttsText[locale] ?? t?.ttsText['en'] ?? id;
    }).join(', ');
  }
}
