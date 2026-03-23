/// Rich educational content for a single technique.
///
/// Links to a [Technique] via [techniqueId] and provides localized
/// descriptions, form cues, related techniques, and optional media.
class TechniqueGuide {
  /// Links to [Technique.id], e.g. '1', 'slip_r', 'lk'.
  final String techniqueId;

  /// Locale code -> descriptive paragraph. Keys: 'en', 'es', 'pt'.
  final Map<String, String> description;

  /// Locale code -> ordered bullet points for proper form.
  final Map<String, List<String>> formPoints;

  /// IDs of related techniques for cross-referencing.
  final List<String> relatedTechniqueIds;

  /// Path to an asset image (null until images are added).
  final String? imageAssetPath;

  /// YouTube tutorial URL (null until curated).
  final String? videoUrl;

  const TechniqueGuide({
    required this.techniqueId,
    required this.description,
    required this.formPoints,
    this.relatedTechniqueIds = const [],
    this.imageAssetPath,
    this.videoUrl,
  });
}
