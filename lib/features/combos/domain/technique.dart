/// Category of a combat technique.
enum TechniqueCategory { punch, defense, footwork, kick, elbow, knee, other }

/// A single technique that can appear in a combo sequence.
///
/// Techniques are the atomic units of the combo system. Each has a short
/// [displayText] for the timer screen UI and locale-keyed [ttsText] for
/// voice callouts.
class Technique {
  /// Unique identifier, e.g. '1', '2', '3b', 'slip_r', 'lk'.
  final String id;

  /// Short text shown on-screen, e.g. '1', 'SR', 'LK'.
  final String displayText;

  /// Locale code -> spoken text for TTS. Keys: 'en', 'es', 'pt'.
  final Map<String, String> ttsText;

  /// What kind of technique this is.
  final TechniqueCategory category;

  const Technique({
    required this.id,
    required this.displayText,
    required this.ttsText,
    required this.category,
  });
}
