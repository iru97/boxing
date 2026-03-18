import 'dart:ui';

import 'package:boxing/core/theme/app_colors.dart';
import 'package:boxing/features/sessions/domain/session_model.dart';

enum SessionCategory {
  boxing('Boxing', CategoryColors.boxing),
  bagWork('Bag Work', CategoryColors.bagWork),
  conditioning('Conditioning', CategoryColors.conditioning),
  combatSport('Combat Sport', CategoryColors.combatSport),
  beginner('Beginner', CategoryColors.beginner),
  compound('Compound', CategoryColors.bagWork),
  custom('My Sessions', CategoryColors.custom);

  const SessionCategory(this.label, this.color);
  final String label;
  final Color color;
}

/// Maps sessions to their category.
SessionCategory categoryFor(SessionModel session) {
  if (!session.isPreset) return SessionCategory.custom;

  return switch (session.id) {
    'preset_pro_boxing_men' ||
    'preset_pro_boxing_women' ||
    'preset_amateur_boxing' ||
    'preset_amateur_women' ||
    'preset_sparring' ||
    'preset_pad_work' =>
      SessionCategory.boxing,
    'preset_heavy_bag' || 'preset_speed_bag' => SessionCategory.bagWork,
    'preset_conditioning' ||
    'preset_tabata' ||
    'preset_emom' =>
      SessionCategory.conditioning,
    'preset_muay_thai' ||
    'preset_mma' ||
    'preset_kickboxing' =>
      SessionCategory.combatSport,
    'preset_beginner' ||
    'preset_youth_boxing' ||
    'preset_shadow_boxing' =>
      SessionCategory.beginner,
    'preset_offense_defense' ||
    'preset_bag_conditioning' ||
    'preset_burnout' =>
      SessionCategory.compound,
    _ => SessionCategory.custom,
  };
}

/// Legacy helper — returns just the color.
Color categoryColorFor(SessionModel session) => categoryFor(session).color;

/// Groups preset sessions by category, preserving category order.
List<(SessionCategory, List<SessionModel>)> groupPresetsByCategory(
    List<SessionModel> presets) {
  final order = [
    SessionCategory.boxing,
    SessionCategory.bagWork,
    SessionCategory.conditioning,
    SessionCategory.combatSport,
    SessionCategory.beginner,
    SessionCategory.compound,
  ];

  final groups = <SessionCategory, List<SessionModel>>{};
  for (final session in presets) {
    final cat = categoryFor(session);
    (groups[cat] ??= []).add(session);
  }

  return [
    for (final cat in order)
      if (groups.containsKey(cat)) (cat, groups[cat]!),
  ];
}
