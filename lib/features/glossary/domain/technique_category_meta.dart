import 'package:flutter/material.dart';

import 'package:boxing/features/combos/domain/technique.dart';

/// Visual metadata for each [TechniqueCategory].
///
/// Maps categories to a color, icon, and localization key used by the
/// glossary screen for filter chips and section headers.
class TechniqueCategoryMeta {
  final Color color;
  final IconData icon;

  /// Key used to look up the localized category name.
  final String labelKey;

  const TechniqueCategoryMeta({
    required this.color,
    required this.icon,
    required this.labelKey,
  });

  /// Metadata for every [TechniqueCategory].
  static const Map<TechniqueCategory, TechniqueCategoryMeta> all = {
    TechniqueCategory.punch: TechniqueCategoryMeta(
      color: Color(0xFF4CAF50), // green
      icon: Icons.sports_mma,
      labelKey: 'punch',
    ),
    TechniqueCategory.defense: TechniqueCategoryMeta(
      color: Color(0xFF1E88E5), // blue
      icon: Icons.shield,
      labelKey: 'defense',
    ),
    TechniqueCategory.footwork: TechniqueCategoryMeta(
      color: Color(0xFFFFB300), // amber
      icon: Icons.directions_walk,
      labelKey: 'footwork',
    ),
    TechniqueCategory.kick: TechniqueCategoryMeta(
      color: Color(0xFFFF7043), // orange
      icon: Icons.sports_martial_arts,
      labelKey: 'kick',
    ),
    TechniqueCategory.elbow: TechniqueCategoryMeta(
      color: Color(0xFFE53935), // red
      icon: Icons.sports_mma,
      labelKey: 'elbow',
    ),
    TechniqueCategory.knee: TechniqueCategoryMeta(
      color: Color(0xFF7E57C2), // purple
      icon: Icons.sports_martial_arts,
      labelKey: 'knee',
    ),
    TechniqueCategory.grappling: TechniqueCategoryMeta(
      color: Color(0xFFFFA726), // amber-gold
      icon: Icons.sports_kabaddi,
      labelKey: 'grappling',
    ),
    TechniqueCategory.other: TechniqueCategoryMeta(
      color: Color(0xFF9E9E9E), // grey
      icon: Icons.fitness_center,
      labelKey: 'other',
    ),
  };
}
